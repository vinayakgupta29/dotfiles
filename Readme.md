# For Grub Theme

git clone https://github.com/vinayakgupta29/albedo-grub-theme.git

move it to `/boot/grub/themes`

in `/etc/default/grub` add 

GRUB_THEME=/boot/grub/themes/albedo-grub-theme/theme.txt

then

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

# For Windows Grub Entry

run the grub/setup.sh

after doing this Reboot the system