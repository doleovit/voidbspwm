#!/bin/bash
#
    clear

    bypass() {
        sudo -v
        while true; do
            sudo -n true
            sleep 45
            kill -0 "$$" \
            || exit
        done 2>/dev/null &
    }

    # beware
    if [[ "$PWD" =~ voidbspwm ]]; then
        printf "\033[5merror  \033[0mscript executed from: %s\n" "$PWD"
        exit
    fi

    # notice
    if lspci -k | grep -i -C 2 -E 'vga|3d' | grep -iq -w 'nvidia'; then
        printf "\033[5msorry  \033[0mthis setup does not support nvidia"
        exit
    fi

    printf "%s\n" \
    "this is a restrictive setup: line 43-49, 143-149, 231-233" \
    "- it is recommended to adapt these commands to your needs"

    read -p "continue anyway (y/n)? " answer
    case $answer in
        [Nn] ) exit ;;
        [Yy] )

    echo "enter your password"
    bypass

    echo "upgrade .."
    sudo xbps-install -Syu

    # ignorepkg
    echo "ignorepkg=linux-firmware-nvidia" | sudo tee /etc/xbps.d/70-ignore-linux-firmware-nvidia.conf >/dev/null
    echo "ignorepkg=adwaita-icon-theme" | sudo tee /etc/xbps.d/60-ignore-adwaita-icon-theme.conf >/dev/null
    echo "ignorepkg=btrfs-progs" | sudo tee /etc/xbps.d/50-ignore-btrfs-progs.conf >/dev/null
    echo "ignorepkg=pulseaudio" | sudo tee /etc/xbps.d/40-ignore-pulseaudio.conf >/dev/null
    echo "ignorepkg=polkit" | sudo tee /etc/xbps.d/30-ignore-polkit.conf >/dev/null
    echo "ignorepkg=avahi" | sudo tee /etc/xbps.d/20-ignore-avahi.conf >/dev/null
    echo "ignorepkg=dbus" | sudo tee /etc/xbps.d/10-ignore-dbus.conf >/dev/null

    # insurance
    if ls -U /etc/xbps.d | wc -l | xargs test 7 -eq; then
        sudo xbps-remove -R -y linux-firmware-nvidia btrfs-progs
    else
        printf "ignorepkg \033[5m  error\033[0m"; exit
    fi

    echo "installation .."
    sudo xbps-install -y void-repo-multilib-nonfree
    sudo xbps-install -y void-repo-multilib
    sudo xbps-install -y void-repo-nonfree

    sudo xbps-install -y xorg-minimal
    sudo xbps-install -y setxkbmap
    sudo xbps-install -y xsetroot
    sudo xbps-install -y xrandr
    sudo xbps-install -y xrdb
    sudo xbps-install -y xset

    sudo xbps-install -y dejavu-fonts-ttf

    sudo xbps-install -y mesa-vaapi
    sudo xbps-install -y mesa-vdpau
    sudo xbps-install -y mesa-dri

    sudo xbps-install -y alsa-utils
    sudo xbps-install -y ffmpeg

    sudo xbps-install -y rxvt-unicode
    sudo xbps-install -y polybar
    sudo xbps-install -y bspwm
    sudo xbps-install -y sxhkd
    sudo xbps-install -y picom
    sudo xbps-install -y feh

    sudo xbps-install -y fish-shell
    sudo xbps-install -y macchanger
    sudo xbps-install -y procps-ng
    sudo xbps-install -y neovim
    sudo xbps-install -y psmisc
    sudo xbps-install -y rsync
    sudo xbps-install -y light
    sudo xbps-install -y wget
    sudo xbps-install -y inxi
    sudo xbps-install -y pass
    sudo xbps-install -y nnn
    sudo xbps-install -y fzf

    sudo xbps-install -y oath-toolkit
    sudo xbps-install -y transmission
    sudo xbps-install -y xsecurelock
    sudo xbps-install -y newsboat
    sudo xbps-install -y firefox
    sudo xbps-install -y mupdf
    sudo xbps-install -y scrot
    sudo xbps-install -y mpv

    sudo xbps-install -y wireguard-tools

    # itacc
    if lspci -k | grep -i -C 2 -E 'vga|3d' | grep -iq -w 'intel'; then
        sudo xbps-install -y intel-video-accel
    fi

    # login
    sudo sed -i 's/noclear/& --skip-login --login-options='"$USER"'/' \
    /etc/sv/agetty-tty1/conf

    # services
    sudo rm -f /var/service/agetty-tty{3,4,5,6}
    sudo touch /etc/sv/agetty-tty{3,4,5,6}/down
    sudo touch /etc/sv/transmission-daemon/down
    sudo ln -s /etc/sv/acpid /var/service/
    sudo ln -s /etc/sv/uuidd /var/service/
    sudo ln -s /etc/sv/alsa /var/service/

    # nameservers
    sudo resolvconf -u

    # fontconfig
    sudo ln -s /usr/share/fontconfig/conf.avail/10-scale-bitmap-fonts.conf /etc/fonts/conf.d/
    sudo ln -s /usr/share/fontconfig/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d/
    sudo ln -s /usr/share/fontconfig/conf.avail/10-hinting-slight.conf /etc/fonts/conf.d/
    sudo ln -s /usr/share/fontconfig/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d/
    sudo ln -s /usr/share/fontconfig/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/
    sudo ln -s /usr/share/fontconfig/conf.avail/45-latin.conf /etc/fonts/conf.d/

    sudo xbps-reconfigure -f fontconfig

    # kernel
    cut -c5- <<EOF \
    | sudo tee /usr/lib/sysctl.d/30-user.conf >/dev/null
    kernel.yama.ptrace_scope=3
    kernel.panic_on_oops=30
    fs.protected_regular=1
    fs.protected_fifos=1
    kernel.sysrq=0
    kernel.panic=30
    vm.panic_on_oom=1
