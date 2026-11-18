require_relative "../require/fuse-t"

class SshfsFuseT < Formula
  desc "File system client based on SSH File Transfer Protocol"
  homepage "https://github.com/libfuse/sshfs"
  url "https://github.com/libfuse/sshfs/archive/refs/tags/sshfs-3.7.7.tar.gz"
  sha256 "3f2873a2b7e7bdd3179ce2a5ee00d219a043cbd75d5be42ccb9707123a90418f"
  license any_of: ["LGPL-2.1-only", "GPL-2.0-only"]

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse-t"
    sha256 cellar: :any, arm64_golden_gate: "7a979ac13e01f28700e97a747b101298d462db019c92a5d0f982cb5888639d43"
    sha256 cellar: :any, arm64_tahoe:       "59b22a6bba4a1475a52c771e607039bd473b476296df35ba0a84e19bbf1cdbd4"
    sha256 cellar: :any, arm64_sequoia:     "4c887e7d792261468245cd63105126170e34aec9543487c3d014bf583edf8f55"
  end

  depends_on "coreutils" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on FuseTRequirement
  depends_on "glib"
  depends_on :macos

  # HACK: Fuse-T versions don't track mainline FUSE
  patch :DATA

  def install
    setup_fuse3
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin"
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "SSHFS version #{version}", shell_output("#{bin}/sshfs --version")
  end
end
__END__
diff --git a/meson.build b/meson.build
index d83438a..8dab371 100644
--- a/meson.build
+++ b/meson.build
@@ -45,7 +45,7 @@ endif
 configure_file(output: 'config.h',
                configuration : cfg)
 
-sshfs_deps = [ dependency('fuse3', version: '>= 3.1.0'),
+sshfs_deps = [ dependency('fuse3', version: '>= 1'),
                dependency('glib-2.0'),
                dependency('gthread-2.0') ]
 
