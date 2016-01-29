FROM base/archlinux

# Copy pacman.conf with multilib enabled
COPY pacman.conf /etc/pacman.conf

# Update package database
RUN pacman -Sy

# Update keyring
RUN pacman --noconfirm -S archlinux-keyring

# Update system
RUN pacman --noconfirm -Su

# Upgrade pacman database
RUN pacman-db-upgrade

# Install rr and deps
RUN yes | pacman -S gcc-multilib cmake gdb git binutils python2-pexpect make pkg-config fakeroot
COPY rr.tar.gz /tmp
RUN chown nobody:nobody /tmp/rr.tar.gz
USER nobody
RUN cd /tmp && tar -xvzf /tmp/rr.tar.gz && cd /tmp/rr && makepkg
USER root
RUN pacman --noconfirm -U /tmp/rr/rr-4.0.3-3-x86_64.pkg.tar.xz
