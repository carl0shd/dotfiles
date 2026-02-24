# --- NVM Configuration ---
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# --- Git aliases ---
alias gco="git checkout"
alias gl="git pull"
alias gp="git push"

# --- Node.js version in prompt ---
node_version() {
  if command -v node &> /dev/null; then
    echo " (node $(node -v))"
  fi
}

# --- Autoload nvmrc if exists ---
autoload -U add-zsh-hook

load-nvmrc() {
  if [ -f .nvmrc ]; then
    nvm use > /dev/null
  elif [ -n "$NVM_RC_VERSION" ]; then
    nvm use default > /dev/null
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc   # also run it when opening the shell

# --- Claude Switch setup ---
export PATH="$HOME/.local/bin:$PATH"
alias claude-switch="~/.scripts/claude-switch-multi.sh"

# --- Starship configuration ---
eval "$(starship init zsh)"

# --- ZSH Plugins ---
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh