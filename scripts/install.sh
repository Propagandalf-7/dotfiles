#!/usr/bin/env bash
set -euo pipefail

GREEN="\033[32m"
RED="\033[31m"
CYAN="\033[36m"
BOLD="\033[1m"
RESET="\033[0m"

# Get the path to the dotfiles directory:
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
SYMLINKS_DIR="$DOTFILES_DIR/symlinks"

echo -e "${CYAN}${BOLD}Creating symlinks from $SYMLINKS_DIR to $HOME...${RESET}"

# Safety check: If symlinks directory doesn't exist or is empty, handle gracefully
if [[ ! -d "$SYMLINKS_DIR" ]]; then
  echo -e "${RED}Error: symlinks directory '$SYMLINKS_DIR' does not exist.${RESET}"
  exit 1
fi

# You could skip hidden files entirely or keep them if you like.
# The pattern below includes hidden files, but excludes "." and ".." entries.
shopt -s dotglob  # include dotfiles in glob expansion
for file in "$SYMLINKS_DIR"/*; do
  [[ -e "$file" ]] || continue  # skip if no matches

  filename="$(basename "$file")"
  # If the item is "." or "..", skip
  if [[ "$filename" == "." || "$filename" == ".." ]]; then
    continue
  fi

  dest="$HOME/$filename"

  # If it's a directory, decide if you want to symlink the directory as well.
  # For now, let's symlink everything (files or directories).
  echo -e "${GREEN}Symlinking ${file
