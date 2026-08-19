setopt prompt_subst

load_theme() {
    local dotfiles="${DOTFILES:-$HOME/Developer/dotfiles}"
    local theme="gruvbox"
    local theme_file

    if [[ -r "$HOME/.config/theme" ]]; then
        theme="$(<"$HOME/.config/theme")"
        theme="${theme//[[:space:]]/}"
        [[ -n "$theme" ]] || theme="gruvbox"
    fi

    typeset -g theme_path_color="fabd2f"
    typeset -g theme_branch_color="fb4934"
    typeset -g theme_changed_color="fe8019"
    typeset -g theme_pointer_color="8ec07c"
    typeset -g theme_aws_color="d3869b"
    typeset -g theme_k8s_color="83a598"
    typeset -g theme_k8s_ns_color="b8bb26"

    theme_file="$dotfiles/scripts/theme/themes/$theme/fish.fish"
    if [[ -r "$theme_file" ]]; then
        local command scope name value
        while read -r command scope name value; do
            case "$name" in
                theme_path_color|theme_branch_color|theme_changed_color|theme_pointer_color|theme_aws_color|theme_k8s_color|theme_k8s_ns_color)
                    typeset -g "$name=$value"
                    ;;
            esac
        done < "$theme_file"
    fi

    typeset -g current_theme="$theme"
}

prompt_aws_vault() {
    [[ -n "$AWS_VAULT" ]] || return
    print -nr -- " [%F{#$theme_aws_color}${AWS_VAULT}%f]"
}

prompt_path() {
    local path="${PWD/#$HOME/~}"
    local result=""
    local part
    local index
    local -a parts

    [[ "$path" == /* ]] && result="/"
    parts=("${(@s:/:)path}")

    for ((index = 1; index <= ${#parts}; index++)); do
        part="${parts[index]}"
        [[ -n "$part" ]] || continue

        if ((index < ${#parts})) && [[ "$part" != "~" ]]; then
            if [[ "$part" == .* ]]; then
                part="${part[1,2]}"
            else
                part="${part[1]}"
            fi
        fi

        [[ -z "$result" || "$result" == "/" ]] || result+="/"
        result+="$part"
    done

    print -nr -- "${result//\%/%%}"
}

prompt_k8s() {
    [[ "$PWD" == *k8s* && -n "$AWS_VAULT" ]] || return

    local context namespace
    context="$(kubectl config current-context 2>/dev/null)"
    [[ -n "$context" ]] || return
    context="${context##*/}"

    print -nr -- " {%F{#$theme_k8s_color}${context}"
    namespace="$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)"
    if [[ -n "$namespace" ]]; then
        print -nr -- ":%F{#$theme_k8s_ns_color}${namespace}"
    fi
    print -nr -- "%f}"
}

prompt_git_status() {
    git rev-parse --git-dir >/dev/null 2>&1 || return

    local branch git_dir git_status
    branch="$(git branch --show-current 2>/dev/null)"
    [[ -n "$branch" ]] || branch="$(git symbolic-ref --short HEAD 2>/dev/null)"

    if [[ -z "$branch" ]]; then
        git_dir="$(git rev-parse --git-dir 2>/dev/null)"
        if [[ -f "$git_dir/rebase-merge/head-name" ]]; then
            branch="rebasing $(<"$git_dir/rebase-merge/head-name")"
            branch="${branch/refs\/heads\//}"
        elif [[ -f "$git_dir/rebase-apply/head-name" ]]; then
            branch="rebasing $(<"$git_dir/rebase-apply/head-name")"
            branch="${branch/refs\/heads\//}"
        elif [[ -f "$git_dir/MERGE_HEAD" ]]; then
            branch="merging"
        elif [[ -f "$git_dir/CHERRY_PICK_HEAD" ]]; then
            branch="cherry-picking"
        else
            branch="$(git rev-parse --short HEAD 2>/dev/null)"
        fi
    fi

    [[ -n "$branch" ]] || return
    print -nr -- " (%F{#$theme_branch_color}${branch}"
    git_status="$(git status --porcelain 2>/dev/null)"
    [[ -z "$git_status" ]] || print -nr -- "%F{#$theme_changed_color} ●"
    print -nr -- "%f)"
}

reload-theme() {
    load_theme
    zle reset-prompt 2>/dev/null || true
    echo "Theme reloaded: $current_theme"
}

switch-theme() {
    local dotfiles="${DOTFILES:-$HOME/Developer/dotfiles}"
    "$dotfiles/scripts/theme/switch-theme" "$@" && reload-theme
}

load_theme
PROMPT='%F{#$theme_path_color}$(prompt_path)%f$(prompt_aws_vault)$(prompt_k8s)$(prompt_git_status) %F{#$theme_pointer_color}❯ %f'
