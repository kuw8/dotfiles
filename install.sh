#!/bin/bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

info() { printf "\033[1;34m→\033[0m %s\n" "$1"; }
ok()   { printf "\033[1;32m✓\033[0m %s\n" "$1"; }

link() {
    local src="$1" dst="$2"
    if [ -L "$dst" ]; then
        rm "$dst"
    elif [ -e "$dst" ]; then
        mv "$dst" "${dst}.bak"
        info "Backed up $dst → ${dst}.bak"
    fi
    mkdir -p "$(dirname "$dst")"
    ln -sf "$src" "$dst"
    ok "Linked $dst"
}

# ── Homebrew ──────────────────────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
    info "Installing Homebrew…"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

info "Installing Homebrew packages…"
brew bundle --file="$DOTFILES/Brewfile"

# ── Oh My Zsh ─────────────────────────────────────────────────────────────────
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    info "Installing Oh My Zsh…"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# zsh plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# ── Symlinks ──────────────────────────────────────────────────────────────────
link "$DOTFILES/amethyst/.amethyst.yml"       "$HOME/.amethyst.yml"
link "$DOTFILES/zsh/.zshrc"                   "$HOME/.zshrc"
link "$DOTFILES/zsh/.zprofile"                "$HOME/.zprofile"
link "$DOTFILES/git/.gitconfig"               "$HOME/.gitconfig"

# ── macOS Defaults ────────────────────────────────────────────────────────────
info "Setting macOS defaults…"

# Faster key repeat
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Disable press-and-hold for accent characters (enables key repeat everywhere)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Show file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show path bar, status bar, default to list view
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Disable .DS_Store on network/USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Dock: auto-hide, small icons, no recents
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 48
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock mru-spaces -bool false  # don't rearrange spaces

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

ok "macOS defaults set (some may need a logout to take effect)"

# ── Launch Amethyst ───────────────────────────────────────────────────────────
info "Launching Amethyst…"
open -a Amethyst

echo ""
ok "Dotfiles installed! Grant Amethyst Accessibility permissions when prompted."
ok "Keybindings: Option+Shift+Space (cycle layout), Option+Shift+Enter (swap main)"
echo ""
