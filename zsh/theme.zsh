# ~/.zshrc

# Enable command substitution in the prompt string.
setopt prompt_subst

# Helper function to display AWS Vault status
prompt_aws_vault() {
  if [[ -n "$AWS_VAULT" ]]; then
    # Print [AWS_VAULT] in purple
    echo -n " [%F{magenta}${AWS_VAULT}%f]"
  fi
}

# Helper function to display Kubernetes context and namespace
prompt_k8s() {
  # Only show if pwd contains "k8s" and AWS_VAULT is set
  if [[ "$PWD" == *k8s* && -n "$AWS_VAULT" ]]; then
    local k8s_context_full k8s_context k8s_ns
    k8s_context_full=$(kubectl config current-context 2>/dev/null)
    
    if [[ -n "$k8s_context_full" ]]; then
      # Get the part of the context after the last slash '/'
      k8s_context=${k8s_context_full##*/}
      
      # Start building the output string with the context in blue
      echo -n " {%F{blue}${k8s_context}%f"
      
      k8s_ns=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
      if [[ -n "$k8s_ns" ]]; then
        # If a namespace exists, append it in green
        echo -n ":%F{green}${k8s_ns}%f"
      fi
      
      # Close the curly brace
      echo -n "}"
    fi
  fi
}

# Helper function to display Git branch and status
prompt_git() {
  # Check if we are in a git repository
  if git rev-parse --git-dir > /dev/null 2>&1; then
    local git_branch git_status
    git_branch=$(git branch --show-current 2>/dev/null)
    
    if [[ -n "$git_branch" ]]; then
      # Start building the string with the branch name in red
      echo -n " (%F{red}${git_branch}%f"
      
      git_status=$(git status --porcelain 2>/dev/null)
      if [[ -n "$git_status" ]]; then
        # If there are changes, add an orange/yellow dot
        echo -n "%F{yellow} ●%f"
      fi
      
      # Close the parenthesis
      echo -n ")"
    fi
  fi
}


# --- PROMPT DEFINITION ---
# This assembles the final prompt string.
# %~         - Path relative to home directory
# $(...)     - Executes a command and substitutes its output
# %F{color}  - Sets the foreground color
# %f         - Resets the foreground color

PROMPT='%F{yellow}%~%f'           # Path
PROMPT+='$(prompt_aws_vault)'     # AWS Vault info
PROMPT+='$(prompt_k8s)'           # Kubernetes info
PROMPT+='$(prompt_git)'           # Git info
PROMPT+=' %F{cyan}❯ %f'            # Prompt symbol

# -----------------------------------------------------------------
