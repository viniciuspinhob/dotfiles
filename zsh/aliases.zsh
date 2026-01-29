### Aliases ###

# General
alias cdd="cd  ~/Developer"
alias cdh="cd $HOME"
alias fzp="fzf --preview 'cat {}'"
alias fzc='cat $(fzf)'

# Development
## Python
alias rmpc="find . | grep -E '(/__pycache__$|\.pyc$|\.pyo$)' | xargs rm -rf"
## Git & Code Formatting
alias run_flake8="python3 -m flake8 --exclude .git,cicd/,__pycache__,.hg,.mypy_cache,.tox,.venv,venv,_build,buck-out,build,dist --max-line-length 120"
alias pregit="gaa && pre-commit run"
alias gmj="gitmoji -c"
## Kubernetes
alias k='kubectl'
alias kgp="kubectl get pods"
alias klt="kubectl logs --tail=-1"
alias klf="kubectl logs -f"
alias kpf="kubectl port-foward"
