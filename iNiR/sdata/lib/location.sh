#!/usr/bin/env bash
# location.sh - Repository root detection and project identification
# Source this file early in setup scripts for location awareness

# resolve_repo_root - Finds the repo root directory
# Strategy:
# 1. Check if REPO_ROOT is already set and valid
# 2. Follow the script's real path (resolved symlinks) up to find flake.nix
# 3. Check common locations
# 4. Fall back to $SCRIPT_DIR or fail
resolve_repo_root() {
  # Already resolved?
  if [ -n "$REPO_ROOT" ] && [ -f "$REPO_ROOT/flake.nix" ]; then
    return 0
  fi

  # Follow symlinks to find actual script location
  local source="${BASH_SOURCE[0]}"
  while [ -L "$source" ]; do
    local dir
    dir="$(cd -P "$(dirname "$source")" && pwd)"
    source="$(readlink "$source")"
    [[ "$source" != /* ]] && source="$dir/$source"
  done
  local script_dir
  script_dir="$(cd -P "$(dirname "$source")" && pwd)"

  # Walk up from script dir to find flake.nix
  local check="$script_dir"
  while [ "$check" != "/" ]; do
    if [ -f "$check/flake.nix" ]; then
      REPO_ROOT="$check"
      return 0
    fi
    check="$(dirname "$check")"
  done

  # Fallback: check known locations
  for candidate in \
    "$HOME/myfurturedots/iNiR" \
    "$HOME/myfurturedots/end4/dots-hyprland" \
    "$HOME/myfurturedots/ml4w/dotfiles" \
    "$HOME/dots/iNiR" \
    "$HOME/dots/end4/dots-hyprland" \
    "$HOME/dots/ml4w/dotfiles"; do
    if [ -f "$candidate/flake.nix" ]; then
      REPO_ROOT="$candidate"
      return 0
    fi
  done

  return 1
}

# detect_project - Determines which project we're in
detect_project() {
  PROJECT="unknown"

  if [ -f "$REPO_ROOT/VERSION" ] && [ -d "$REPO_ROOT/nix" ]; then
    PROJECT="inir"
  elif [ -f "$REPO_ROOT/README.md" ] && grep -q "illogical-impulse" "$REPO_ROOT/README.md" 2>/dev/null; then
    PROJECT="end4"
  elif [ -f "$REPO_ROOT/README.md" ] && grep -qi "ml4w\|mylinuxforwork" "$REPO_ROOT/README.md" 2>/dev/null; then
    PROJECT="ml4w"
  elif [ -d "$REPO_ROOT/dots/.config/hypr" ]; then
    PROJECT="end4"
  elif [ -d "$REPO_ROOT/dotfiles/.config/hypr" ]; then
    PROJECT="ml4w"
  fi
}

# detect_nixos - Checks if we're on NixOS
detect_nixos() {
  if [ -f /etc/NIXOS ] || grep -qi "nixos" /etc/os-release 2>/dev/null; then
    IS_NIXOS=true
  else
    IS_NIXOS=false
  fi
}
