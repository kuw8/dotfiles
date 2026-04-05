# ── Oh My Zsh ─────────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="refined"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# ── PATH ──────────────────────────────────────────────────────────────────────
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# ── Editor ────────────────────────────────────────────────────────────────────
export EDITOR="cursor"
export VISUAL="cursor"

# ── Aliases ───────────────────────────────────────────────────────────────────
alias ll="ls -lAFh"
alias la="ls -A"
alias ..="cd .."
alias ...="cd ../.."

# git
alias gs="git status"
alias gc="git commit"
alias gp="git push"
alias gl="git log --oneline --graph --decorate -20"
alias gd="git diff"
alias ga="git add"

# python
alias py="python3"
alias uvr="uv run"

# ── Mamba ─────────────────────────────────────────────────────────────────────
export MAMBA_EXE='/opt/homebrew/bin/mamba'
export MAMBA_ROOT_PREFIX="$HOME/.local/share/mamba"
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2>/dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias mamba="$MAMBA_EXE"
fi
unset __mamba_setup
