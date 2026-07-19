#!/usr/bin/env bash
# dist-nixos/install-deps.sh - NixOS declarative dependency installation
# This script runs nixos-rebuild switch with the project's flake.nix

# shellcheck shell=bash

# Source location awareness if not already loaded
if [ -z "${REPO_ROOT:-}" ]; then
  source ./sdata/lib/location.sh
  resolve_repo_root
fi
detect_project
detect_nixos

# Use hostname from prompt or default
NIX_HOSTNAME="${NIX_HOSTNAME:-nikospc}"

printf "${STY_CYAN}[$0]: NixOS declarative installation${STY_RST}\n"
printf "${STY_CYAN}Repo root: ${REPO_ROOT}${STY_RST}\n"
printf "${STY_CYAN}Hostname: ${NIX_HOSTNAME}${STY_RST}\n"
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
  # Stage all files so flake.nix can access them
  git add -A 2>/dev/null || true
fi

printf "${STY_CYAN}Running: sudo nixos-rebuild switch --flake .#${NIX_HOSTNAME} --accept-flake-config${STY_RST}\n"
echo ""

sudo nixos-rebuild switch --flake ".#${NIX_HOSTNAME}" --accept-flake-config

if [ $? -ne 0 ]; then
  printf "${STY_RED}nixos-rebuild failed! Check the output above for errors.${STY_RST}\n"
  exit 1
fi

printf "${STY_GREEN}NixOS configuration applied successfully!${STY_RST}\n"
