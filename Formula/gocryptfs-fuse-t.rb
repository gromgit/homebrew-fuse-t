require_relative "../require/fuse-t"

class GocryptfsFuseT < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https://nuetzlich.net/gocryptfs/"
  url "https://github.com/rfjakob/gocryptfs/releases/download/v2.7.0/gocryptfs_v2.7.0_src-deps.tar.gz"
  sha256 "52a271a12bcab3b2e51c0e7baa53a2beeebc9f811d8b28d6b23662a2b70e5680"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse-t"
    sha256 cellar: :any, arm64_golden_gate: "02b72b3c5278a82007029b0e72fb16db705bd7fba8c261ada103925e2894a6c0"
    sha256 cellar: :any, arm64_tahoe:       "58023c1e37a0b4a7fa5af698225efe1ad5f84a2b5145da9f7b79ec9a9f43a369"
    sha256 cellar: :any, arm64_sequoia:     "d9e2fe3a97143d13d2a973c5c585b14d3ba0e8c4837b1b59f6494eec49cf24cc"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on FuseTRequirement
  depends_on :macos
  depends_on "openssl@4"

  def install
    setup_fuse
    system "./build.bash"
    bin.install "gocryptfs", "gocryptfs-xray/gocryptfs-xray"
    man1.install "Documentation/gocryptfs.1", "Documentation/gocryptfs-xray.1"
  end

  test do
    (testpath/"encdir").mkpath
    pipe_output("#{bin}/gocryptfs -init #{testpath}/encdir", "password", 0)
    assert_path_exists testpath/"encdir/gocryptfs.conf"
  end
end
