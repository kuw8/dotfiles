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
link "$DOTFILES/zsh/.zshrc"                   "$HOME/.zshrc"
link "$DOTFILES/zsh/.zprofile"                "$HOME/.zprofile"
link "$DOTFILES/git/.gitconfig"               "$HOME/.gitconfig"
link "$DOTFILES/ghostty/config"               "$HOME/.config/ghostty/config"
link "$DOTFILES/yabai/yabairc"                "$HOME/.config/yabai/yabairc"
link "$DOTFILES/skhd/skhdrc"                  "$HOME/.config/skhd/skhdrc"
chmod +x "$DOTFILES/yabai/yabairc"

# ── Start window manager services ─────────────────────────────────────────────
yabai --start-service || true
skhd --start-service  || true

echo ""
ok "Dotfiles installed!"
ok "Grant Accessibility permissions to yabai and skhd in System Settings."
echo ""
