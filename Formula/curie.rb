require 'formula'

class Curie < Formula
  class Perl510 < Requirement
    fatal true

    satisfy do
      `perl -E 'print $]'`.to_f >= 5.01000
    end

    def message
      "Curie requires Perl 5.10.0 or greater."
    end
  end

  homepage   'https://project-renard.github.io/'
  desc "Document reader component from Project Renard"
  version    '0.002'
  #url        "http://cpan.cpantesters.org/authors/id/Z/ZM/ZMUGHAL/Renard-Curie-#{stable.version}.tar.gz"
  url        "https://cpan.metacpan.org/authors/id/Z/ZM/ZMUGHAL/Renard-Curie-#{stable.version}.tar.gz"
  sha256     'c2a7673dfd34a335ed4ea61d7105c9b96163ce6b98b10ca5a764d5fd6598a42c'
  head       'https://github.com/project-renard/curie.git'
  depends_on Perl510
  depends_on 'curie_dependencies'

  def install
    arch  = %x(perl -MConfig -E 'print $Config{archname}')
    plib  = "#{HOMEBREW_PREFIX}/lib/perl5"
    ENV['PERL5LIB'] = "#{plib}:#{plib}/#{arch}:#{lib}:#{lib}/#{arch}"
    ENV['PATH'] = "#{ENV['PATH']}:#{HOMEBREW_PREFIX}/bin"
    ENV.remove_from_cflags(/-march=\w+/)
    ENV.remove_from_cflags(/-msse\d?/)
    if build.head? || build.devel?
      plib = "#{prefix}/lib/perl5"
      ENV['PERL5LIB'] = "#{ENV['PERL5LIB']}:#{plib}:#{plib}/#{arch}:#{lib}:#{lib}/#{arch}"
      ENV['PATH'] = "#{ENV['PATH']}:#{prefix}/bin"
      system 'echo Append Formula/curie.rb'
      system 'echo PERL5LIB=$PERL5LIB'
    end

    system "cpanm --local-lib '#{prefix}' --notest Moose Function::Parameters"
    system "cpanm --local-lib '#{prefix}' --notest --installdeps ."
    if build.head? || build.devel?
      # Install any missing dependencies.
      system "cpanm --local-lib '#{prefix}' --notest Dist::Zilla"
      %w{authordeps}.each do |cmd|
        system "dzil #{cmd} | grep -v '^Possibly harmless' | cpanm --local-lib '#{prefix}' --notest"
      end

      # Build it in curie-HEAD and then cd into it.
      system "dzil build --in curie-HEAD"
      Dir.chdir 'curie-HEAD'

      # Remove perllocal.pod, simce it just gets in the way of other modules.
      rm "#{prefix}/lib/perl5/#{arch}/perllocal.pod", :force => true
    end

    system "cpanm --local-lib '#{prefix}' --notest --installdeps ."
    system "perl Makefile.PL INSTALL_BASE='#{prefix}'"
    system "make"

    # Add the Homebrew Perl lib dirs to curie.
    inreplace 'blib/script/curie' do |s|
      s.sub! /use /, "use lib '#{plib}', '#{plib}/#{arch}';\nuse "
      if `perl -E 'print $]'`.to_f == 5.01000
        s.sub!(/ -CAS/, '')
      end
    end

    system "make install"
  end

  test do
    expected_version = stable.version.to_s
    got_version = shell_output("#{bin}/curie --version")
    assert_match expected_version, got_version
  end
end
