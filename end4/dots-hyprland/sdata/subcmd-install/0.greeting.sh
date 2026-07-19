# This script is meant to be sourced.
# It's not for directly running.

# shellcheck shell=bash

#####################################################################################

printf "${STY_CYAN}[$0]: Hi there! Before we start:${STY_RST}\n"
printf "\n"
printf "${STY_PURPLE}${STY_BOLD}[NEW] illogical-impulse is now powered by Quickshell.${STY_RST}\n"
printf "${STY_PURPLE}"
printf '# NOTE: illogical-impulse on AGS is no longer supported.\n'
printf '# If you were using the old version with AGS and would like to keep it, do not run this script.\n'
printf "\n"
pause
printf "${STY_CYAN}${STY_BOLD}Quick overview about what this script does:${STY_RST}\n"
printf "${STY_CYAN}"
printf "  1. Install dependencies.\n"
printf "  2. Setup permissions/services etc.\n"
printf "  3. Copying config files.${STY_RST}\n"
pause
printf "${STY_CYAN}${STY_BOLD}Tips:${STY_RST}\n"
printf "${STY_CYAN}"
printf "  a) It has been designed to be idempotent which means you can run it multiple times.\n"
printf "  b) Use ${STY_INVERT} --help ${STY_RST}${STY_CYAN} for more options.${STY_RST}\n"
printf "${STY_YELLOW}${STY_BOLD}Note: ${STY_RST}"
printf "${STY_YELLOW}"
printf "It does not handle system-level/hardware stuff like Nvidia drivers. Please do it by yourself.\n"
printf "${STY_RST}"
printf "\n"
pause

case $ask in
  false) true ;;
  *) 
    printf "${STY_BLUE}"
    printf "${STY_BOLD}Do you want to confirm every time before a command executes?${STY_RST}\n"
    printf "${STY_BLUE}"
    printf "  y = Yes, ask me before executing each of them. (DEFAULT)\n"
    printf "  n = No, I know everything this script will do, just execute them automatically.\n"
    printf "  a = Abort.\n"
    read -p "===> [Y/n/a]: " p
    case $p in
      n) ask=false ;;
      a) exit 1 ;;
      *) ask=true ;;
    esac
    printf "${STY_RST}"
    ;;
esac

#####################################################################################
# Hostname & Username Configuration (NixOS)
#####################################################################################
if [[ "$IS_NIXOS" == "true" ]]; then
  printf "${STY_CYAN}=== NixOS Configuration ===${STY_RST}\n"
  
  # Default hostname
  NIX_HOSTNAME="${NIX_HOSTNAME:-nikospc}"
  NIX_USERNAME="${NIX_USERNAME:-$(whoami)}"
  
  printf "${STY_CYAN}Enter hostname for this machine:${STY_RST}\n"
  printf "${STY_CYAN}  (press Enter to use: ${NIX_HOSTNAME})${STY_RST}\n"
  read -p " ===> " input_hostname
  if [[ -n "$input_hostname" ]]; then
    NIX_HOSTNAME="$input_hostname"
  fi
  
  printf "${STY_CYAN}Enter username:${STY_RST}\n"
  printf "${STY_CYAN}  (press Enter to use: ${NIX_USERNAME})${STY_RST}\n"
  read -p " ===> " input_username
  if [[ -n "$input_username" ]]; then
    NIX_USERNAME="$input_username"
  fi
  
  export NIX_HOSTNAME NIX_USERNAME
  
  printf "${STY_GREEN}Hostname: ${NIX_HOSTNAME}${STY_RST}\n"
  printf "${STY_GREEN}Username: ${NIX_USERNAME}${STY_RST}\n"
  printf "\n"
fi
