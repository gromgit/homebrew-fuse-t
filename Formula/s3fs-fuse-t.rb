require_relative "../require/fuse-t"

class S3fsFuseT < Formula
  desc "FUSE-based file system backed by Amazon S3"
  homepage "https://github.com/s3fs-fuse/s3fs-fuse/wiki"
  url "https://github.com/s3fs-fuse/s3fs-fuse/archive/refs/tags/v1.97.tar.gz"
  sha256 "28413457cbf923b9b81e546caffabb8edd5c18f263e698ad86f564fd4b5b344d"
  license "GPL-2.0-or-later"
  head "https://github.com/s3fs-fuse/s3fs-fuse.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse-t"
    sha256 cellar: :any, arm64_golden_gate: "f8ce0b92fd7332866b6ee7014b666af243f40d7b5a365eeb1bdca3762c78b6b2"
    sha256 cellar: :any, arm64_tahoe:       "28ae0e80f459685a5e3ef0e77b630dbbe10d3ce311cf34b0b94ac11425fea28f"
    sha256 cellar: :any, arm64_sequoia:     "44ba175b3304b9500e70dd3287e038170620ab311906d1648b5e939ddc77bd6d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "curl"
  depends_on FuseTRequirement
  depends_on "gcc"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libxml2"
  depends_on :macos
  depends_on "nettle"

  fails_with :clang do
    cause <<~EOS
      libc++abi: terminating due to uncaught exception of type std::__1::system_error:
      mutex lock failed: Invalid argument
    EOS
  end

  def install
    # s3fs >= 1.96 configure only probes the fuse-t and fuse3 pkg-config modules,
    # but its macOS code still uses the FUSE 2 API; use macFUSE's fuse module instead
    # TODO: Review for removal in next release
    inreplace "configure.ac", "[fuse3 >= ${min_fuse_version}", "[fuse >= ${min_fuse_version}"

    setup_fuse
    system "./autogen.sh"
    system "./configure", "--with-gnutls", *std_configure_args
    system "make", "install"
  end

  test do
    system "#{bin}/s3fs", "--version"
  end
end
