require 'formula'

class CurieDependencies < Formula
  version    '0.001'
  url        "http://api.metacpan.org/source/ZMUGHAL/Renard-Curie-#{stable.version}/META.json", :using => :nounzip
  sha256     '6e6acb2ac2acb5fb44876809ae9f49c21123e8aa878ba237e849bf892fb3a03e'
  homepage   'https://project-renard.github.io/'
  depends_on 'cpanminus' => :build
  depends_on 'gtk+3' => ['without-x11']
  #depends_on 'gtk-doc'
  depends_on 'clutter-gtk'
  depends_on 'gtk-engines'
  depends_on 'gtk-mac-integration'
  depends_on 'gtk-murrine-engine'
  #depends_on 'gtkextra'
  #depends_on 'gtkglext' # this requires pangox-compat which requires xquartz cask
  #depends_on 'gtksourceview3'
  #depends_on 'gtkspell3'
  #depends_on 'webkitgtk'
  conflicts_with 'curie_maint_depends',
    :because => "curie_dependencies and curie_maint_depends install the same plugins."

  def install
    arch  = %x(perl -MConfig -E 'print $Config{archname}')
    plib  = "#{HOMEBREW_PREFIX}/lib/perl5"
    ENV['PERL5LIB'] = "#{plib}:#{plib}/#{arch}:#{lib}:#{lib}/#{arch}"
    ENV.remove_from_cflags(/-march=\w+/)
    ENV.remove_from_cflags(/-msse\d?/)

    system "cpanm --local-lib '#{prefix}' --notest Moose Function::Parameters"
    open 'META.json' do |f|
      Utils::JSON.load(f.read)['prereqs'].each do |mode, prereqs|
        next if ['develop', 'test'].include? mode
        prereqs.each do |time, list|
          list.each do |pkg, version|
            next if pkg == 'perl'
            system "cpanm --local-lib '#{prefix}' --notest #{pkg}"
          end
        end
      end
    end

    # Remove perllocal.pod, since it just gets in the way of other modules.
    rm "#{prefix}/lib/perl5/#{arch}/perllocal.pod", :force => true
  end
end
