require 'formula'

class CurieDependencies < Formula
  version    '0.002'
  url        "https://fastapi.metacpan.org/v1/source/ZMUGHAL/Renard-Curie-#{stable.version}/META.json", :using => :nounzip
  sha256     '1d9eafa402230afbcb1a9322d8f4275407271c57614fa0ef44c0c8f57a8cc855'
  homepage   'https://project-renard.github.io/'
  depends_on 'cpanminus' => :build
  depends_on :x11 # needed for Alien::MuPDF (builds mupdf-x11 on Mac OS X)
  depends_on 'gtk+3'
  depends_on 'gnome-icon-theme'
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
