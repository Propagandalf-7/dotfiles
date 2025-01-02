#!/usr/bin/env bash
set -euo pipefail

# Colors (optional)
GREEN="\033[32m"
RED="\033[31m"
CYAN="\033[36m"
BOLD="\033[1m"
RESET="\033[0m"

###################################
# 1) Detect OS
###################################
detect_os() {
  case "$(uname -s)" in
    Darwin)
      echo "macos"
      ;;
    Linux)
      if [[ -f "/.dockerenv" ]]; then
        echo "docker"
      else
        echo "linux"
      fi
      ;;
    CYGWIN*|MINGW*|MSYS*)
      echo "windows"
      ;;
    *)
      echo "unknown"
      ;;
  esac
}

OS="$(detect_os)"
echo -e "${CYAN}${BOLD}Detected OS: ${OS}${RESET}"

###################################
# 2) Load common modules
###################################
# Safe checks to ensure files actually exist before sourcing
COMMON_DIR="modules/common"
[[ -f "$COMMON_DIR/environment.sh" ]] && source "$COMMON_DIR/environment.sh"
[[ -f "$COMMON_DIR/aliases.sh"     ]] && source "$COMMON_DIR/aliases.sh"
[[ -f "$COMMON_DIR/functions.sh"   ]] && source "$COMMON_DIR/functions.sh"

###################################
# 3) Load OS-specific modules
###################################
case "$OS" in
  macos)
    [[ -f "modules/macos/brew.sh"     ]] && source "modules/macos/brew.sh"
    [[ -f "modules/macos/settings.sh" ]] && source "modules/macos/settings.sh"
    ;;
  windows)
    # On Windows, you might want to call PowerShell scripts
    if command -v pwsh.exe &>/dev/null; then
      pwsh.exe -File "modules/windows/settings.ps1"
    else
      echo -e "${RED}pwsh.exe not found. Skipping Windows-specific settings.${RESET}"
    fi
    ;;
  docker)
    [[ -f "modules/docker/docker-config.sh" ]] && source "modules/docker/docker-config.sh"
    ;;
  linux)
    # Example for a Linux-specific module
    # [[ -f "modules/linux/apt.sh" ]] && source "modules/linux/apt.sh"
    ;;
  unknown)
    echo -e "${RED}Unsupported OS detected. Some scripts may not work.${RESET}"
    ;;
  *)
    echo -e "${RED}Error: No matching OS case.${RESET}"
    ;;
esac

###################################
# 4) Finish by calling the install script
###################################
if [[ -f "./scripts/install.sh" ]]; then
  echo -e "${GREEN}Running install script...${RESET}"
  ./scripts/install.sh
else
  echo -e "${RED}scripts/install.sh not found. Aborting.${RESET}"
  exit 1
fi
