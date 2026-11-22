require_relative "../require/fuse-t"

class ArchivemountFuseT < Formula
  desc "File system for accessing archives using libarchive"
  homepage "https://git.sr.ht/~nabijaczleweli/archivemount-ng"
  url "https://git.sr.ht/~nabijaczleweli/archivemount-ng/archive/1c.tar.gz"
  version "1c"
  sha256 "7bc489a1a77ce718c84b751a57779ded6bb192cf54f9cd0bf7bff2527cf98bfc"
  license "LGPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse-t"
    manifest_sha256 "707d602c4362ddeb2d46d0d3b285e55e1aa10f6d862388b8e93d5796ff09d27a"
    sha256 cellar: :any, arm64_golden_gate: "c3813439170871dbb8cf2c7b408268dea45215f7dfd296dd8441041002173318"
    sha256 cellar: :any, arm64_tahoe:       "5e836fa8f305e478a9f82a56d9138aaf003d541eb6c9a5599e56add6f080e669"
    sha256 cellar: :any, arm64_sequoia:     "d29ab77e5963a112c6b819117afa1f36b9dee1fff0cc3b7eb57f7a0b7818f0e0"
  end

  depends_on "pkgconf" => :build
  depends_on FuseTRequirement
  depends_on "libarchive"
  depends_on :macos

  def install
    setup_fuse3
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"archivemount", "--version"
  end
end
