#!/bin/bash

# Script to add a pattern to the global .gitignore file.

# Define the path to the global .gitignore file.
# IMPORTANT: This path assumes you are running the script from the root
# of your dotfiles repository, and that 'gitignore_global' is a directory
# containing the actual .gitignore_global file.
GLOBAL_GITIGNORE_FILE="gitignore_global/.gitignore_global"

# Check if the file exists. If not, create it.
if [ ! -f "$GLOBAL_GITIGNORE_FILE" ]; then
    echo "Warning: The file '$GLOBAL_GITIGNORE_FILE' does not exist. Creating it now."
    mkdir -p "$(dirname "$GLOBAL_GITIGNORE_FILE")" # Ensure the directory exists
    touch "$GLOBAL_GITIGNORE_FILE"
fi

# Prompt the user for the pattern to add.
read -p "Enter the pattern to add to your global .gitignore (e.g., .venv, *.log, build/): " PATTERN

# Check if the pattern is empty.
if [ -z "$PATTERN" ]; then
    echo "No pattern entered. Exiting without changes."
    exit 0
fi

# Append the pattern to the file.
echo "$PATTERN" >> "$GLOBAL_GITIGNORE_FILE"

echo "Successfully added '$PATTERN' to '$GLOBAL_GITIGNORE_FILE'."
echo "Current contents of '$GLOBAL_GITIGNORE_FILE':"
cat "$GLOBAL_GITIGNORE_FILE"
