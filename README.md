# Dotfiles, Arch installation and customization

This repo contains the tracked dotfiles and keeps a list of packages and configuration steps for my personal Thinkpad x230 setup.

## Arch Installation

**(1) Change keyboard to slovene.**
```
# loadkeys slovene
```

**(2) Connect to wifi using `iwctl`.**
```
# iwctl
```

> **(2.1) Get list of \<DEVICES\>.**
> ```
> [iwd]# device list
> ```
> 
> **(2.2) Scan stations from the \<DEVICE\>.**
> ```
> [iwd]# station \<DEVICE\> scan
> ```
> 
> **(2.3) List networks from \<DEVICE\> to get \<SSID\>.**
> ```
> [iwd]# station \<DEVICE\> get-networks
> ```
> 
> **(2.4) Connect to \<SSID\>.**
> ```
> [iwd]# station \<DEVICE\> connect \<SSID\>
> ```

**(3) Set timezone and synchronize clock.**
```
# timedatectl set-timezone \<REGION\>/\<CITY\>
```

**(4) Synchronize with Network Time Protocol.**
```
# timedatectl set-ntp true
```

**(5) Partition disk.**

***Note:** These instructions are for UEFI systems.*

> Use `lsblk` to list all drives. Format the right one (usually `/dev/sda`) with `fdisk`.
> ```
> # fdisk /dev/sda
> ```
> 
> To make a new partitioning table.
> ```
> [fdisk]# g
> ```
> 
> To define a new partition.
> ```
> [fdisk]# n
> ```
> 
> To set the type of partition.
> ```
> [fdisk]# t
> ```
> 
> To write the partition table.
> ```
> [fdisk]# w
> ```

> An example (UEFI with GPT and a separate `/home` partition):
>
> mount point | partition   | partition type    | size
>-------------|-------------|-------------------|-------------------
> `/mnt/boot` | `/dev/sda1` | EFI `1`           | `+300M`
> [SWAP]      | `/dev/sda2` | Linux swap `19`   | `+16G`
> `/mnt`      | `/dev/sda3` | Linux x86-64 `23` | `+30G`
> `/mnt/home` | `/dev/sda4` | Linux x86-64 `23` | remainder of disk



**(6) Format the created partitions to correct filesystems.**

> **(6.1) Format the `boot` partition to fat32.**
> ```
> # mkfs.fat -F32 -n boot /dev/sda1
> ```
> 
> **(6.2) Make `swap`.**
> ```
> # mkswap -L swap /dev/sda2
> ```
> 
> **(6.3) Format the `home` and `root` partitions to ext4.**
> ```
> # mkfs.ext4 -L arch /dev/sda3
> ```
> ```
> # mkfs.ext4 -L home /dev/sda4
> ```

**(7) Mount partitions.**

***Note:** We use `/disk/by-label` since we formatted the partitions *(6)* with labels.*

> **(7.1) Mount the `root` partition to `/mnt`.**
> ```
> # mount /dev/disk/by-label/arch /mnt
> ```
>
> **(7.2) Make the necessary dirs to mount.**
> ```
> # mkdir /mnt/boot /mnt/home
> ```
>
> **(7.3) Mount the `boot` and `home` partitions.**
> ```
> # mount /dev/disk/by-label/boot /mnt/boot
> ```
> ```
> # mount /dev/disk/by-label/home /mnt/home
> ```
> 
> **(7.4) Turn on swap.**
> ```
> # swapon /dev/disk/by-label/swap
> ```

**(8) Install the base system.** 
```
# pacstrap /mnt base base-devel linux linux-headers linux-firmware intel-ucode
```

**(9) Generate fstab.**
```
# genfstab -U /mnt >> /mnt/etc/fstab
```

**(10) Chroot into system.**
```
# arch-chroot /mnt
```

**(11) Install a text editor.**
```
# pacman -S nano neovim
```

**(12) Set the timezone.**
```
# ln -sf /usr/share/zoneinfo/\<REGION\>/\<CITY\> /etc/localtime
```

**(13) Update hardware clock.**
```
# hwclock -w
```

**(14) Generate locales.**

> **(14.1) Open `locale.gen`.**
> ```
> # nano /etc/locale.gen
> ```
>
> **(14.2) Uncomment the necessary lines.**
> 
> **(14.3) Generate the uncommented locales.**
> ```
> # locale-gen
> ```

**(15) Set the locales.
```
# nano /etc/locale.conf
```

> An example of `locale.conf` contents:
> 
> ```
> LANG=en_US.UTF-8
> LC_TIME=sl_SI.UTF-8
> LC_PAPER=sl_SI.UTF-8
> ```

**(16) Set the default keymap in tty.**
```
# nano /etc/vconsole.conf
```

> An example of `vconsole.conf` contents:
> 
> ```
> KEYMAP=slovene
> ```

**(17) Set hostname.**
```
# echo \<HOSTNAME\> \>\> /etc/hostname
```

