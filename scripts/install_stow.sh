#!/bin/bash

# ==========================================================
# Script para instalar todos os dotfiles usando GNU Stow
# ==========================================================

# 1. Definição do Diretório Base
# O caminho completo para a sua pasta 'dotfiles'.
# Ajuste este caminho se 'Developer/dotfiles' não for relativo à raiz do seu Home (~)
DOTFILES_DIR="$HOME/Developer/dotfiles" 

# O diretório alvo onde os links simbólicos serão criados (o seu diretório home)
TARGET_DIR="$HOME" 

echo "🔗 Iniciando instalação dos dotfiles usando Stow..."
echo "Diretório de origem: $DOTFILES_DIR"
echo "Diretório alvo (Target): $TARGET_DIR"

# 2. Navegação Segura para o Diretório Base
# O 'stow' deve ser executado a partir do diretório que contém os pacotes (bash, vim, etc.).
if [ -d "$DOTFILES_DIR" ]; then
    cd "$DOTFILES_DIR" || { echo "Erro: Não foi possível mudar para o diretório $DOTFILES_DIR. Abortando."; exit 1; }
else
    echo "Erro: O diretório $DOTFILES_DIR não foi encontrado. Por favor, verifique o caminho."
    exit 1
fi

echo "---"

# 3. Laço de Repetição e Execução do Stow
# Percorre todos os subdiretórios (os "pacotes" do stow)
# A opção -d (directory) em find garante que apenas diretórios sejam considerados.
# O ponto (.) exclui o próprio diretório.
find . -maxdepth 1 -mindepth 1 -type d -print0 | while IFS= read -r -d $'\0' package; do
    # Remove o "./" do início do nome do pacote para o comando stow
    package_name="${package#./}"
    
    echo "📦 Tentando instalar pacote: $package_name"
    
    # Executa o stow: 
    # -v: verbose (mostra o que está fazendo)
    # -t: target (diretório alvo, que é o seu home)
    stow -v -t "$TARGET_DIR" "$package_name"
    
    # Verifica o código de saída do comando anterior
    if [ $? -eq 0 ]; then
        echo "   ✅ Sucesso ao instalar $package_name."
    else
        echo "   ❌ Aviso/Erro ao tentar instalar $package_name. Verifique se há conflitos."
    fi
    echo "" # Linha em branco para melhor leitura
done

echo "---"
echo "🎉 Processo de instalação de dotfiles concluído!"
