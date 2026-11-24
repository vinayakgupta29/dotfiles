#!/usr/bin/env bash

set -e
install_yay() {
	git clone https://aur.archlinux.org/yay.git
	pushd yay || return
	makepkg -si
	popd || return
}
install_packages() {
	local pkg_file="$DOTFILES_DIR/packages.lst"
	if [[ ! -f "$pkg_file" ]]; then
		echo "Error: Official package file '$pkg_file' not found!" >&2
		exit 1
	fi
	local packages
	mapfile -t packages < <(sed -E 's/#.*$//; /^\s*$/d' "$pkg_file")
	if [[ ${#packages[@]} -eq 0 ]]; then
		echo "Error: No packages found in '$pkg_file'!" >&2
		exit 1
	fi
	sudo pacman -S --needed --noconfirm "${packages[@]}"
}

set_dolphin_mime() {
	curl --create-dirs -L https://raw.githubusercontent.com/KDE/plasma-workspace/master/menu/desktop/plasma-applications.menu -o "$HOME/.config/menus/applications.menu"
	kbuildsycoca6
}
install_sounds() {
	DEST_DIR="$HOME/.local/sounds"
	rm -rf "$DEST_DIR"
	mkdir -p "$DEST_DIR"
	ln -s "$DOTFILES_DIR/sounds/custom" "$DEST_DIR"

	echo "Moved the sounds to $DEST_DIR"
}
setup_xterm() {
	ln -s "$DOTFILES_DIR/.Xresources" "$HOME/.Xresources"
	xrdb -merge ~/.Xresources
}

setup_shell() {
	link_dotfile() {
		local src="$1" dst="$2"
		mkdir -p "$(dirname "$dst")"
		if [[ -e "$dst" && ! -L "$dst" ]]; then
			echo "Backing up existing non-symlink file: $dst -> $dst.backup"
			mv "$dst" "$dst.backup.$(date +%s)"
		fi
		ln -sfn "$src" "$dst"
	}
	link_dotfile "$DOTFILES_DIR/.bash_profile" "$HOME/.bash_profile"
	link_dotfile "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
	link_dotfile "$DOTFILES_DIR/.gvimrc" "$HOME/.gvimrc"
	link_dotfile "$DOTFILES_DIR/.gtkrc-2.0" "$HOME/.gtkrc-2.0"
}

enable_services() {
	enable_and_start_service NetworkManager

	enable_and_start_service iwd

	enable_and_start_service avahi-daemon

	enable_and_start_service firewalld

	enable_and_start_service bluetooth

	enable_and_start_service polkit

	enable_and_start_service docker

	if [ -n "${SUDO_USER:-}" ] && [ "$SUDO_USER" != "root" ]; then
		runuser -l "$SUDO_USER" -C "
		systemctl --user daemon-reload 
		systemctl --global enable --now pipewire.socket wireplumber.service"
	fi
}

enable_and_start_service() {
	SERVICE=$1
	sudo systemctl enable "$SERVICE.service"
	sudo systemctl start "$SERVICE.service"
	echo "Enabled and Started $SERVICE.service..."
}

install_AUR_packages() {

	install_yay

	local aur_file="$DOTFILES_DIR/aur_pkgs.lst"
	if [[ ! -f "$aur_file" ]]; then
		echo "Error: AUR package list '$aur_file' not found!" >&2
		exit 1
	fi
	yay -S --needed --noconfirm - <"$aur_file"
}

symlink_create() {
	mkdir -p "$HOME/.config"

	create_symlink() {
		local app="$1"
		local pkg_name="$app"
		local config_name="$app"

		case "$app" in
		noctalia)
			pkg_name="noctalia-shell"
			config_name="noctalia"
			;;
		esac

		local src_dir
		src_dir="$DOTFILES_DIR/.config/$config_name"

		local dest_dir="$HOME/.config/$config_name"

		if pacman -Qq "$pkg_name" &>/dev/null; then
			[ -e "$dest_dir" ] && rm -rf "$dest_dir"
			ln -s "$src_dir" "$dest_dir"
		else
			echo "$pkg_name is not installed"
		fi
	}
	# Create symlinks
	create_symlink fastfetch
	create_symlink fish
	create_symlink hyprland
	create_symlink kitty
	create_symlink mako
	create_symlink noctalia
	create_symlink nvim
	create_symlink ranger
	create_symlink rofi
	create_symlink waybar

	# Make .sh files executable in each relevant config directory
	if pacman -Qq hyprland &>/dev/null; then
		find "$DOTFILES_DIR/.config/hypr" -type f -name "*.sh" -exec chmod +x {} +
	fi

	if pacman -Qq waybar &>/dev/null; then
		find "$DOTFILES_DIR/.config/waybar" -type f -name "*.sh" -exec chmod +x {} +
	fi

	if pacman -Qq ranger &>/dev/null; then
		find "$DOTFILES_DIR/.config/ranger" -type f -name "*.sh" -exec chmod +x {} +
	fi

	echo "Created all symlinks and set scripts executable"
}

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

install_font() {
	mkdir -p "$HOME/.local/share"
	# Atomic symlink replacement
	ln -sfn "$DOTFILES_DIR/fonts" "$HOME/.local/share/fonts"
	fc-cache -fv
}

run_once() {
	local step_name="$1"
	local func_name="$2"
	local marker="$STATE_DIR/$step_name.done"

	if [[ -f "$marker" ]]; then
		echo "[SKIP] Step '$step_name' already completed."
		return 0
	fi

	echo "[RUN] Starting step: $step_name..."
	if "$func_name"; then
		touch "$marker"
		echo "[DONE] Step '$step_name' finished successfully."
	else
		echo "Error: Step '$step_name' failed!" >&2
		exit 1
	fi
}

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

start() {
	# This variable is only for the run-once function and nothing else
	STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles_install"
	mkdir -p "$STATE_DIR"

	echo "The installation state is stored in : $STATE_DIR"
	find "$DOTFILES_DIR" -type f -name "*.sh" -exec chmod +x {} \; #find . -type f -name "*.sh" -exec chmod +x {} \;

	run_once "install_packages" install_packages

	run_once "enable_services" enable_services

	run_once "install_AUR_packages" install_AUR_packages

	run_once "symlink_create" symlink_create

	run_once "install_font" install_font

	run_once "install_sounds" install_sounds

	run_once "set_dolphin_mime" set_dolphin_mime

	run_once "setup_xterm" setup_xterm

	run_once "setup_shell" setup_shell

	run_once "noctalia_v5_setup" noctalia_v5_setup

	rm "$STATE_DIR" -r
	echo "If not cleared then remove this dir as it stores the installation state"
	echo "The installation state is stored in : $STATE_DIR"

	chmod +x "$DOTFILES_DIR/scripts/ipconf"
	chmod +x "$DOTFILES_DIR/scripts/oye"

	echo "Look into notes to setup sddm and Grub themes..."
	echo "Reboot to see the Larping system... "
	exit 0
}

start
