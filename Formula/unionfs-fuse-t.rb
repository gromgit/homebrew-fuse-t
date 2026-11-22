require_relative "../require/fuse-t"

class UnionfsFuseT < Formula
  desc "Union filesystem using FUSE"
  homepage "https://github.com/rpodgorny/unionfs-fuse"
  url "https://github.com/rpodgorny/unionfs-fuse/archive/refs/tags/v3.8.tar.gz"
  sha256 "88482d27a886fefd251af3d5b7123e82b2b5800219e7d61d4f29bfee718bbaac"
  license "BSD-3-Clause"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/fuse-t"
    manifest_sha256 "6004918e185298b32bf1fff719717452a3d65f6292f9fd998e03f44c511d08f2"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "07e11ff7ef4a4a8641b7fcfd0fab3ed0b7e2d01da057c619af162cf41c63f280"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d01b625b8103b83bfabb1c51f7ccbb318c3976d79159b7a3d04e6c5e91543079"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d2331e6fc1579a131c163099ca8b9eaa7ddbe9749bbe847c1b16dbfa669af1b1"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on FuseTRequirement

  def install
    setup_fuse
    inreplace "CMakeLists.txt", "/usr/local", alt_fuse_root.to_s
    mkdir "build" do
      system "cmake", "-S", "..", "-B", ".",
        "-DCMAKE_C_COMPILER=clang",
        "-DCMAKE_C_FLAGS=-std=gnu99",
        *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unionfs --version 2>&1")
    # TODO: fix test
    # (testpath/"t1").mkdir
    # (testpath/"t1/test1.txt").write <<~EOS
    #  This is test 1.
    # EOS
    # (testpath/"t2").mkdir
    # (testpath/"t2/test2.txt").write <<~EOS
    #  This is test 2.
    # EOS
    # (testpath/"t3").mkdir
    # begin
    #  system "#{bin}/unionfs", "-o", "cow,max_files=32768,allow_other,use_ino,nonempty",
    #         "#{testpath}/t1=RW:#{testpath}/t2=RO", testpath/"t3"
    #  assert_match "test 2", pipe_output("cat #{testpath}/t3/test2.txt")
    # ensure
    #  system "umount", "#{testpath}/t3"
    # end
  end
end
