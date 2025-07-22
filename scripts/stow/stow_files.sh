#!/bin/bash

# --- Configuration ---
# Your dotfiles repository base directory
DOTFILES_REPO_DIR="$HOME/Developer/dotfiles"
# The target directory where Stow creates symlinks (usually your home directory)
STOW_TARGET="$HOME"

# --- Script Functions ---

# Function to display usage instructions
usage() {
    echo "Usage: $0 <absolute_path_to_dotfile_or_folder> <package_name>"
    echo ""
    echo "  <absolute_path_to_dotfile_or_folder>: The full path to the file or directory you want to stow."
    echo "                                        Examples: ~/.zshrc, ~/.config/nvim, ~/.gitignore_global"
    echo "  <package_name>: The name of the Stow package (e.g., zsh, nvim, iterm, gitignore_global)."
    echo "                  This will be the directory name within your '$DOTFILES_REPO_DIR'."
    echo ""
    echo "Example: $0 ~/.zshrc zsh"
    echo "Example: $0 ~/.config/alacritty alacritty"
    echo "Example: $0 ~/.gitignore_global gitignore_global"
    exit 1
}

# Check if GNU Stow is installed
check_stow_installed() {
    if ! command -v stow &> /dev/null; then
        echo "Error: GNU Stow is not installed. Please install it (e.g., 'brew install stow' on macOS)."
        exit 1
    fi
}

# Check if the dotfiles repository directory exists
check_dotfiles_repo() {
    if [ ! -d "$DOTFILES_REPO_DIR" ]; then
        echo "Error: Dotfiles repository not found at '$DOTFILES_REPO_DIR'."
        echo "Please ensure your dotfiles repo exists at this path."
        exit 1
    fi
}

# --- Main Script Logic ---

# Check for the correct number of arguments
if [ "$#" -ne 2 ]; then
    usage
fi

check_stow_installed
check_dotfiles_repo

# Assign arguments to variables
TARGET_PATH_ABSOLUTE_RAW="$1"
PACKAGE_NAME="$2"

# Expand '~' and resolve the absolute path for the target file/folder
TARGET_PATH_ABSOLUTE=$(eval echo "$TARGET_PATH_ABSOLUTE_RAW")

# Check if the target file/folder actually exists
if [ ! -e "$TARGET_PATH_ABSOLUTE" ]; then
    echo "Error: Target file or directory '$TARGET_PATH_ABSOLUTE' does not exist."
    exit 1
fi

# Calculate the relative path from the Stow target (e.g., ~/.zshrc -> .zshrc)
# This will be the path *inside* your package directory.
RELATIVE_PATH="${TARGET_PATH_ABSOLUTE#$STOW_TARGET/}"
# Handle the case where TARGET_PATH_ABSOLUTE is exactly $STOW_TARGET (e.g., if trying to manage "~")
# Not typical for dotfiles, but good for robustness.
if [ "$TARGET_PATH_ABSOLUTE" = "$STOW_TARGET" ]; then
    RELATIVE_PATH="."
fi


# Construct the full path where the file/folder will reside within your dotfiles repository
PACKAGE_PATH_IN_REPO="${DOTFILES_REPO_DIR}/${PACKAGE_NAME}"
TARGET_PATH_IN_REPO="${PACKAGE_PATH_IN_REPO}/${RELATIVE_PATH}"

echo "--- Preparing to Add and Stow: '$TARGET_PATH_ABSOLUTE_RAW' ---"
echo "  Package Name:         '$PACKAGE_NAME'"
echo "  Stow Target:          '$STOW_TARGET'"
echo "  Dotfiles Repository:  '$DOTFILES_REPO_DIR'"
echo "  Relative Path in Repo:'$RELATIVE_PATH'"
echo "  Full Path in Repo:    '$TARGET_PATH_IN_REPO'"
echo "------------------------------------------------------------"

# Step 1: Ensure the directory structure within the package exists in the repo
# This creates folders like `~/Developer/dotfiles/iterm/.config` if needed
DIR_FOR_TARGET_IN_REPO=$(dirname "$TARGET_PATH_IN_REPO")
echo "Creating package directory structure in repo: '$DIR_FOR_TARGET_IN_REPO'"
mkdir -p "$DIR_FOR_TARGET_IN_REPO" || { echo "Error: Could not create directory '$DIR_FOR_TARGET_IN_REPO'. Aborting."; exit 1; }

# Step 2: Move the original file/directory into the dotfiles repository
echo "Moving '$TARGET_PATH_ABSOLUTE' to '$TARGET_PATH_IN_REPO'..."
if [ -e "$TARGET_PATH_IN_REPO" ] || [ -L "$TARGET_PATH_IN_REPO" ]; then
    echo "Warning: Target path '$TARGET_PATH_IN_REPO' already exists or is a symlink in your dotfiles repo. Removing it."
    rm -rf "$TARGET_PATH_IN_REPO" || { echo "Error: Could not remove existing '$TARGET_PATH_IN_REPO'. Aborting."; exit 1; }
fi
mv "$TARGET_PATH_ABSOLUTE" "$TARGET_PATH_IN_REPO" || { echo "Error: Could not move '$TARGET_PATH_ABSOLUTE'. Aborting."; exit 1; }
echo "Moved successfully."

# Step 3: Change to the dotfiles repository directory and Stow the package
echo "Stowing package '$PACKAGE_NAME' from '$DOTFILES_REPO_DIR' to '$STOW_TARGET'..."
cd "$DOTFILES_REPO_DIR" || { echo "Error: Could not change to dotfiles directory '$DOTFILES_REPO_DIR'. Aborting."; exit 1; }
stow -t "$STOW_TARGET" "$PACKAGE_NAME" || { echo "Error: Stow failed for package '$PACKAGE_NAME'. Please check for conflicts or existing non-symlinked files."; exit 1; }
echo "Stow successful! A symlink should now be at '$TARGET_PATH_ABSOLUTE'."

# Step 4: Add the newly moved files to Git's staging area
echo "Adding new files to Git staging area..."
git add "$PACKAGE_PATH_IN_REPO" || { echo "Warning: Could not add '$PACKAGE_PATH_IN_REPO' to Git staging area."; }
echo "New files staged for commit."

echo "--- Process Complete! ---"
echo "Remember to commit and push your changes to GitHub:"
echo "  cd $DOTFILES_REPO_DIR"
echo "  git commit -m \"Add $PACKAGE_NAME dotfiles\""
echo "  git push origin main"