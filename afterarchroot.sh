echo murphy > /etc/hostname

echo LANG=en_US.UTF-8 > /etc/locale.conf

sed -i 's/#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen

locale-gen

ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

echo ""
echo "Set root password"
echo ""

passwd

echo ""
echo "Enter the username: "
echo ""

read USERNAME

useradd -m -G wheel ${USERNAME}

passwd ${USERNAME}

visudo

echo "127.0.0.1	${USERNAME}.localdomain	gabriel" >> /etc/hosts
echo "::1		localhost.localdomain	localhost" >> /etc/hosts

sed -i 's/HOOKS.*/HOOKS=(base keyboard udev autodetect modconf block keymap encrypt btrfs filesystems)/' /etc/mkinitcpio.conf

mkinitcpio -p linux-lts

bootctl --path=/boot install

touch /boot/loader/entries/arch.conf

# TODO: auto input of UUID-OF-ROOT-PARTITION

echo "title Arch Linux" > /boot/loader/entries/arch.conf
echo "linux /vmlinuz-linux" >> /boot/loader/entries/arch.conf
echo "initrd /amd-ucode.img" >> /boot/loader/entries/arch.conf
echo "initrd /initramfs-linux.img" >> /boot/loader/entries/arch.conf
echo "options cryptdevice=UUID=<UUID-OF-ROOT-PARTITION>:cryptroot:allow-discards root=/dev/mapper/cryptroot rootflags=subvol=@ rd.luks.options=discard rw" >> /boot/loader/entries/arch.conf

blkid >> /boot/loader/entries/arch.conf

nvim /boot/loader/entries/arch.conf

echo """
default  arch.conf
timeout  0
console-mode max
editor no
""" > /boot/loader/loader.conf

bootctl update

pacman -S terminus-font
echo "FONT=ter-v24n" > /etc/vconsole.conf

pacman -S archlinux-keyring --noconfirm

# Base packages
pacman -S sway wl-clipboard waybar xdg-desktop-portal-wlr xorg-xwayland swaylock pipewire pipewire-pulse pipewire-media-session pavucontrol snapper firefox alacritty tmux

systemctl enable NetworkManager
