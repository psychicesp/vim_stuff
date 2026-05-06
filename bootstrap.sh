#!/bin/sh
set -eu

REPO_ROOT=$(CDPATH= cd "$(dirname "$0")" && pwd -P)
NVIM_CONFIG_SRC="$REPO_ROOT/nvim"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
LOCAL_BIN="$HOME/.local/bin"
SHELL_RC="${SHELL_RC:-$HOME/.bashrc}"
NVIM_MIN_VERSION="${NVIM_MIN_VERSION:-0.10.0}"
GIT_MIN_VERSION="${GIT_MIN_VERSION:-2.19.0}"

START_MARKER='### ===== nvim_stuff start ===== ###'
END_MARKER='### ===== nvim_stuff end ===== ###'

log() { printf '==> %s\n' "$*"; }
warn() { printf 'WARN: %s\n' "$*" >&2; }
die() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }

as_root() {
  if [ "$(id -u)" -eq 0 ]; then
    "$@"
  elif have sudo; then
    sudo "$@"
  else
    return 127
  fi
}

install_system_packages() {
  [ "$#" -gt 0 ] || return 0

  if have apt-get; then
    as_root apt-get update
    as_root apt-get install -y --no-install-recommends "$@"
  elif have dnf; then
    as_root dnf install -y "$@"
  elif have yum; then
    as_root yum install -y "$@"
  elif have pacman; then
    as_root pacman -Sy --needed --noconfirm "$@"
  elif have zypper; then
    as_root zypper --non-interactive install "$@"
  elif have apk; then
    as_root apk add --no-cache "$@"
  else
    return 1
  fi
}

add_missing_pkg() {
  case " $MISSING_PKGS " in
    *" $1 "*) ;;
    *) MISSING_PKGS="$MISSING_PKGS $1" ;;
  esac
}

ensure_dependencies() {
  MISSING_PKGS=""

  have git || add_missing_pkg git
  have tar || add_missing_pkg tar
  have gzip || add_missing_pkg gzip

  if ! have curl && ! have wget; then
    add_missing_pkg curl
    add_missing_pkg ca-certificates
  fi

  if [ -n "$MISSING_PKGS" ]; then
    log "Missing dependency packages:$MISSING_PKGS"
    if [ "${NVIM_AUTO_INSTALL_DEPS:-1}" = "1" ]; then
      install_system_packages $MISSING_PKGS || warn "Could not auto-install dependencies. I will re-check and fail clearly if anything is still missing."
    fi
  fi

  have git || die "git is required for lazy.nvim/plugin installs. Install git, or re-run with a package manager/sudo available."
  git_current=$(git_version)
  version_ge "$git_current" "$GIT_MIN_VERSION" || die "git $git_current is too old for lazy.nvim partial clones; install git >= $GIT_MIN_VERSION."

  have tar || die "tar is required to unpack Neovim's Linux tarball."
  have gzip || die "gzip is required to unpack Neovim's Linux tarball."
  have curl || have wget || die "curl or wget is required to download Neovim."
}

version_ge() {
  awk -v left="$1" -v right="$2" '
    function normalize(v, out) {
      sub(/^v/, "", v)
      split(v, out, ".")
      for (i = 1; i <= 3; i++) {
        sub(/[^0-9].*$/, "", out[i])
        if (out[i] == "") out[i] = 0
      }
    }
    BEGIN {
      normalize(left, l)
      normalize(right, r)
      for (i = 1; i <= 3; i++) {
        if (l[i] + 0 > r[i] + 0) exit 0
        if (l[i] + 0 < r[i] + 0) exit 1
      }
      exit 0
    }
  '
}

nvim_version() {
  nvim --version | awk 'NR == 1 { sub(/^v/, "", $2); print $2 }'
}

git_version() {
  git --version | awk '{ print $3 }'
}

download_file() {
  url=$1
  output=$2

  if have curl; then
    curl -fL --retry 3 --connect-timeout 20 -o "$output" "$url"
  elif have wget; then
    wget -O "$output" "$url"
  else
    die "curl or wget is required to download $url"
  fi
}

backup_path() {
  path=$1
  backup="${path}.backup.$(date +%Y%m%d-%H%M%S)"
  mv "$path" "$backup"
  log "Backed up $path to $backup"
}

