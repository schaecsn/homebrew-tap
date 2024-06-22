class Xv < Formula
  desc "John Bradley's classic picture viewer xv"
  homepage "http://www.trilon.com/xv/"
  url "ftp://ftp.cis.upenn.edu/pub/xv/xv-3.10a.tar.gz"
  sha256 "03eb26b1e8f315c3093f4ae794862ba46637d16c055e8efbe5e3beb5d40fc451"
  license "xv-license"

  depends_on "libjpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libx11"
  depends_on "libxrandr" # required by second DavidGriffith patch
  depends_on "libxt"
  depends_on "webp"

  # Jumbo patch site http://www.sonic.net/~roelofs/greg_xv.html
  # The original jumbo patch is a tar ball. It is hard to convince brew to
  # uncompress two tar balls - the actual tar ball and this tar ball patch.
  # I converted the jumbo patch to two actual patches on corona.crabdance.com.
  #
  # Note: xvdocs.pdf got removed from this patch. xvdocs.ps is still available.
  patch do
    url "http://corona.crabdance.com/xv/xv-3.10a-jumbo-patches-20070520.patch"
    sha256 "f5deac02929a0cad12733641643e8849bcd053c59b9c5ab67dadd9d03bb2de87"
  end
  patch do
    url "http://corona.crabdance.com/xv/xv-3.10a-jumbo-fix-enh-patch-20070520.txt"
    sha256 "e2932c0dbc5b99fc5167c307f0a3b00a661f307840474ce73bdbff8e19824fce"
  end
  # a further patch from the jumbo patch maintainer a year later
  patch do
    url "http://www.sonic.net/~roelofs/code/xv-3.10a-enhancements.20070520-20081216.diff"
    sha256 "c47aa52b7dbf2e09896d3eba6411d78a56162a4b966197e40115c14d88c2e1eb"
  end

  # macports' macOS specific patches
  patch :p0 do
    url "https://trac.macports.org/browser/trunk/dports/graphics/xv/files/patch-libpng-1.5.diff?format=txt"
    sha256 "b2ccaec4301cd524a2933fde4a6ffc7244a0e2850ee7e880d1066179e106447a"
  end
  patch :p0 do
    url "https://trac.macports.org/browser/trunk/dports/graphics/xv/files/patch-Makefile.diff?format=txt"
    sha256 "ae211bd8e110e35aed739ee37ea8c7da7257ab0fd93076a5dbe841cabcbd4430"
  end
  patch :p0 do
    url "https://trac.macports.org/browser/trunk/dports/graphics/xv/files/patch-xv.h.diff?format=txt"
    sha256 "62d3e444ca0c4bc8e48a58c81fdc9564b4a5e76e48869e8e1deeb5b2c7b422ef"
  end

  # webm support (the first two patches are strictly speaking not necessary;
  # they just prepare the context for the webm patch to apply cleanly)
  patch do
    url "https://gitlab.com/DavidGriffith/xv/-/commit/a1d499e9.diff"
    sha256 "12728f9ea347c9893e8c7b968c7eac7700b4147099529a9881fe817662854def"
  end
  patch do
    url "https://gitlab.com/DavidGriffith/xv/-/commit/a84406cb.diff"
    sha256 "9bf5eebe6253ad3b45fc8c66a383cefd81d9a301f94f33263d02d46904de9648"
  end
  patch do
    url "https://gitlab.com/DavidGriffith/xv/-/commit/5682a07e.diff"
    sha256 "861cc9bef34fce9df308163f2cca6c0acceed3c1aca807a5e1670d58962d7d5c"
  end

  # my patches to tweak the look and feel
  patch :p0 do
    url "http://corona.crabdance.com/xv/CREATOR.patch"
    sha256 "4f4426a31147ebf0dbbe9d28b30febb927304d803338a932c5673b665185283a"
  end
  patch :p0 do
    url "http://corona.crabdance.com/xv/REGISTERED.patch"
    sha256 "6a9db3b9edcb0a4303cd6de88002366a5589b67b7e4a2a63be8b56175dcb2bc2"
  end
  patch :p0 do
    url "http://corona.crabdance.com/xv/VERSION.patch"
    sha256 "5f23cdae58b6dd60ec35c5b91ada735bec896da331550b2817f07c58427ddbc7"
  end

  def install
    # xvdocs.pdf has been removed from my jumbo patch; don't try installing it
    inreplace "Makefile", "docs/xvdocs.pdf", ""
    inreplace "Makefile", "$(DESTDIR)$(DOCDIR)/xvdocs.pdf", ""

    # jasper2000 JP2K support does not build anymore; disable it
    system "make", "PREFIX=#{prefix}", "JP2K=''", "JP2KLIB=''"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
