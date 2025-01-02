#!/usr/bin/env bash
set -euo pipefail

# Colors for fancy logs (optional)
GREEN="\033[32m"
RED="\033[31m"
CYAN="\033[36m"
BOLD="\033[1m"
RESET="\033[0m"

REPO_URL="https://github.com/Propagandalf-7/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"

echo -e "${CYAN}${BOLD}=== Dotfiles Setup ===${RESET}"

# 1) Clone the repository if it doesn’t exist
if [[ ! -d "$DOTFILES_DIR" ]]; then
  echo -e "${GREEN}Cloning $REPO_URL into $DOTFILES_DIR...${RESET}"
  git clone "$REPO_URL" "$DOTFILES_DIR"
else
  echo -e "${GREEN}Dotfiles directory already present at $DOTFILES_DIR.${RESET}"
  echo "Pulling the latest changes..."
  git -C "$DOTFILES_DIR" pull --rebase
fi

# 2) Switch to the dotfiles repo
cd "$DOTFILES_DIR"

# 3) Optionally pull the latest changes (if the repo already existed)
# (Handled above under 'else')

# 4) Run bootstrap (includes OS detection + module sourcing + install steps)
echo -e "${GREEN}Running bootstrap...${RESET}"
./bootstrap.sh

echo -e "${GREEN}Setup complete!${RESET}"
