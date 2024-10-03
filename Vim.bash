#!/bin/bash

# Update package list and install Vim
sudo apt update
sudo apt install -y vim

# Install necessary packages for Vim plugins
sudo apt install -y git curl build-essential cmake python3-dev

# Create Vim configuration directory if it doesn't exist
mkdir -p ~/.vim/pack/plugins/start

# Install Vim-Plug for managing plugins
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Create .vimrc with basic configurations and plugins
cat <<EOL > ~/.vimrc
" Enable syntax highlighting
syntax on

" Set line numbers
set number

" Enable file type detection and plugin
filetype plugin indent on

" Use spaces instead of tabs
set expandtab
set tabstop=4
set shiftwidth=4

" Use Vim-Plug to manage plugins
call plug#begin('~/.vim/plugged')

" Autocomplete plugin
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Syntax highlighting for C, C++, Python
Plug 'vim-python/python-syntax'
Plug 'octol/vim-cpp-enhanced-highlight'

call plug#end()

" Configure coc.nvim for autocomplete
let g:coc_global_extensions = ['coc-clangd', 'coc-python']

EOL

# Install plugins using Vim-Plug
vim +PlugInstall +qall

echo "Vim is set up for C, C++, and Python development with autocomplete and syntax highlighting!"
