# -------------------------
# Check if Homebrew is installed, if not, install it.
# -------------------------
if ! command -v brew &> /dev/null
then
    echo "Homebrew not installed. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Homebrew installed. Updating Homebrew..."
brew update

echo "Installing Homebrew packages..."

# -------------------------
# Leaves
# -------------------------

# Git and GitHub
brew install git
brew install gh

# Node and Package Managers
brew install nvm
brew install yarn
brew install pnpm

# Shell and Utilities
brew install zsh
brew install fzf
brew install zoxide
brew install stow
brew install coreutils
brew install jandedobbeleer/oh-my-posh/oh-my-posh
brew install lsd
brew install gitui

# Cloud and Deployment
brew install awscli
brew install flyctl
brew install supabase/tap/supabase

# Miscellaneous Utilities
brew install jq
brew install ffmpeg
brew install fastfetch
brew install tpm
brew install act

# -------------------------
# Casks
# -------------------------

# Daily
brew install --cask 1password
brew install --cask ghostty
brew install --cask slack-cli
brew install --cask notion-calendar
brew install --cask spotify
brew install --cask linear-linear
brew install jsattler/tap/bettercapture
brew install --cask steipete/tap/codexbar

# Browsers
brew install --cask arc
brew install --cask google-chrome

# Development
brew install --cask orbstack
brew install --cask postman
brew install --cask cursor
brew install --cask ngrok
brew install --cask claude-code
brew install --cask xcodes-app
brew install --cask minisim

# 3D Printing and Modeling
brew install --cask bambu-studio
brew install --cask blender

# Messaging
brew install --cask zoom
brew install --cask discord

# Fonts
brew install --cask font-hack-nerd-font

# Design
brew install --cask figma

# Misc
brew install --cask stats
brew install --cask anydesk
brew install --cask vlc
brew install --cask qbittorrent
cask "stremio"

echo "Homebrew packages installed."