install_neovim_user_local() {
  machine=$(uname -m)
  case "$machine" in
    x86_64|amd64) arch=x86_64 ;;
    aarch64|arm64) arch=arm64 ;;
    *) die "Unsupported CPU architecture for the official Neovim Linux tarball: $machine" ;;
  esac

  asset="nvim-linux-$arch"
  install_dir="${NVIM_INSTALL_DIR:-$HOME/.local/opt/$asset}"
  tmpdir=$(mktemp -d)
  url="https://github.com/neovim/neovim/releases/latest/download/$asset.tar.gz"
  archive="$tmpdir/$asset.tar.gz"
  extracted="$tmpdir/$asset"

  trap 'rm -rf "$tmpdir"' EXIT HUP INT TERM

  log "Installing Neovim to $install_dir"
  download_file "$url" "$archive"
  tar -xzf "$archive" -C "$tmpdir"

  [ -d "$extracted" ] || die "Downloaded archive did not contain expected directory: $asset"

  mkdir -p "$(dirname "$install_dir")" "$LOCAL_BIN"
  rm -rf "$install_dir"
  mv "$extracted" "$install_dir"

  if [ -L "$LOCAL_BIN/nvim" ]; then
    rm -f "$LOCAL_BIN/nvim"
  elif [ -e "$LOCAL_BIN/nvim" ]; then
    backup_path "$LOCAL_BIN/nvim"
  fi

  ln -s "$install_dir/bin/nvim" "$LOCAL_BIN/nvim"
  rm -rf "$tmpdir"
  trap - EXIT HUP INT TERM

  PATH="$LOCAL_BIN:$PATH"
  export PATH
  hash -r 2>/dev/null || true
}

ensure_neovim() {
  mkdir -p "$LOCAL_BIN"
  PATH="$LOCAL_BIN:$PATH"
  export PATH

  if have nvim; then
    current=$(nvim_version)
    if version_ge "$current" "$NVIM_MIN_VERSION"; then
      log "Found Neovim $current"
      return 0
    fi
    warn "Found Neovim $current, but this repo wants >= $NVIM_MIN_VERSION. Installing a user-local Neovim instead."
  fi

  install_neovim_user_local

  have nvim || die "Neovim install completed, but nvim is still not on PATH."
  version_ge "$(nvim_version)" "$NVIM_MIN_VERSION" || die "Installed Neovim is still older than $NVIM_MIN_VERSION."
}

link_nvim_config() {
  dest="$XDG_CONFIG_HOME/nvim"

  [ -d "$NVIM_CONFIG_SRC" ] || die "Missing repo config directory: $NVIM_CONFIG_SRC"
  mkdir -p "$XDG_CONFIG_HOME"

  if [ -L "$dest" ]; then
    if [ "$(readlink "$dest")" = "$NVIM_CONFIG_SRC" ]; then
      log "$dest already points at this repo"
      return 0
    fi
    backup_path "$dest"
  elif [ -e "$dest" ]; then
    backup_path "$dest"
  fi

  ln -s "$NVIM_CONFIG_SRC" "$dest"
  log "Linked $dest -> $NVIM_CONFIG_SRC"
}

upsert_managed_block() {
  file=$1
  start_marker=$2
  end_marker=$3
  block_content=$4
  tmp=$(mktemp)

  mkdir -p "$(dirname "$file")"
  touch "$file"

  awk -v start="$start_marker" -v end="$end_marker" '
    $0 == start { in_block = 1; next }
    $0 == end { in_block = 0; next }
    !in_block { lines[++n] = $0 }
    END {
      while (n > 0 && lines[n] == "") n--
      for (i = 1; i <= n; i++) print lines[i]
    }
  ' "$file" > "$tmp"

  {
    cat "$tmp"
    if [ -s "$tmp" ]; then printf '\n'; fi
    printf '%s\n' "$start_marker"
    printf '%s\n' "$block_content"
    printf '%s\n' "$end_marker"
  } > "$file"

  rm -f "$tmp"
}

manage_bashrc() {
  if [ "${NVIM_MANAGE_BASHRC:-1}" != "1" ]; then
    log "Skipping shell rc management"
    return 0
  fi

  block='# nvim-stuff: keep user-local binaries before system binaries.
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

export EDITOR="nvim"
export VISUAL="nvim"'

  if [ "${NVIM_SET_VIM_ALIASES:-1}" = "1" ]; then
    block="$block

alias vim=\"nvim\"
alias vi=\"nvim\""
  fi

  upsert_managed_block "$SHELL_RC" "$START_MARKER" "$END_MARKER" "$block"
  log "Updated managed block in $SHELL_RC"
}

sync_plugins() {
  if [ "${NVIM_SYNC_PLUGINS:-1}" != "1" ]; then
    log "Skipping plugin sync"
    return 0
  fi

  if [ -f "$NVIM_CONFIG_SRC/lazy-lock.json" ]; then
    log "Restoring plugins from lazy-lock.json"
    nvim --headless '+Lazy! restore' +qa
  else
    log "Installing plugins and creating lazy-lock.json"
    nvim --headless '+Lazy! sync' +qa
  fi
}

main() {
  ensure_dependencies
  ensure_neovim
  link_nvim_config
  manage_bashrc
  sync_plugins

  log "Done. Run 'source $SHELL_RC' or open a new shell, then start Neovim with: nvim"
}

main "$@"