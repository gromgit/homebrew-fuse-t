require_relative "../require/fuse-t"

class GcsfuseFuseT < Formula
  desc "User-space file system for interacting with Google Cloud"
  homepage "https://github.com/googlecloudplatform/gcsfuse"
  url "https://github.com/GoogleCloudPlatform/gcsfuse/archive/refs/tags/v3.13.0.tar.gz"
  sha256 "34d3b9557ee74e37eef42bf1c4434eebda1789222b546a7d3253be45a1b16196"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/gcsfuse.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse-t"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c5db27398678b4014dc7f2f56fe846aaefe2500a35ff744ebee92563f63773d8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "023b9304f541bfccabb52a5c9d1dba5eb05a2d8cc574cf706b81a6154b5058eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5d05ead8c18cec437ede66e011237696c276086b942d4b6621e78faeb47771b4"
  end

  depends_on "go" => :build
  depends_on FuseTRequirement
  depends_on :macos

  # Remove stuff that fails compilation:-
  # 1. Linux-only syscalls
  # 2. O_DIRECT support (jacobsa/fuse exports different interfaces across platforms)
  patch do
    file "Patches/gcsfuse/3.13.0.patch"
    type :unofficial
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    setup_fuse

    # `build_gcsfuse` builds with its own temporary GOPATH;
    # keep using the module cache populated in `fetch`.
    ENV["GOMODCACHE"] = "#{ENV.fetch("GOPATH")}/pkg/mod"

    # Build the build_gcsfuse tool.
    system "go", "build", "./tools/build_gcsfuse"

    # Use that tool to build gcsfuse itself.
    gcsfuse_version = build.head? ? Utils.git_short_head : version.to_s
    system "./build_gcsfuse", buildpath, prefix, gcsfuse_version
  end

  def caveats
    <<~EOS
      Upstream doesn't actively support macOS (https://github.com/GoogleCloudPlatform/gcsfuse/issues/1299).
    EOS
  end

  test do
    system bin/"gcsfuse", "--help"
    system "#{sbin}/mount_gcsfuse", "--help"
  end
end
