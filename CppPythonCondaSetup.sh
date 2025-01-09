#!/bin/bash

# Update package list
sudo apt update

# Install vim
sudo apt install -y vim

# Install GCC tools and build essentials
sudo apt install -y build-essential

# Install CMake
sudo apt install -y cmake

# Install Make
sudo apt install -y make

# Install Clang tools
sudo apt install -y clang

# Download and install Anaconda
ANACONDA_INSTALLER=Anaconda3-2024.10-1-Linux-x86_64.sh
wget https://repo.anaconda.com/archive/$ANACONDA_INSTALLER
bash $ANACONDA_INSTALLER -b
rm $ANACONDA_INSTALLER

# Initialize Anaconda
~/anaconda3/bin/conda init

# Install additional Python packages
~/anaconda3/bin/conda install -y numpy scipy matplotlib pandas

# Install additional C++ development tools
sudo apt install -y gdb valgrind

echo "Installation complete. Please restart your terminal or run 'source ~/.bashrc' to activate Anaconda."
