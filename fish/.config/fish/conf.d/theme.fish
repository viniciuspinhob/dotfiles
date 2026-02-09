# Fish Shell Theme/Prompt - reads from ~/.config/theme
# Use: switch-theme gruvbox|everforest|dracula

set -l _dotfiles "$DOTFILES"
test -z "$_dotfiles"; and set _dotfiles ~/Developer/dotfiles

set -l _theme (cat ~/.config/theme 2>/dev/null | string trim)
test -z "$_theme"; and set _theme gruvbox

set -l _theme_file "$_dotfiles/scripts/theme/themes/$_theme/fish.fish"
if test -f "$_theme_file"
    source "$_theme_file"
else
    set -g theme_path_color fabd2f
    set -g theme_branch_color fb4934
    set -g theme_changed_color fe8019
    set -g theme_pointer_color 8ec07c
    set -g theme_aws_color d3869b
    set -g theme_k8s_color 83a598
    set -g theme_k8s_ns_color b8bb26
end

function fish_prompt
    echo -n (set_color $theme_path_color)(prompt_pwd)(set_color normal)

    if test -n "$AWS_VAULT"
        echo -n ' ['(set_color $theme_aws_color)$AWS_VAULT(set_color normal)']'
    end

    if string match -q "*k8s*" (pwd); and test -n "$AWS_VAULT"
        set -l k8s_context_full (kubectl config current-context 2>/dev/null)
        if test -n "$k8s_context_full"
            set -l k8s_context (string split -r -m1 '/' $k8s_context_full)[2]
            echo -n ' {'(set_color $theme_k8s_color)$k8s_context
            set -l k8s_ns (kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
            if test -n "$k8s_ns"
                echo -n ':'(set_color $theme_k8s_ns_color)$k8s_ns
            end
            echo -n (set_color normal)'}'
        end
    end

    if git rev-parse --git-dir > /dev/null 2>&1
        set -l git_branch (git branch --show-current 2>/dev/null)
        if test -z "$git_branch"
            set git_branch (git symbolic-ref --short HEAD 2>/dev/null)
        end
        if test -z "$git_branch"
            set -l git_dir (git rev-parse --git-dir 2>/dev/null)
            if test -f "$git_dir/rebase-merge/head-name"
                set git_branch (cat "$git_dir/rebase-merge/head-name" | string replace 'refs/heads/' '')
                set git_branch "rebasing $git_branch"
            else if test -f "$git_dir/rebase-apply/head-name"
                set git_branch (cat "$git_dir/rebase-apply/head-name" | string replace 'refs/heads/' '')
                set git_branch "rebasing $git_branch"
            else if test -f "$git_dir/MERGE_HEAD"
                set git_branch "merging"
            else if test -f "$git_dir/CHERRY_PICK_HEAD"
                set git_branch "cherry-picking"
            else
                set git_branch (git rev-parse --short HEAD 2>/dev/null)
            end
        end
        if test -n "$git_branch"
            echo -n ' ('(set_color $theme_branch_color)$git_branch
            set -l git_status (git status --porcelain 2>/dev/null)
            if test -n "$git_status"
                echo -n (set_color $theme_changed_color)' ●'
            end
            echo -n (set_color normal)')'
        end
    end

    echo -n ' '(set_color $theme_pointer_color)'❯ '(set_color normal)
end

function fish_right_prompt
end

function reload-theme
    set -l _df "$DOTFILES"
    test -z "$_df"; and set _df ~/Developer/dotfiles
    set -l _theme (cat ~/.config/theme 2>/dev/null | string trim)
    test -z "$_theme"; and set _theme gruvbox
    set -l _theme_file "$_df/scripts/theme/themes/$_theme/fish.fish"
    if test -f "$_theme_file"
        source "$_theme_file"
        echo "Theme reloaded: $_theme"
    else
        set -g theme_path_color fabd2f
        set -g theme_branch_color fb4934
        set -g theme_changed_color fe8019
        set -g theme_pointer_color 8ec07c
        set -g theme_aws_color d3869b
        set -g theme_k8s_color 83a598
        set -g theme_k8s_ns_color b8bb26
        echo "Theme reloaded: $_theme (defaults)"
    end
end