**(18) Edit the hosts file.
```
# nano /etc/hosts
```

> An example of `hosts` contents:
> 
> ```
> 127.0.0.1   localhost
> ::1         localhost
> 127.0.1.1   \<HOSTNAME\>.localdomain    \<HOSTNAME\>
> ```

**(19) Set root password.
```
# passwd
```

**(20) Add a regular user (and add them to the wheel group).**
```
# useradd -mG wheel \<USERNAME\>
```

**(21) Set user password.**
```
# passwd \<USERNAME\>
```

**(22) Edit sudo privileges.**
```
# EDITOR=nano visudo
```

> **(22.1) Uncomment line `%wheel ALL=(ALL) ALL` to allow members of wheel group to execute any command.**

**(23) Install the necessary networking packages (`iwd` and `dhcpcd`).**
```
# pacman -S iwd dhcpcd
```

**(24) Install bootloader packages.**
```
# pacman -S efibootmgr
```

**(25) Install bootloader (`systemd-boot`).**
```
# bootctl --path=/boot install
```
Make the necessary config files.  
```
# sudo nano /boot/loader/loader.conf
```
```
timeout 3
#console-mode keep
default arch-*
console-mode auto
```
```
# sudo nano /boot/loader/entries/arch.conf
```
```
title	Arch Linux
linux	/vmlinuz-linux-lts
initrd	/intel-ucode.img
initrd	/initramfs-linux-lts.img
options	root=/dev/sda3 rw resume=/dev/sda2
```
**Note:**  
Disks should be referenced with their UUID. It is easier to amend that in a usable desktop environment.

Exit chroot, unmount and reboot.
```
# exit
```
```
# umount -R /mnt
```
```
# reboot
```

## 3. Post-installation (logged in as user)

At this point the base Arch install is done. The rest of this document is personalization. Additional package installation is done while logged in as user.

**Note:**  
The `sudo` package should be installed (it is included in the `base-devel` package group).

Enable networking services.
```
$ sudo systemctl enable iwd.service
```
```
$ sudo systemctl start iwd.service
```
```
$ sudo systemctl enable dhcpcd.service
```
```
$ sudo systemctl start dhcpcd.service
```

Connect to wifi using `iwctl`.
```
$ iwctl
```
```
[iwd]$ station <DEVICE> connect <SSID>
```

```
$ sudo systemctl enable sshd.service
```
```
$ sudo systemctl start sshd.service
```

Install `git` for version control and installing the AUR helper. (isdep of paru)
```
$ sudo pacman -S git
```

Set-up configuration (dotfiles) tracking.  
a) Initial set-up  
Init a bare repository in the home folder.
```
$ git init --bare $HOME/.cfg
```
Define the alias in the current shell scope.
```
$ alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```
Set the flag `showUntrackedFiles` to `no` on this specific (local) repository.
```
$ config config --local status.showUntrackedFiles no
```
Save alias to `bash` config.
```
$ echo "alias config='/usr/bin/git --git-dir=$HOME/.config/.cfg/ --work-tree=$HOME'" >> $HOME/.bashrc
```
Now you can use `config status`, `config add`, `config commit` etc.  
b) Install existing dotfiles  
Make sure your source repo ignores the folder where you'll clone it.
```
$ echo ".cfg" >> $HOME/.gitignore
```
Clone your dotfiles into a bare repository.
```
git clone --bare <git-repo-url> $HOME/.cfg
```
Define the alias in the current shell scope.
```
$ alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```
Checkout the actual content from the bare repository to your folder.  
```
$ config checkout
```
**Note:**  
This step might fail. If so, backup and remove the conflicting files. Then run the command again.  
Set the flag `showUntrackedFiles` to `no` on this specific (local) repository.
```
$ config config --local status.showUntrackedFiles no
```

Enable AUR.  
Clone the `paru` aur helper.
```
$ git clone https://aur.archlinux.org/paru.git
```
Move to the cloned directory.
```
$ cd paru
```
Make package.
```
$ makepkg -si
```

**Todo:**  
I cant automount (or mount) my phone yet.

Utils
Update user directories.
```
$ xdg-user-dirs-update
```

Screen brightness and temperature
The user has to be in the `video` group (for light, screen brightness ...):
```
$ sudo gpasswd -a <USER> <GROUP>
```

```
$ sudo systemctl enable tlp.service
```
```
$ sudo systemctl start tlp.service
```
```
$ sudo nano /etc/tlp.conf
```
```
START_CHARGE_THRESH_BAT0=67
STOP_CHARGE_THRESH_BAT0=100
```

Fan control.
```
$ sudo nano /etc/thinkfan.conf
```
```
tp_fan /proc/acpi/ibm/fan
hwmon /sys/class/thermal/thermal_zone0/temp

(0, 0,  60)
(1, 53, 65)
(2, 55, 66)
(3, 57, 68)
(4, 61, 70)
(5, 64, 71)
(7, 68, 32767)
("level full-speed",	63,	32767)
```

