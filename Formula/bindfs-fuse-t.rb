require_relative "../require/fuse-t"

class BindfsFuseT < Formula
  desc "FUSE file system for mounting to another location"
  homepage "https://bindfs.org/"
  url "https://bindfs.org/downloads/bindfs-1.18.4.tar.gz"
  sha256 "3266d0aab787a9328bbb0ed561a371e19f1ff077273e6684ca92a90fedb2fe24"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse-t"
    manifest_sha256 "d845f33aa6ec578cdc3e135c54951223e5b36a01023221b9ff27733de404f565"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ef72572b7533edee9249637baa8ced3699182f34bf707d5dc032c0c541d59407"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "149d4803b839a3e4f5878604f5067256e0f0f1d6df9157bd2f0b3ff07a3f5a49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0ba54ec889b822907ed6359d9e4799e1dca64e11f18551cee35178bac605c0b8"
  end

  head do
    url "https://github.com/mpartel/bindfs.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on FuseTRequirement
  depends_on :macos

  def install
    # upstream can detect FUSE-T directly
    setup_fuse
    # https://github.com/mpartel/bindfs/issues/163#issuecomment-2854763292
    ENV.append "CFLAGS", "-D_DARWIN_C_SOURCE"
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, "--disable-macos-fs-link", *std_configure_args
    system "make", "install"
  end

  test do
    system "#{bin}/bindfs", "-V"
  end
end
