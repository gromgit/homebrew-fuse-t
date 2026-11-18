require_relative "../require/fuse-t"

class EncfsFuseT < Formula
  desc "Encrypted pass-through FUSE file system"
  homepage "https://vgough.github.io/encfs/"
  url "https://github.com/vgough/encfs/archive/refs/tags/v1.9.5.tar.gz"
  sha256 "4709f05395ccbad6c0a5b40a4619d60aafe3473b1a79bafb3aa700b1f756fd63"
  # The code comprising the EncFS library (libencfs) is licensed under the LGPL.
  # The main programs (encfs, encfsctl, etc) are licensed under the GPL.
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/vgough/encfs.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse-t"
    sha256 arm64_golden_gate: "ad2284e7724cee0d86ecc875a40399d2723a0a9b38f9d7f1e38f823ece16c05a"
    sha256 arm64_tahoe:       "e872f877a6320374808ba02cbcfe172bf27a3e3fe273aa68a1e71c1133fcfb76"
    sha256 arm64_sequoia:     "fc17942850d34ea1eaefcc05da57aa3de2167392b97446e42449c13fb53caa36"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on FuseTRequirement
  depends_on "gettext"
  depends_on :macos
  depends_on "openssl@4"
  depends_on "tinyxml2"

  patch do
    url "https://github.com/vgough/encfs/commit/75080681626062e5832aec0b1bb3aa37d8364822.patch?full_index=1"
    sha256 "0222bc4a4f03541b1523b03471f6af5925d4ed2a4c0d36a9a6fe39a18c036770"
  end

  patch :DATA

  def install
    setup_fuse
    ENV.cxx11
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_UNIT_TESTS=OFF",
                    "-DUSE_INTERNAL_TINYXML=OFF",
                    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Functional test violates sandboxing, so punt.
    # Issue #50602; upstream issue vgough/encfs#151
    assert_match version.to_s, shell_output("#{bin}/encfs 2>&1", 1)
  end
end
__END__
diff --git a/cmake/FindFUSE.cmake b/cmake/FindFUSE.cmake
index bb8cb50..668f448 100644
--- a/cmake/FindFUSE.cmake
+++ b/cmake/FindFUSE.cmake
@@ -10,8 +10,8 @@ if (FUSE_INCLUDE_DIR)
 endif (FUSE_INCLUDE_DIR)
 
 if (APPLE)
-    set (FUSE_NAMES libosxfuse.dylib fuse)
-    set (FUSE_SUFFIXES osxfuse fuse)
+    set (FUSE_NAMES libfuse-t.dylib fuse)
+    set (FUSE_SUFFIXES fuse-t fuse)
 else (APPLE)
     set (FUSE_NAMES fuse refuse)
     set (FUSE_SUFFIXES fuse refuse)
