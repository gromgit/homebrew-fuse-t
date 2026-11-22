require_relative "../require/fuse-t"

class S3BackerFuseT < Formula
  desc "FUSE-based single file backing store via Amazon S3"
  homepage "https://github.com/archiecobbs/s3backer"
  url "https://archie-public.s3.amazonaws.com/s3backer/s3backer-2.1.6.tar.gz"
  sha256 "55ff3123ab08d45822e6b349d9e305ca2ca13339474314cfc31a074d5308acf6"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse-t"
    manifest_sha256 "51709bde611c6763007ed012308a1646fae7653b560546ecffa9827c80cdd421"
    sha256 cellar: :any, arm64_golden_gate: "c30f9842480f2c98422dd6f45bb764467cbf52e8f0c1c2e9754472978f62e082"
    sha256 cellar: :any, arm64_tahoe:       "008bd775875b2a416a1b12982051996b0673da8c269d5d9695956344d10be0b6"
    sha256 cellar: :any, arm64_sequoia:     "11aaaef6645c3b2ff241aae69fb65b2815d3966793eab949600e7343ae1186d3"
  end

  depends_on "pkgconf" => :build
  depends_on "curl"
  depends_on "expat"
  depends_on FuseTRequirement
  depends_on :macos
  depends_on "openssl@3"
  depends_on "zlib"
  depends_on "zstd"

  def install
    setup_fuse3
    # Disable macOS-specific features that break FUSE compatibility
    # https://github.com/macfuse/macfuse/issues/1064#issuecomment-2800022794
    ENV.append "CFLAGS", "-DFUSE_DARWIN_ENABLE_EXTENSIONS=0"
    system "./configure", "--disable-silent-rules",
            *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/s3backer --version 2>&1")

    assert_match "no S3 bucket specified", shell_output("#{bin}/s3backer 2>&1", 1)
  end
end