EOF

    cut -c5- <<EOF \
    | sudo tee /usr/lib/sysctl.d/20-net.conf >/dev/null
    net.ipv4.conf.all.accept_source_route=0
    net.ipv4.conf.default.accept_source_route=0
    net.ipv6.conf.all.accept_source_route=0
    net.ipv6.conf.default.accept_source_route=0
    net.ipv4.tcp_syncookies=1
    net.ipv4.tcp_rfc1337=1
    net.ipv4.conf.all.rp_filter=1
    net.ipv4.conf.default.rp_filter=1
    net.ipv4.conf.all.accept_redirects=0
    net.ipv4.conf.default.accept_redirects=0
    net.ipv4.conf.all.secure_redirects=0
    net.ipv4.conf.default.secure_redirects=0
    net.ipv6.conf.all.accept_redirects=0
    net.ipv6.conf.default.accept_redirects=0
    net.ipv4.conf.all.send_redirects=0
    net.ipv4.conf.default.send_redirects=0
    net.ipv4.icmp_echo_ignore_all=1
    net.ipv6.conf.all.accept_ra=0
    net.ipv6.conf.default.accept_ra=0
    net.ipv4.tcp_timestamps=0
    net.ipv4.conf.all.accept_source_route=0
    net.ipv6.conf.all.accept_source_route=0
    net.ipv4.conf.default.accept_source_route=0
    net.ipv6.conf.default.accept_source_route=0
EOF

    # lbat
    sudo mkdir -p /etc/sv/lowbat

    cut -c5- <<'EOF' \
    | sudo tee /etc/sv/lowbat/run >/dev/null
    #!/bin/sh
    exec 2>&1
    INTERVAL=300
    batt="$(dir -d /sys/class/power_supply/BAT*)"
    ac="$(cat /sys/class/power_supply/A*/online)"
    blevel="$(cat "$batt"/capacity)"
    sleep 300
    if test "$blevel" -ge 98; then
        exit
    fi
    if test "$blevel" -le 7 -a "$ac" -eq 0; then
        exec zzz
    fi
EOF

    sudo chmod +x /etc/sv/lowbat/run

    # misc
    sudo mkdir -p /etc/X11/xorg.conf.d

    cut -c5- <<EOF \
    | sudo tee /etc/X11/xorg.conf.d/10-mods.conf >/dev/null
    Section "Device"
    Identifier "GPU0"
    Driver "modesetting"
    EndSection
EOF

    cut -c5- <<EOF \
    | sudo tee /etc/X11/xorg.conf.d/20-dpms.conf >/dev/null
    Section "Extensions"
    Option "DPMS" "Disable"
    EndSection
EOF

    cut -c5- <<EOF | tr -d '\n' \
    | sudo tee /etc/sudoers.d/no-password-prompt >/dev/null
    $USER ALL=(ALL) NOPASSWD:
     /usr/bin/poweroff,
     /usr/bin/reboot,
     /usr/bin/zzz,
     /usr/bin/rfkill
EOF

    cut -c5- <<EOF \
    | sudo tee /etc/modprobe.d/disable.conf >/dev/null
    install uvcvideo /bin/true
    install bluetooth /bin/true
    install pcspkr /bin/true
EOF

    # conf
    sudo mkdir -p /etc/fish

    cat <<'EOF' \
    | sudo tee -a /etc/fish/config.fish >/dev/null
    if status is-login
        umask 077
    end

    if status is-login
        if test -z "$DISPLAY" -a (tty) = /dev/tty1
        exec startx
        end
    end
EOF

    # proc
    sudo groupadd pif
    sudo usermod -a -G pif "$USER" \
    && cut -c5- <<EOF \
    | sudo tee -a /etc/rc.local >/dev/null
    mount -o remount,nosuid,nodev,noexec,hidepid=invisible,gid=pif /proc
