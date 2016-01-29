FROM base/archlinux

# Update package database
RUN pacman -Sy

# Update keyring
RUN pacman --noconfirm -S archlinux-keyring

# Update system
RUN pacman --noconfirm -Su

# Upgrade pacman database
RUN pacman-db-upgrade

# Install rr and deps
COPY rr.pkg.tar.xz /
RUN pacman --noconfirm -U /rr.pkg.tar.xz
RUN pacman --noconfirm -S gcc
