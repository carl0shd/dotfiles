#!/bin/bash
# Returns git branch with tmux color based on repo status
# Colors match Oh My Posh theme
dir="$1"
cd "$dir" 2>/dev/null || exit 0

branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
[ -z "$branch" ] && exit 0

if ! git diff --quiet 2>/dev/null || ! git diff --cached --quiet 2>/dev/null; then
  # Dirty: orange #C44F02
  echo "#[fg=#C44F02]$branch#[default]"
else
  # Clean: amber #986801
  echo "#[fg=#986801]$branch#[default]"
fi
