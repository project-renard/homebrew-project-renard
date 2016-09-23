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
  version    '0.001'
  url        "http://cpan.cpantesters.org/authors/id/Z/ZM/ZMUGHAL/Renard-Curie-#{stable.version}.tar.gz"
  sha256     '7c86ad5852bf84c00135b7c5437472d4e3b365fcc0415bc7dc6cb1c46367f04a'
  head       'https://github.com/project-renard/curie.git'
  depends_on Perl510
  depends_on 'curie_dependencies'

  if build.head? || build.devel?
    depends_on 'curie_maint_depends'
  end

  def install
    arch  = %x(perl -MConfig -E 'print $Config{archname}')
    plib  = "#{HOMEBREW_PREFIX}/lib/perl5"
    ENV['PERL5LIB'] = "#{plib}:#{plib}/#{arch}:#{lib}:#{lib}/#{arch}"
    ENV.remove_from_cflags(/-march=\w+/)
    ENV.remove_from_cflags(/-msse\d?/)

    if build.head? || build.devel?
      # Install any missing dependencies.
      %w{authordeps listdeps}.each do |cmd|
        system "dzil #{cmd} | cpanm --local-lib '#{prefix}'"
      end

      # Build it in curie-HEAD and then cd into it.
      system "dzil build --in curie-HEAD"
      Dir.chdir 'curie-HEAD'

      # Remove perllocal.pod, simce it just gets in the way of other modules.
      rm "#{prefix}/lib/perl5/#{arch}/perllocal.pod", :force => true
    end

    system "perl Makefile.PL PREFIX='#{prefix}'"
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
end
