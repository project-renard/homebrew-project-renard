require 'formula'

class CurieDependencies < Formula
  version    '0.001'
  url        "http://api.metacpan.org/source/ZMUGHAL/Renard-Curie-#{stable.version}/META.json", :using => :nounzip
  sha256     '6e6acb2ac2acb5fb44876809ae9f49c21123e8aa878ba237e849bf892fb3a03e'
  homepage   'https://project-renard.github.io/'
  depends_on 'cpanminus' => :build
  depends_on :x11 # needed for Alien::MuPDF (builds mupdf-x11 on Mac OS X)
  depends_on 'gtk+3'
  #depends_on 'gtk-doc'
  depends_on 'clutter-gtk'
  depends_on 'gtk3-mac-integration'
  #depends_on 'gtksourceview3'
  #depends_on 'gtkspell3'
  #depends_on 'webkitgtk'

  def install
    system "mkdir -p #{prefix}/lib"
    system "touch #{prefix}/lib/keep-curie-dep"
  end
end
