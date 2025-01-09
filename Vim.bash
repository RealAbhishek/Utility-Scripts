#!/bin/bash

# Exit on any error
set -e

# Function to check command success
check_command() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed"
        exit 1
    fi
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    echo "Please don't run this script as root or with sudo"
    exit 1
fi

# Backup existing .vimrc if it exists
if [ -f ~/.vimrc ]; then
    echo "Backing up existing .vimrc to .vimrc.backup"
    mv ~/.vimrc ~/.vimrc.backup
fi

# Update package list and install Vim
echo "Updating package list and installing Vim..."
sudo apt update
check_command "apt update"
sudo apt install -y vim
check_command "vim installation"

# Install necessary packages for Vim plugins
echo "Installing dependencies..."
sudo apt install -y git curl build-essential cmake python3-dev nodejs npm
check_command "dependency installation"

# Install vim-plug for managing Vim plugins
echo "Installing vim-plug..."
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
check_command "vim-plug installation"

# Create .vimrc with configurations and plugins
echo "Creating .vimrc configuration..."
cat <<'EOL' > ~/.vimrc
" Enable syntax highlighting
syntax on

" Set line numbers
set number
set relativenumber

" Enable file type detection and plugin
filetype plugin indent on

" Use spaces instead of tabs
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" Use system clipboard
set clipboard=unnamedplus

" Enable mouse support
set mouse=a

" Set search highlighting
set hlsearch
set incsearch

" Enable auto-indentation
set autoindent
set smartindent

" Show matching brackets
set showmatch

" Set encoding
set encoding=utf-8

" Enable undo history
set undofile
set undodir=~/.vim/undodir

" Enable backup directory
set backupdir=~/.vim/backup
set directory=~/.vim/swap

" Use Vim-Plug to manage plugins
call plug#begin('~/.vim/plugged')

" Autocomplete plugin
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Syntax highlighting for multiple languages
Plug 'sheerun/vim-polyglot'

" File explorer
Plug 'preservim/nerdtree'

" Status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Git integration
Plug 'tpope/vim-fugitive'

" Git diff view
Plug 'airblade/vim-gitgutter'

" Auto pairs for brackets
Plug 'jiangmiao/auto-pairs'

" Comment toggler
Plug 'tpope/vim-commentary'

call plug#end()

" Key mappings
nmap <C-n> :NERDTreeToggle<CR>
" Clear search highlighting with Escape
nnoremap <Esc> :noh<return><Esc>


" Configure coc.nvim for autocomplete
" coc-clangd    - C/C++ support
" coc-pyright   - Python support
" coc-omnisharp - C# support
" coc-sh        - Bash support
" coc-json      - JSON support
" coc-yaml      - YAML support
let g:coc_global_extensions = [
    \ 'coc-clangd',
    \ 'coc-pyright',
    \ 'coc-omnisharp',
    \ 'coc-sh',
    \ 'coc-json',
    \ 'coc-yaml'
    \ ]

" Create required directories
silent !mkdir -p ~/.vim/{backup,swap,undodir}

" NERDTree configuration
let NERDTreeShowHidden=1
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Airline configuration
let g:airline_powerline_fonts = 1
let g:airline_theme='dark'

" Set color scheme
colorscheme desert
EOL

# Create directories for backup, swap, and undo files
mkdir -p ~/.vim/{backup,swap,undodir}
check_command "directory creation"

# Install plugins using Vim-Plug
echo "Installing Vim plugins..."
vim +PlugInstall +qall
check_command "plugin installation"

# Install CoC extensions
echo "Installing CoC extensions..."
mkdir -p ~/.config/coc/extensions
cd ~/.config/coc/extensions
if [ ! -f package.json ]; then
    echo '{"dependencies":{}}'> package.json
fi
npm install coc-clangd coc-pyright coc-omnisharp coc-sh coc-json coc-yaml --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
check_command "CoC extensions installation"

echo "Vim setup completed successfully!"
echo "Note: You may need to install language servers for full functionality:"
echo "- C/C++: clangd"
echo "- Python: pip install python-language-server"
echo "- C#: dotnet tool install --global csharp-ls"
