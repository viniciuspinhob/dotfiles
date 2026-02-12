How to Use the Script
Save the script:
Save the code above into a file, for example, add_dotfile.sh, in a convenient location (e.g., in your ~/Developer/dotfiles directory itself, or in a ~/bin directory if you have one).

Make it executable:

Bash
chmod +x add_dotfile.sh
Run the script:
You'll run the script with two arguments:

The absolute path to the file or folder you want to manage (you can use ~ for your home directory).

The name of the Stow package you want to create for it.

Examples:

Adding ~/.gitconfig:

Bash
./add_dotfile.sh ~/.gitconfig git
(This will create ~/Developer/dotfiles/git/.gitconfig and symlink ~/.gitconfig to it.)

Adding ~/Library/Application Support/Code/User/settings.json (for VS Code):

Bash
./add_dotfile.sh "~/Library/Application Support/Code/User/settings.json" vscode_settings
(This will create ~/Developer/dotfiles/vscode_settings/Library/Application Support/Code/User/settings.json and symlink it.)
Note the quotes around the path due to spaces.

Adding a custom script ~/bin/myscript:

Bash
./add_dotfile.sh ~/bin/myscript custom_bin
(This will create ~/Developer/dotfiles/custom_bin/bin/myscript and symlink it.)
