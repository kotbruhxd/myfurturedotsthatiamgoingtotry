#!/usr/bin/env bash
# dist-nix/install-deps.sh - NixOS declarative dependency installation
# This script runs nixos-rebuild switch with the project's flake.nix
# This script is meant to be sourced.

# shellcheck shell=bash

# Source location awareness
resolve_repo_root

# Use hostname from prompt or default
NIX_HOSTNAME="${NIX_HOSTNAME:-nikospc}"
NIX_USERNAME="${NIX_USERNAME:-$(whoami)}"

printf "${STY_CYAN}[$0]: NixOS declarative installation${STY_RST}\n"
printf "${STY_CYAN}Repo root: ${REPO_ROOT}${STY_RST}\n"
printf "${STY_CYAN}Hostname: ${NIX_HOSTNAME}${STY_RST}\n"
printf "${STY_CYAN}Username: ${NIX_USERNAME}${STY_RST}\n"
echo ""

# Verify we have a flake.nix
if [ ! -f "${REPO_ROOT}/flake.nix" ]; then
  printf "${STY_RED}Error: No flake.nix found in ${REPO_ROOT}${STY_RST}\n"
  exit 1
fi

# Ensure git is available (needed for nix flakes tracking)
if ! command -v git &>/dev/null; then
  printf "${STY_YELLOW}Installing git via nix...${STY_RST}\n"
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
  printf "${STY_CYAN}Creating symlink: hosts/${NIX_HOSTNAME} -> hosts/nikospc${STY_RST}\n"
  ln -sfn nikospc "$(dirname "${HOST_DIR}")/${NIX_HOSTNAME}"
fi

printf "${STY_CYAN}Running: sudo nixos-rebuild switch --flake .#nikospc --accept-flake-config${STY_RST}\n"
echo ""

sudo nixos-rebuild switch --flake .#nikospc --accept-flake-config

if [ $? -ne 0 ]; then
  printf "${STY_RED}nixos-rebuild failed! Check the output above for errors.${STY_RST}\n"
  exit 1
fi

printf "${STY_GREEN}NixOS configuration applied successfully!${STY_RST}\n"
