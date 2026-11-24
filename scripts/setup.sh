#!/usr/bin/env bash
set -euo pipefail

# Resolve repository paths relative to this script
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# User-level installation directory
BIN_DIR="$HOME/bin/scripts"

mkdir -p "$BIN_DIR"

# Symlink every regular file from the repository scripts directory
for file in "$SCRIPT_DIR"/*; do
	[[ -f "$file" ]] || continue

	name="$(basename "$file")"
	ln -sfn "$file" "$BIN_DIR/$name"
done

# Add scripts directory to Fish PATH
FISH_CONFIG="$HOME/.config/fish/config.fish"
mkdir -p "$(dirname "$FISH_CONFIG")"
touch "$FISH_CONFIG"

if ! grep -Fq "fish_add_path $HOME/bin/scripts" "$FISH_CONFIG"; then
	echo "fish_add_path $HOME/bin/scripts" >>"$FISH_CONFIG"
fi

echo "Scripts linked successfully to $BIN_DIR"
