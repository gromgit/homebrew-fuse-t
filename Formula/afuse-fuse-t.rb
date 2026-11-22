require_relative "../require/fuse-t"

class AfuseFuseT < Formula
  desc "Automounting file system implemented in userspace with FUSE"
  homepage "https://github.com/pcarrier/afuse/"
  url "https://github.com/pcarrier/afuse.git",
      tag:      "v0.5.0",
      revision: "d7f07c32e58850fa092bb98b53c5c570fed8be69"
  license "GPL-2.0-only"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse-t"
    manifest_sha256 "c56a014c5c95868d5ee7010bac588ced76ee2887f9a4249303e3a53a48f6e793"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3eb43a112a6117707d954fee4f0723a61e445494cd0fad53756d19ced041d787"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bff91f6e94343803277d60ba70846592d675e163a9cb8f8a37c187dfc4ad4111"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a83779a56f275629b2fce9d052a8a9219a070f7f84fa37d09c0afbe787dad8fe"
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
