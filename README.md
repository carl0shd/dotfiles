# Dotfiles

Personal dotfiles for macOS. Uses [GNU Stow](https://www.gnu.org/software/stow/) to symlink configs.

## What's included

| Package | Description |
|---------|-------------|
| `zsh/` | Shell config (NVM, Oh My Posh, git aliases, plugins) |
| `ghostty/` | Terminal config (Hack Nerd Font, theme OhMyCustom) |
| `oh-my-posh/` | Prompt theme configuration |
| `fastfetch/` | System info on shell launch (config + custom logo) |
| `homebrew/` | Brew install script (CLI tools, casks, fonts) |
| `scripts/` | Claude Code multi-account switcher |
| `backup/` | Backup and restore scripts for full Mac migration |

## New Mac Setup

### 1. Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Clone this repo

```bash
git clone https://github.com/maximux13/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 3. Install apps and tools

```bash
chmod +x homebrew/install.sh
./homebrew/install.sh
```

### 4. Apply configs with Stow

```bash
brew install stow
stow zsh          # ~/.zshrc, ~/.zprofile
stow ghostty      # ~/.config/ghostty/config + themes
stow oh-my-posh   # ~/.config/oh-my-posh/theme.omp.json
stow fastfetch    # ~/.config/fastfetch/config.jsonc + logo.txt
```

### 5. Install ZSH plugins

```bash
mkdir -p ~/.zsh
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
```

### 6. Scripts

```bash
stow scripts   # ~/.scripts/claude-switch-multi.sh
```

## Backup / Restore

For full Mac migration (secrets, dotfiles, Homebrew, workspace):

```bash
# Backup to external drive
./backup/backup.sh /Volumes/USB/

# Backup including workspace projects
./backup/backup.sh /Volumes/USB/ --workspace

# Restore from backup
./backup/restore.sh /Volumes/USB/mac-backup-YYYY-MM-DD/
```

## License

[MIT](LICENSE)
