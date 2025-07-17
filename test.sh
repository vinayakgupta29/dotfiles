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
try
