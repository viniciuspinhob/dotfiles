set -gx SHELL (which fish)


### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
set --export --prepend PATH "/Users/fo126029/.rd/bin"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

thefuck --alias | source

# Always on TMUX mode
# if test -z "$TMUX"
#     set session_name "$USER-"(date +%s%N)
#     exec tmux new-session -s $session_name
# end

# configure the prompt
function fish_prompt
    # Gruvbox colors
    set path_color fabd2f     # yellow (path)
    set branch_color fb4934   # red (git branch)
    set changed_color fe8019  # orange (git changes)
    set pointer_color 8ec07c  # aqua (prompt symbol)
    set aws_color d3869b      # purple (AWS Vault)
    set k8s_color 83a598      # blue (K8s context)
    set k8s_ns_color b8bb26   # green (K8s namespace)

    # Path
    echo -n (set_color $path_color)(prompt_pwd)(set_color normal)

    # AWS_VAULT
    if test -n "$AWS_VAULT"
        echo -n ' ['(set_color $aws_color)$AWS_VAULT(set_color normal)']'
    end

    # Kubernetes context - only if pwd contains "k8s"
    if string match -q "*k8s*" (pwd); and test -n "$AWS_VAULT"
        set k8s_context_full (kubectl config current-context 2>/dev/null)
        if test -n "$k8s_context_full"
            # only part after the last slash
            set k8s_context (string split -r -m1 '/' $k8s_context_full)[2]
            echo -n ' {'(set_color $k8s_color)$k8s_context
            set k8s_ns (kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
            if test -n "$k8s_ns"
                echo -n ':'(set_color $k8s_ns_color)$k8s_ns
            end
            echo -n (set_color normal)'}'
        end
    end

    # Git
    if git rev-parse --git-dir > /dev/null 2>&1
        set git_branch (git branch --show-current 2>/dev/null)
        if test -n "$git_branch"
            echo -n ' ('(set_color $branch_color)$git_branch
            set git_status (git status --porcelain 2>/dev/null)
            if test -n "$git_status"
                echo -n (set_color $changed_color)' ●'
            end
            echo -n (set_color normal)')'
        end
    end

    # Arrow
    echo -n ' '(set_color $pointer_color)'❯ '(set_color normal)
end
