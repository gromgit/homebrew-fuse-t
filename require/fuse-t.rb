# typed: false
# frozen_string_literal: true

# USAGE:
# 1. Start FUSE formula file with `require_relative "../require/fuse-t"`
# 2. Add `FuseTRequirement` as formula dependency

class FuseTRequirement < Requirement
  fatal true

  satisfy(build_env: false) { self.class.fuse_t_installed? }

  def self.fuse_t_installed?
    File.exist?("/usr/local/include/fuse.h") &&
      !File.symlink?("/usr/local/include") &&
      File.exist?("/usr/local/lib/libfuse-t.dylib") &&
      File.exist?("/usr/local/lib/pkgconfig/fuse-t.pc")
  end

  env do
    ENV.append_path "PKG_CONFIG_PATH", HOMEBREW_LIBRARY/"Homebrew/os/mac/pkgconfig/fuse"
  end

  def message
    "This formula requires Fuse-T. Please run `brew install --cask fuse-t` first."
  end

  def display_s
    "Fuse-T"
  end
end

require_relative "formula-patch"
