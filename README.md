# gromgit's Fuse-T (macOS) tap

This tap exists to support macOS FUSE-related software that have been dropped from Homebrew core. All formulae in this tap depend on [Fuse-T](https://fuse-t.org); if you're running macFUSE on your system, you probably want [the `gromgit/fuse` tap](https://github.com/gromgit/homebrew-fuse)] instead.

---

# !!! WARNING: EXPERIMENTAL !!!

It's still early days for Fuse-T, especially (as of 2026-Jul-16) with regards to FUSE3 support, so some stuff might not even build properly, or crash on startup.

---

## How do I install these formulae?

First, if you've already installed FUSE formulae from the core tap _before_ they were disabled, you might _not_ want to switch over to my formulae, because:
1. As far as I know, Homebrew will not remove them from your system, even after the formulae themselves are deleted.
1. Many of these formulae are rather old, so you're unlikely to find updates anyway.

But if you _do_ want to install my formulae over the core ones, you should uninstall the core formulae first.

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).

## FAQ

### Why is XYZ not available?

It's probably available, but with a `-fuse-t` suffix to avoid name clashes with Homebrew core (e.g. `sshfs` becomes `sshfs-fuse-t`).

If you can't find it under its new name, possible reasons include:
1. All available versions of `XYZ` require version 3 of the libfuse API, but macFUSE only supports v2.
1. I might not have gotten around to getting it up. [File an issue](https://github.com/gromgit/homebrew-fuse/issues/new/choose) to get my attention. 😀

### Why is XYZ so old?

Possible reasons:
1. Current `XYZ` requires FUSE 3, which is not supported by all known macOS FUSE drivers, so the version you see is the latest one that can be built on macOS.
1. `XYZ` was abandoned by its authors. If you know of a revived fork of such software, [file an issue](https://github.com/gromgit/homebrew-fuse/issues/new/choose) with the details and I'll see what can be done.
1. I might not have gotten around to updating it yet. [File an issue](https://github.com/gromgit/homebrew-fuse/issues/new/choose) to get my attention. 😀

### Why is the XYZ formula called `XYZ-fuse-t`?

To avoid a naming conflict with the formula called `XYZ` that still exists in Homebrew core, _and_ the corresponding macFUSE-based formula named `XYZ-mac`.

### Why is the XYZ _program_ installed as `XYZ-fuse-t`?

`brew info gromgit/fuse-t/XYZ-fuse-t` and read the _Caveats_ section.

### Why does Homebrew say I need to build `XYZ-fuse-t` from source?

All my old Intel Mac hardware is dead, so I'm relying now on the free GitHub runners to build bottles.

### Why can't I build XYZ on an ARM Mac?

Homebrew currently [filters out `/usr/local` entirely during ARM-based builds](https://github.com/Homebrew/brew/blob/04532cb6216b69a5b067aa7a4e22cff0944b257d/Library/Homebrew/shims/super/cc#L266-L270). I've devised a workaround for this, that seems to work well on both Intel and ARM GitHub runners. If you still can't build it, please [file an issue](https://github.com/gromgit/homebrew-fuse/issues/new/choose).

