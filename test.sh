try() {
	echo "Setting GRUB theme..."
	GRUB_CFG="/etc/default/grub"
	THEME_NAME="albedo-grub-theme"
	THEME_LINE="GRUB_THEME=$DEST_DIR/$THEME_NAME/theme.txt"

	# Add or replace the GRUB_THEME line
	if grep -q "^GRUB_THEME=" "$GRUB_CFG"; then
		echo "hello"
		sudo sed -i "s|^GRUB_THEME=.*|$THEME_LINE|" "$GRUB_CFG"
	else
		echo "else"
		echo "$THEME_LINE" | sudo tee -a "$GRUB_CFG" >/dev/null
	fi

}
create_symlink() {
	local app="$1"

	local pkg_name="$app"
	local config_name="$app"

	case "$app" in
	fish)
		pkg_name="fish"
		config_name="fish"
		;;
	esac

	local src_dir
	src_dir="$(pwd)/.config/$config_name"

	local dest_dir="$HOME/.config/$config_name"

	if pacman -Qq "$pkg_name" &>/dev/null; then
		[ -e "$dest_dir" ] && rm -rf "$dest_dir"
		ln -s "$src_dir" "$dest_dir"
	else
		echo "$pkg_name is not installed"
	fi
}
# create_symlink fish
noctalia_v5_setup() {
	local src="$PWD/.config/noctalia/settings.toml"
	local dst="$HOME/.local/state/noctalia/settings.toml"

	if ! command -v noctalia >/dev/null 2>&1; then
		echo "error: Noctalia is not installed." >&2
		return 1
	fi

	local version
	version="$(noctalia --version 2>/dev/null)" || {
		echo "error: unable to determine Noctalia version." >&2
		return 1
	}

	if ! [[ "$version" =~ ([0-9]+)\. ]]; then
		echo "error: unable to parse Noctalia version: $version" >&2
		return 1
	fi

	if ((BASH_REMATCH[1] < 5)); then
		echo "error: Noctalia v5+ required; found $version." >&2
		return 1
	fi

	if [[ ! -f "$src" ]]; then
		echo "error: dotfiles settings file not found:" >&2
		echo "       $src" >&2
		return 1
	fi

	mkdir -p "$(dirname "$dst")" || return 1

	if [[ -L "$dst" ]]; then
		if [[ "$(readlink -f "$dst")" == "$(readlink -f "$src")" ]]; then
			echo "Noctalia settings already linked."
			return 0
		fi

		echo "error: existing symlink points somewhere else:" >&2
		echo "       $dst -> $(readlink "$dst")" >&2
		return 1
	fi

	if [[ -e "$dst" ]]; then
		echo "error: Noctalia settings already exists and is not a symlink:" >&2
		echo "       $dst" >&2
		return 1
	fi

	ln -s "$src" "$dst" || return 1

	echo "Linked Noctalia settings:"
	echo "  $src -> $dst"
}
run_shell_check() {
	#!/usr/bin/env bash

	log="shellcheck.log"

	# Exact filenames to ignore.
	ignore=(
		"40_custom"
		"scope.sh"
	)

	find_args=()

	for item in "${ignore[@]}"; do
		find_args+=(! -name "$item")
	done

	: >"$log"
	count=0

	while IFS= read -r -d '' file; do
		if [[ $(file -b -- "$file") == *"shell script"* ]]; then
			((count++))

			{
				shellcheck "$file"
				shfmt -w "$file"
			} >>"$log" 2>&1
		fi
	done < <(
		find . -type d \( -name .git -o -name node_modules -o -name .venv \) -prune -o \
			-type f "${find_args[@]}" -print0
	)

	printf 'Checked: %d scripts\n' "$count"
	printf 'Ignored files: %s\n' "${ignore[*]}"
	printf 'Log: %s/shellcheck.log\n' "$PWD"
}

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

echo $DOTFILES_DIR
run_shell_check
