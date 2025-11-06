# ~/.zshrc

# -----------------------------------------------------------------
# Iniciar TMUX: Conectar à sessão existente ou criar uma nova.
# -----------------------------------------------------------------
# Executar apenas se não estivermos em uma sessão TMUX e se for um terminal interativo.
if [[ -z "$TMUX" && -t 0 ]]; then
    local existing_session=$(tmux list-sessions -F '#S' 2>/dev/null | head -n 1)

    if [[ -n "$existing_session" ]]; then
        # Anexa à primeira sessão encontrada.
        exec tmux attach-session -t "$existing_session"
    else
        # Se nenhuma sessão for encontrada, cria uma nova.
        exec tmux new-session
    fi
fi
