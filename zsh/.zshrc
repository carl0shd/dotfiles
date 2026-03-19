# --- Fastfetch (system info on launch) ---
fastfetch

# --- NVM Configuration ---
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm

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

export PATH="$HOME/.local/bin:$PATH"

# --- Zoxide (smart cd) ---
eval "$(zoxide init zsh)"

# --- Fzf (fuzzy finder) ---
source <(fzf --zsh)

# --- Oh My Posh configuration ---
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/theme.omp.json)"

# --- ZSH Plugins ---
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#FF9248,underline'
ZSH_HIGHLIGHT_STYLES[command]='fg=#98C379'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#98C379'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#98C379'

# --- CW (Claude Workspace Manager) ---
[[ -f "$HOME/.cw/cw-shell-integration.sh" ]] && source "$HOME/.cw/cw-shell-integration.sh"
export CW_WORKSPACE="$HOME/Documents"

# --- Android Configuration ---
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
export ANDROID_HOME=/Users/carlosvillalobos/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
