require_relative "../require/fuse-t"

class CurlftpfsFuseT < Formula
  desc "Filesystem for accessing FTP hosts based on FUSE and libcurl"
  homepage "https://curlftpfs.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/curlftpfs/curlftpfs/0.9.2/curlftpfs-0.9.2.tar.gz"
  sha256 "4eb44739c7078ba0edde177bdd266c4cfb7c621075f47f64c85a06b12b3c6958"
  license "GPL-2.0-only"
  head ":pserver:anonymous:@curlftpfs.cvs.sourceforge.net:/cvsroot/curlftpfs", using: :cvs

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse-t"
    manifest_sha256 "5672514f1c161bfa9bf20ed5d1f7fd76a8abf1cba2e040976a9df72f7ba366a7"
    sha256 cellar: :any, arm64_golden_gate: "9b717dd2b14dbe93fc0ff4d16586546b8746a6c80161e021909bb721dce7ac43"
    sha256 cellar: :any, arm64_tahoe:       "957aab64f8e81dadff9fadba38e324e99ddf9ba50c63e2ad9968f396f77eb984"
    sha256 cellar: :any, arm64_sequoia:     "948f9aac8c25613ebb9102ea2120275e76074711941f77a4c14edf78a9e5d5d5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "curl"
  depends_on FuseTRequirement
  depends_on "gettext"
  depends_on "glib"
  depends_on :macos

  patch :DATA

  def install
    setup_fuse
    ENV.append "CPPFLAGS", "-D__off_t=off_t"
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/curlftpfs --version 2>&1", 1)
  end
end
__END__
diff --git a/configure.ac b/configure.ac
index c0373f3..0410b4e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -11,7 +11,7 @@ AC_PROG_LIBTOOL
 export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
 
 PKG_CHECK_MODULES(GLIB, [glib-2.0])
-PKG_CHECK_MODULES(FUSE, [fuse >= 2.2])
+PKG_CHECK_MODULES(FUSE, [fuse >= 1])
 
 LIBCURL_CHECK_CONFIG([yes], [7.17.0], [], [AC_MSG_ERROR(["libcurl not found"])])
 if test "$libcurl_protocol_FTP" != yes; then