Hibernation.
```
$ sudo nano /boot/loader/entries/arch.conf
```
Add `resume=UUID=<UUID>` to options (already documented during bootloader installation).

Add `resume` to `HOOKS` (after `udev`)
```
$ sudo nano /etc/mkinitcpio.conf
```
```
HOOKS=(base udev resume autodetect modconf block filesystems keyboard fsck)
```
```
$ sudo mkinitcpio -p linux
```

Kernel modules.  
Add the `i915` module to kernel.
```
$ sudo nano /etc/mkinitcpio.conf
```
```
MODULES=(i915)
```

Set-up enter hibernation on low battery.  
We are going to create a user systemd service for checking battery level and sending the hibernate command.

Create a script for checking battery level.
```
$ sudo nvim .config/scripts/low_bat
```
```bash
#!/bin/bash

capacity=`cat /sys/class/power_supply/BAT0/capacity`
status=`cat /sys/class/power_supply/BAT0/status`
THRESHOLD=7

if [[ "$status"=Discharging && $capacity -lt $THRESHOLD ]]
then
        notify-send -t 5000 -u critical -i battery-low "battery low" "hibernating" &
        sleep 5 &
        systemctl hibernate
fi
```
Make the file executable.
```
$ sudo chmod u+x /usr/local/bin/low_bat
```
To automate the check make a service file. (We make it in the local config path so not to mess with system-wide systemd and so that the user environment variables are inherited.)
```
$ nvim .config/systemd/user/low_bat.service
```
```
[Unit]
Description=check for low battery

[Service]
ExecStart=bash /usr/local/bin/low_bat

[Install]
WantedBy=multi-user.target
```
Also make a timer to define the checking intervals.
```
$ nvim .config/systemd/user/low_bat.timer
```
```
[Unit]
Description=timer to run check for low battery

[Timer]
OnUnitActiveSec=300
OnBootSec=300
AccuracySec=1min

[Install]
WantedBy=timers.target
```
Enable and start the timer.
```
$ systemctl --user enable low_bat.timer
```
```
$ systemctl --user start low_bat.timer
```


Enable and start `cups.service`.
```
$ sudo systemctl enable cups.service
```
```
$ sudo systemctl start cups.service
```

## Package list:

```
# base
base
linux
linux-firmware
linux-headers
intel-ucode
efibootmgr

# base-devel group
autoconf
automake
binutils
bison
fakeroot
file
findutils
flex
gawk
gcc
gettext
grep
groff
gzip
libtool
m4
make
pacman
patch
pkgconf
sed
sudo
texinfo
which

# networking
iwd
dhcpcd
openssh

# editor
nano
neovim

# git and wget
git
wget

# post chroot

# aur helper
paru

# terminal
xterm
termite

# X and video
xorg-server
xorg-xinit
xorg-xinput
vulkan-intel

# audio
pulseaudio
pulseaudio-alsa
pulseaudio-bluetooth
pamixer

# bluetooth
bluez
bluez-utils

# desktop
picom
openbox
tint2
rofi
dunst
nitrogen

# desktop utils
xdg-user-dirs
xclip
neofetch
htop
scrot
man-db
xsettingsd
light
redshift

# polkit
lxsession-gtk3

# FUSE
pcmanfm-gtk3
gvfs
xarchiver

# gvfs opdeps
gvfs-afc
gvfs-smb
gvfs-gphoto2
gvfs-mtp
gvfs-nfs

# xarchiver opdeps
arj
binutils
bzip2
cpio
gzip
lhasa
lrzip
lz4
lzip
lzop
p7zip
tar
unarj
unrar
unzip
xdg-utils
xz
zip
zstd

# additional FUSE
sshfs
ntfs-3g

# printing
cups
foomatic-db-engine
foomatic-db
foomatic-db-nonfree
gutenprint
foomatic-db-gutenprint-ppds

# printing (foreign)
cups-xerox-b2xx

# scanning
sane
sane-airscan
scantailor-advanced
calibre
rsync

# scanning (foreign)
ocrmypdf

# tessdata
tesseract
tesseract-data-eng
tesseract-data-slv
tesseract-data-ita

# IDE
atom

# browsing and internet
firefox
thunderbird
transmission-gtk

# media
vlc
viewnior
gimp
inkscape
scribus
kdenlive
audacity

# academia
pandoc
texlive-core

# office
libreoffice-fresh-sl

# laptop
acpi
acpi_call
tlp

# laptop (foreign)
thinkfan
bcm20702a1-firmware

# theming
gnome-themes-extra
gtk-engines
gtk-engine-murrine

# theming (foreign)
adwaita-qt
numix-icon-theme-pack-git

# fonts
ttf-dejavu
ttf-liberation

# fonts (foreign)
ttf-ms-fonts
```