EOF

    # idv
    chty="$(grep -E '8|9|10|14' /sys/class/dmi/id/chassis_type)"

    # touch
    if test -n "$chty"; then
        cut -c9- <<EOF \
        | sudo tee /etc/X11/xorg.conf.d/90-touch.conf >/dev/null
        Section "InputClass"
        Identifier "touchpad"
        MatchIsTouchpad "on"
        Driver "libinput"
        Option "Tapping" "on"
        Option "TappingButtonMap" "lrm"
        Option "NaturalScrolling" "off"
        Option "ScrollMethod" "twofinger"
        EndSection
EOF
    fi

    # tlp
    if test -n "$chty"; then
        sudo xbps-install -y tlp \
        && echo "tlp init start" | sudo tee -a /etc/rc.local >/dev/null \
        && echo "tlp init stop" | sudo tee -a /etc/rc.shutdown >/dev/null

        cut -c9- <<EOF \
        | sudo tee -a /etc/tlp.d/*.conf >/dev/null
        TLP_DEFAULT_MODE=AC
        TLP_PERSISTENT_DEFAULT=1
EOF
    fi

    # μcode
    if grep -i 'vendor' /proc/cpuinfo | uniq | grep -i -q 'intel'; then
        sudo xbps-install -y intel-ucode >/dev/null \
        && uname -r | cut -d '.' -f 1,2 \
        | xargs -I{} sudo xbps-reconfigure -f linux{} >/dev/null 2>&1
    fi

    # grub
    lake="$(sudo ls -A -r -t /boot | grep 'config-' | tail -n1)"
    conf="$(sudo grep -i -E '^conf.*shuffle.*p.*alloc.*y' /boot/"$lake")"
    para="$(sudo grep -i -w 'y' /sys/module/page_alloc/parameters/shuffle)"

    if ! grep -w -q 'page_alloc.shuffle' /etc/default/grub; then
        if test -n "$conf" -a -z "$para"; then
            sudo sed -i 's/LINUX_DEFAULT="/&page_alloc.shuffle=1 /' \
            /etc/default/grub; sudo update-grub 2>/dev/null
        fi
    fi

    # poly
    batt="$(dir -d /sys/class/power_supply/BAT* | cut -d '/' -f 5)"
    adap="$(dir -d /sys/class/power_supply/A* | cut -d '/' -f 5)"
    intf="$(ip -o -4 route show to default | cut -d ' ' -f 5)"

    if test -n "$intf"; then
        sed -i "s/interface =/& $intf/" \
        voidbspwm/home/.config/polybar/config
    fi

    if test -n "$batt" -a -n "$adap"; then
        sed -i "35s/bspwm/& battery/;s/battery =/& $batt/;\
        s/adapter =/& $adap/" \
        voidbspwm/home/.config/polybar/config
    fi

    # sshl
    if ! grep -w '^PermitRootLogin no' /etc/ssh/sshd_config
    then
        echo "PermitRootLogin no" \
        | sudo tee -a /etc/ssh/sshd_config >/dev/null
    fi

    # lbse
    if test -n "$chty" -a -n "$batt" -a -n "$adap"; then
        sudo ln -s /etc/sv/lowbat /var/service/
    fi

    # vmpi
    if sudo dmesg | grep -i -E -q 'hyperv.*detect|qemu'; then
        sed -i '/^picom/d;/paper$/a xrandr -s 1920x1080' \
        voidbspwm/home/.config/bspwm/bspwmrc
    fi

    # rsuw
    if ! grep -Eq '.*wheel.*uid' /etc/pam.d/su /etc/pam.d/su-l
    then
        echo "auth required pam_wheel.so use_uid" \
        | sudo tee -a /etc/pam.d/su /etc/pam.d/su-l >/dev/null
    fi

    # perm
    sudo chmod u-s /usr/bin/{newuidmap,newgidmap} 2>/dev/null
    sudo chmod go-rwx /lib/modules /usr/lib/modules /usr/src
    sudo chmod u-s /usr/libexec/ssh-keysign 2>/dev/null
    sudo chmod g-s /usr/bin/{write,slock,wall} 2>/dev/null
    sudo setcap cap_setuid+ep /usr/bin/newuidmap 2>/dev/null
    sudo setcap cap_setgid+ep /usr/bin/newgidmap 2>/dev/null

    # shell
    sudo usermod -s /usr/bin/fish "$USER"

    cut -c5- <<'JFF' | fish
    set -U -x SXHKD_SHELL /usr/bin/sh
JFF

    # memo
    sudo chage -M 181 -m 0 -W 7 "$USER"

    # last
    shopt -s dotglob
    cp -r voidbspwm/home/* "$HOME"/

    printf "\033[5mdone  \033[0msudo reboot"
    ;;
esac
