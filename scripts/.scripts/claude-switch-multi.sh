#!/bin/bash

# Claude Code Multi-Account Switcher
# Usage: ./claude-switch-multi.sh [account1|account2|account3|save-current|list|status]

CLAUDE_DIR="$HOME/.claude"
CLAUDE_CONFIG="$HOME/.claude.json"
BACKUP_DIR="$HOME/.claude-accounts"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Check if Claude Code is running (warn user)
check_claude_running() {
    if pgrep -f "claude" > /dev/null 2>&1; then
        echo "⚠️  Warning: Claude Code may be running. Close all Claude sessions for best results."
        echo "   Continue anyway? (y/N)"
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            echo "Aborted."
            exit 0
        fi
    fi
}

# Function to switch to any account
switch_account() {
    local account="$1"
    check_claude_running
    echo "Switching to $account..."

    # Auto-save current state if it matches any known account
    if [ -f "$CLAUDE_CONFIG" ]; then
        for existing_account in "$BACKUP_DIR"/*.json; do
            if [ -f "$existing_account" ]; then
                account_name=$(basename "$existing_account" .json)
                if cmp -s "$CLAUDE_CONFIG" "$existing_account" 2>/dev/null; then
                    echo "🔄 Auto-saving $account_name conversations..."
                    cp "$CLAUDE_CONFIG" "$existing_account"
                    if [ -d "$CLAUDE_DIR" ]; then
                        rm -rf "$BACKUP_DIR/$account_name-dir"
                        cp -rp "$CLAUDE_DIR" "$BACKUP_DIR/$account_name-dir" 2>/dev/null || \
                        rsync -a --delete "$CLAUDE_DIR/" "$BACKUP_DIR/$account_name-dir/"
                    fi
                    break
                fi
            fi
        done
    fi

    # Switch to requested account
    if [ -f "$BACKUP_DIR/$account.json" ]; then
        cp "$BACKUP_DIR/$account.json" "$CLAUDE_CONFIG"
        if [ -d "$BACKUP_DIR/$account-dir" ]; then
            # Force remove even with locked files (macOS)
            rm -rf "$CLAUDE_DIR" 2>/dev/null
            if [ -d "$CLAUDE_DIR" ]; then
                # If still exists, try removing extended attributes and retry
                xattr -cr "$CLAUDE_DIR" 2>/dev/null
                chmod -R u+rwX "$CLAUDE_DIR" 2>/dev/null
                rm -rf "$CLAUDE_DIR"
            fi
            cp -rp "$BACKUP_DIR/$account-dir" "$CLAUDE_DIR" 2>/dev/null || \
            rsync -a "$BACKUP_DIR/$account-dir/" "$CLAUDE_DIR/"
        fi
        echo "✅ Switched to $account (with conversation history)"
    else
        echo "❌ $account backup not found. Run './claude-switch-multi.sh save-current $account' first."
    fi
}

case "$1" in
    "save-current")
        if [ -z "$2" ]; then
            echo "Usage: ./claude-switch-multi.sh save-current [account_name]"
            exit 1
        fi
        check_claude_running
        echo "Saving current configuration as $2..."
        cp "$CLAUDE_CONFIG" "$BACKUP_DIR/$2.json"
        if [ -d "$CLAUDE_DIR" ]; then
            rm -rf "$BACKUP_DIR/$2-dir"
            cp -rp "$CLAUDE_DIR" "$BACKUP_DIR/$2-dir" 2>/dev/null || \
            rsync -a "$CLAUDE_DIR/" "$BACKUP_DIR/$2-dir/"
        fi
        echo "✅ Current configuration saved as $2"
        ;;
    "list")
        echo "Available accounts:"
        for account_file in "$BACKUP_DIR"/*.json; do
            if [ -f "$account_file" ]; then
                account_name=$(basename "$account_file" .json)
                echo "  - $account_name"
            fi
        done
        ;;
    "status")
        echo "Current Account Status:"
        current_account="unknown"
        for account_file in "$BACKUP_DIR"/*.json; do
            if [ -f "$account_file" ]; then
                account_name=$(basename "$account_file" .json)
                if cmp -s "$CLAUDE_CONFIG" "$account_file" 2>/dev/null; then
                    current_account="$account_name"
                    break
                fi
            fi
        done

        if [ "$current_account" != "unknown" ]; then
            echo "✅ Currently using: $current_account"
        else
            echo "❓ Unknown account (not saved yet)"
        fi
        ;;
    *)
        # Check if it's an account name (not a command)
        if [ -n "$1" ] && [ "$1" != "list" ] && [ "$1" != "status" ] && [ "$1" != "save-current" ]; then
            switch_account "$1"
        else
            echo "Claude Code Multi-Account Switcher"
            echo ""
            echo "Usage:"
            echo "  claude-switch save-current [account_name]  # Save current config"
            echo "  claude-switch [account_name]               # Switch to account"
            echo "  claude-switch list                         # List all accounts"
            echo "  claude-switch status                       # Check current account"
            echo ""
            echo "Examples:"
            echo "  claude-switch save-current account1"
            echo "  claude-switch save-current work-account"
            echo "  claude-switch account1"
            echo "  claude-switch work-account"
            echo ""
            echo "Setup Instructions:"
            echo "1. Login to your first account: claude setup-token"
            echo "2. Save it: claude-switch save-current account1"
            echo "3. Login to second account: claude setup-token"
            echo "4. Save it: claude-switch save-current account2"
            echo "5. Repeat for more accounts..."
            echo ""
            echo "💡 Tip: Use 'claude --resume' to see conversation history for current account"
        fi
        ;;
esac