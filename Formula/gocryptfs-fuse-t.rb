require_relative "../require/fuse-t"

class GocryptfsFuseT < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https://nuetzlich.net/gocryptfs/"
  url "https://github.com/rfjakob/gocryptfs/releases/download/v2.7.0/gocryptfs_v2.7.0_src-deps.tar.gz"
  sha256 "52a271a12bcab3b2e51c0e7baa53a2beeebc9f811d8b28d6b23662a2b70e5680"
  license "MIT"

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
