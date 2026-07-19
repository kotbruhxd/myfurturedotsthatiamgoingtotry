#!/usr/bin/env bash
# setup/preflight-nixos.sh - NixOS preflight and dependency installation
# This script handles NixOS-specific setup

set -euo pipefail

# Source location awareness
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/location.sh"

# Resolve repo root and detect project
resolve_repo_root
detect_project
detect_nixos

# Default hostname and username
NIX_HOSTNAME="${NIX_HOSTNAME:-nikospc}"
NIX_USERNAME="${NIX_USERNAME:-$(whoami)}"

echo "=== ML4W Dotfiles - NixOS Installation ==="
echo ""

# Prompt for hostname
echo "Enter hostname for this machine:"
echo "  (press Enter to use: ${NIX_HOSTNAME})"
read -r -p " ===> " input_hostname
if [[ -n "$input_hostname" ]]; then
  NIX_HOSTNAME="$input_hostname"
fi

# Prompt for username
echo "Enter username:"
echo "  (press Enter to use: ${NIX_USERNAME})"
read -r -p " ===> " input_username
if [[ -n "$input_username" ]]; then
  NIX_USERNAME="$input_username"
fi

export NIX_HOSTNAME NIX_USERNAME

echo ""
echo "Hostname: ${NIX_HOSTNAME}"
echo "Username: ${NIX_USERNAME}"
echo "Repo root: ${REPO_ROOT}"
echo "Project: ${PROJECT}"
echo ""

# Ensure git is available
if ! command -v git &>/dev/null; then
  echo "Installing git via nix..."
  nix profile install nixpkgs#git
fi

# Ensure git tracks the repo (required for flakes)
cd "${REPO_ROOT}" || exit 1
if [ -d .git ]; then
  git add -A 2>/dev/null || true
fi

# Patch hostname and username in host configs and flake.nix
HOST_DIR="${REPO_ROOT}/hosts/nikospc"
if [ -d "${HOST_DIR}" ] && [ -f "${HOST_DIR}/default.nix" ]; then
  sed -i 's/networking.hostName = "nikospc"/networking.hostName = "'"${NIX_HOSTNAME}"'"/g' "${HOST_DIR}/default.nix"
  sed -i 's/users.users.arseniy/users.users.'"${NIX_USERNAME}"'/g' "${HOST_DIR}/default.nix"
  sed -i 's/description = "arseniy"/description = "'"${NIX_USERNAME}"'"/g' "${HOST_DIR}/default.nix"
fi

sed -i 's/home-manager.users.arseniy/home-manager.users.'"${NIX_USERNAME}"'/g' "${REPO_ROOT}/flake.nix"

# Create host directory symlink if hostname differs from nikospc
if [ "${NIX_HOSTNAME}" != "nikospc" ] && [ -d "${HOST_DIR}" ] && [ ! -e "$(dirname "${HOST_DIR}")/${NIX_HOSTNAME}" ]; then
  echo "Creating symlink: hosts/${NIX_HOSTNAME} -> hosts/nikospc"
  ln -sfn nikospc "$(dirname "${HOST_DIR}")/${NIX_HOSTNAME}"
fi

echo "Running: sudo nixos-rebuild switch --flake .#nikospc --accept-flake-config"
echo ""

sudo nixos-rebuild switch --flake .#nikospc --accept-flake-config

echo ""
echo "NixOS configuration applied successfully!"
