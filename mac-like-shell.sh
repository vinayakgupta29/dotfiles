#!/bin/bash

set -e

# Ensure script is run as regular user
if [ "$EUID" -eq 0 ]; then
    echo "Please do NOT run this script as root."
    exit 1
fi

# Step 1: Install zsh and useful plugins
echo "Installing Zsh and required tools..."
sudo pacman -Sy --noconfirm zsh git zsh-autosuggestions zsh-syntax-highlighting

# Step 2: Set Zsh as default shell for current user
echo "Setting Zsh as the default shell for user: $USER"
chsh -s "$(which zsh)"

# Step 3: Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh already installed. Skipping..."
fi

# Step 4: Install Powerlevel10k theme
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    echo "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
else
    echo "Powerlevel10k already installed. Skipping..."
fi

# Step 5: Clone dotfiles from your GitHub
echo "Cloning dotfiles from GitHub..."
DOTFILES_DIR="$HOME/.mac-like-shell-dotfiles"
GIT_REPO="YOUR_GITHUB_REPO_URL"  # <<< REPLACE THIS with your GitHub URL

if [ -d "$DOTFILES_DIR" ]; then
    echo "Removing old dotfiles directory..."
    rm -rf "$DOTFILES_DIR"
fi

git clone "$GIT_REPO" "$DOTFILES_DIR"

# Step 6: Symlink .zshrc and .p10k.zsh to $HOME
echo "Linking .zshrc and .p10k.zsh to home directory..."
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.p10k.zsh" "$HOME/.p10k.zsh"

echo "✅ All done! Restart your terminal or run 'exec zsh' to switch to the new shell."
