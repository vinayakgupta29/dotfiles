try(){
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
create_symlink fish

