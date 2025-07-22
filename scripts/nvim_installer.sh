#!/bin/bash

# Este script automatiza a instalação das dependências e plugins do Neovim
# com base nos seus arquivos de configuração, usando GNU Stow.
#
# Pré-requisitos:
# - Homebrew (brew) deve estar instalado.
# - Neovim (nvim) deve estar instalado.
# - GNU Stow (stow) deve estar instalado.
# - Seus arquivos de configuração do Neovim devem estar em ~/Developer/dotfiles/nvim.

DOTFILES_DIR="$HOME/Developer/dotfiles"
NVIM_SOURCE_DIR="$DOTFILES_DIR/nvim"
NVIM_CONFIG_TARGET_DIR="$HOME/.config"

echo "Iniciando a configuração do Neovim com GNU Stow..."

# --- 1. Verificar pré-requisitos ---

echo "Verificando se o Homebrew está instalado..."
if ! command -v brew &> /dev/null; then
    echo "Erro: Homebrew não encontrado. Por favor, instale o Homebrew primeiro."
    echo "Você pode instalá-lo com: /bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit 1
fi
echo "Homebrew encontrado."

echo "Verificando se o Neovim está instalado..."
if ! command -v nvim &> /dev/null; then
    echo "Erro: Neovim não encontrado. Por favor, instale o Neovim primeiro com: brew install neovim"
    exit 1
fi
echo "Neovim encontrado."

echo "Verificando se o GNU Stow está instalado..."
if ! command -v stow &> /dev/null; then
    echo "Erro: GNU Stow não encontrado. Por favor, instale-o com: brew install stow"
    exit 1
fi
echo "GNU Stow encontrado."

# --- 2. Verificar a existência do diretório de dotfiles ---

echo "Verificando o diretório de dotfiles: $NVIM_SOURCE_DIR..."
if [ ! -d "$NVIM_SOURCE_DIR" ]; then
    echo "Erro: O diretório de configuração do Neovim ($NVIM_SOURCE_DIR) não foi encontrado."
    echo "Por favor, certifique-se de que seus arquivos de configuração do Neovim estão em $DOTFILES_DIR/nvim."
    exit 1
fi
echo "Diretório de dotfiles encontrado."

# --- 3. Criar o diretório de destino para o stow ---

echo "Criando o diretório de destino para o stow em $NVIM_CONFIG_TARGET_DIR..."
mkdir -p "$NVIM_CONFIG_TARGET_DIR"
echo "Diretório criado."

# --- 4. Usar GNU Stow para criar o link simbólico ---

echo "Criando link simbólico para a configuração do Neovim usando stow..."
# Navega para o diretório dos dotfiles para que 'stow nvim' funcione corretamente
(cd "$DOTFILES_DIR" && stow nvim -t "$NVIM_CONFIG_TARGET_DIR")
if [ $? -ne 0 ]; then
    echo "Erro: Falha ao executar 'stow'. Verifique se o diretório $NVIM_CONFIG_TARGET_DIR/nvim já existe ou se há conflitos."
    echo "Você pode tentar remover o diretório existente com: rm -rf $NVIM_CONFIG_TARGET_DIR/nvim"
    exit 1
fi
echo "Link simbólico criado com sucesso: $NVIM_CONFIG_TARGET_DIR/nvim -> $NVIM_SOURCE_DIR"

# --- 5. Instalar Vim-Plug ---

echo "Instalando Vim-Plug..."
PLUG_VIM_PATH="$HOME/.local/share/nvim/site/autoload/plug.vim"
mkdir -p "$(dirname "$PLUG_VIM_PATH")"
curl -fLo "$PLUG_VIM_PATH" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo "Vim-Plug instalado."

# --- 6. Instalar dependências via Homebrew ---

echo "Instalando dependências via Homebrew (Node.js, Python)..."
brew install node python
echo "Dependências instaladas."

# --- 7. Instalar plugins do Neovim ---

echo "Instalando plugins do Neovim (isso pode levar um tempo)..."
# O comando --headless executa o Neovim sem interface gráfica
# +PlugInstall instala os plugins
# +qa sai do Neovim após a execução
nvim --headless +PlugInstall +qa
echo "Plugins do Neovim instalados."

# --- 8. Atualizar parsers do nvim-treesitter ---

echo "Atualizando parsers do nvim-treesitter..."
nvim --headless +TSUpdate +qa
echo "Parsers do nvim-treesitter atualizados."

# --- 9. Instalar gadgets do Vimspector ---

echo "Instalando gadgets do Vimspector (como debugpy)..."
nvim --headless +VimspectorInstall +qa
echo "Gadgets do Vimspector instalados."

echo "Configuração do Neovim concluída com sucesso!"
echo "Você pode iniciar o Neovim digitando 'nvim' no terminal."


