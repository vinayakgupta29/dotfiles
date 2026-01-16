#!/bin/bash

set -e
install_yay() {
    git clone https://aur.archlinux.org/yay.git
    pushd yay || return 
    makepkg -si
    popd || return
}

install_packages() {
    sudo pacman -S $(<packagelist)
}

set_dolphin_mime() {
    curl --create-dirs -L https://raw.githubusercontent.com/KDE/plasma-workspace/master/menu/desktop/plasma-applications.menu -o "$HOME/.config/menus/applications.menu"
    kbuildsycoca6;
}
install_sounds() {
    DEST_DIR="$HOME/.local/sounds"
    rm -rf "$DEST_DIR"
    mkdir -p "$DEST_DIR"
    ln -s $(pwd)/sounds/custom "$DEST_DIR"

    echo "Moved the sounds to $DEST_DIR"
}
setup_xterm(){
  ln -s $(pwd)/.Xresources ~/.Xresources
  xrdb -merge ~/.Xresources
}

setup_shell(){
  ln -s $(pwd)/.bash_profile ~/.bash_profile
  ln -s $(pwd)/.bashrc ~/.bashrc
  ln -s $(pwd)/.gvimrc   ~/.gvimrc
  ln -s $(pwd)/.gtkrc-2.0  ~/.gtkrc-2.0

}

enable_services() {
    enable_and_start_service NetworkManager

    enable_and_start_service iwd

    enable_and_start_service avahi-daemon

    enable_and_start_service firewalld

    enable_and_start_service bluetooth

    enable_and_start_service polkit

    enable_and_start_service docker

    if [ -n "${SUDO_USER:-}" ]&& [ "$SUDO_USER" != "root"]; then
	    runuser -l "$SUDO_USER" -C \
		    "
    systemctl --user daemon-reload 

    systemctl --global enable --now pipewire.socket wirepulmber.service"
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

    yay -S $(<aur_pkg_list)
}



symlink_create() {
    mkdir -p "$HOME/.config"

    create_symlink() {
        local app="$1"
        local src_dir
        src_dir="$(pwd)/.config/$app"
        local dest_dir="$HOME/.config/$app"

        if pacman -Qq "$app" &>/dev/null; then
            [ -e "$dest_dir" ] && rm -rf "$dest_dir"
            ln -s "$src_dir" "$dest_dir"
        else
            echo "$app is not installed"
        fi
    }

    # Create symlinks
    create_symlink hyprland
    create_symlink waybar
    create_symlink ranger
    create_symlink rofi
    create_symlink mako
    create_symlink kitty
    create_symlink fastfetch
    create_symlink nvim

    # Make .sh files executable in each relevant config directory
    if pacman -Qq hyprland &>/dev/null; then
        find "$(pwd)/.config/hypr" -type f -name "*.sh" -exec chmod +x {} +
    fi

    if pacman -Qq waybar &>/dev/null; then
        find "$(pwd)/.config/waybar" -type f -name "*.sh" -exec chmod +x {} +
    fi

    if pacman -Qq ranger &>/dev/null; then
        find "$(pwd)/.config/ranger" -type f -name "*.sh" -exec chmod +x {} +
    fi

   
    echo "Created all symlinks and set scripts executable"
}
install_font() {
    mkdir $HOME/.local/share/fonts/
    ln -s $(pwd)/fonts $HOME/.local/share/fonts
    fc-cache -fv

}

find $(pwd) -type f -name "*.sh" -exec chmod +x {} \; #find . -type f -name "*.sh" -exec chmod +x {} \;

install_packages

enable_services

install_AUR_packages

symlink_create

install_font

install_sounds

set_dolphin_mime

setup_xterm

setup_shell

chmod +x "$(pwd)/scripts/ipconf"
chmod +x "$(pwd)/scripts/oye"

echo "Look into notes to setup sddm and Grub themes..."
exit 0
