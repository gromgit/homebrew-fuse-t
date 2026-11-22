require_relative "../require/fuse-t"

class AfuseFuseT < Formula
  desc "Automounting file system implemented in userspace with FUSE"
  homepage "https://github.com/pcarrier/afuse/"
  url "https://github.com/pcarrier/afuse.git",
      tag:      "v0.5.0",
      revision: "d7f07c32e58850fa092bb98b53c5c570fed8be69"
  license "GPL-2.0-only"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "d0b0e74b43c27ce951eec136e4c45a98c43edc39cceeb95418f43c2d5bfa9afe"
    sha256 cellar: :any,                 ventura:      "81eac9045ff5882fa86b3e40c6562bbed06cf1346ec5fb368033511cab03c982"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on FuseTRequirement
  depends_on :macos

  # FUSE-T doesn't track mainline FUSE versions
  patch :DATA

  def install
    setup_fuse
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "FUSE library version", pipe_output("#{bin}/afuse --version 2>&1")
  end
end
__END__
diff --git a/configure.ac b/configure.ac
index ef07d70..794280c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -15,7 +15,7 @@ AC_PROG_CC
 
 # Checks for libraries.
 export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
-PKG_CHECK_MODULES([FUSE], [fuse >= 2.3])
+PKG_CHECK_MODULES([FUSE], [fuse >= 1])
 CFLAGS="$CFLAGS -Wall -Wextra $FUSE_CFLAGS -DFUSE_USE_VERSION=25"
 LIBS="$FUSE_LIBS"
 
diff --git a/src/afuse.c b/src/afuse.c
index 0d9f22b..62116b2 100644
--- a/src/afuse.c
+++ b/src/afuse.c
@@ -1428,6 +1428,9 @@ static int afuse_fsync(const char *path, int isdatasync,
 	int res;
 	(void)path;
 
+#ifdef __APPLE__
+#undef HAVE_FDATASYNC
+#endif
 #ifndef HAVE_FDATASYNC
 	(void)isdatasync;
 #else
