# vim_stuff

The NeoVIM setup for a non-purist who largely uses VSCode but finds themselves editing code more and more in CLI.  This is my solution.

IT...uh... got out of hand pretty fast, and I'm sure someone will tell me Oh you should just use `whatever_tool` and do this in 3 lines, but whateves.

## What it does

`./bootstrap.sh` will:

1. Ensure basic dependencies exist:

- git
- tar
- gzip
- curl or wget

2. Ensure a usable `nvim` exists.

- If `nvim` is already installed and is new enough, it leaves it alone.
- If not, it installs the official Neovim Linux tarball into:

```text
~/.local/opt/nvim-linux-<arch>
```

- Then it symlinks:

```text
~/.local/bin/nvim -> ~/.local/opt/nvim-linux-<arch>/bin/nvim
```

1. Symlink this repo's Neovim config:

```text
~/.config/nvim -> ./nvim
```

If `~/.config/nvim` already exists and is not this repo's symlink, it is moved to a timestamped backup.

4. Add or replace a managed block in `~/.bashrc`:

```bash
### ===== nvim_stuff start ===== ###
...
### ===== nvim_stuff end ===== ###
```

5. Install or restore plugins with lazy.nvim.

## Idempotency behavior

You can run `./bootstrap.sh` repeatedly.

It will not duplicate shell config lines.
It will not reinstall Neovim if the current `nvim` is new enough.
It will not repeatedly back up `~/.config/nvim` once it already points at this repo.
It will restore plugins from `nvim/lazy-lock.json` when that file exists.

## Useful environment flags

Skip shell rc edits:

```bash
NVIM_MANAGE_BASHRC=0 ./bootstrap.sh
```

Skip `vim` and `vi` aliases:

```bash
NVIM_SET_VIM_ALIASES=0 ./bootstrap.sh
```

Skip plugin sync:

```bash
NVIM_SYNC_PLUGINS=0 ./bootstrap.sh
```

Use a different shell rc file:

```bash
SHELL_RC="$HOME/.bash_aliases" ./bootstrap.sh
```

Use a different minimum Neovim version:

```bash
NVIM_MIN_VERSION=0.11.0 ./bootstrap.sh
```

Disable auto-installing missing dependency packages:

```bash
NVIM_AUTO_INSTALL_DEPS=0 ./bootstrap.sh
```

## Updating plugins

Inside Neovim:

```bash
:Lazy update
```

Then commit the changed lockfile:

```bash
git add nvim/lazy-lock.json
git commit -m "Update Neovim plugins"
```

## Notes on vendoring plugins

This repo intentionally does not vendor plugin source code.

That keeps the repo light. Plugins live under Neovim's data directory, usually:

```text
~/.local/share/nvim/lazy
```

For normal internet-connected machines, `nvim/lazy-lock.json` is the better reproducibility mechanism.

Only vendor plugins or use git submodules if you need mostly-offline or air-gapped installs.