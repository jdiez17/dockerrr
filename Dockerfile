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

# Install vim and troll emacs users
RUN pacman --noconfirm -S vim-minimal
RUN ln -s /usr/bin/vim /bin/emacs

# Install rr and deps
RUN yes | pacman -S gcc-multilib cmake gdb git binutils python2-pexpect make pkg-config fakeroot
COPY rr.tar.gz /tmp
RUN chown nobody:nobody /tmp/rr.tar.gz
USER nobody
RUN cd /tmp && tar -xvzf /tmp/rr.tar.gz && cd /tmp/rr && makepkg
USER root
RUN pacman --noconfirm -U /tmp/rr/rr-4.0.3-3-x86_64.pkg.tar.xz

# Prepare the user that's going to execute rr 
RUN useradd run
RUN mkdir /home/run
RUN chown run:run /home/run

# Get the node, npm, and babel-cli 
RUN pacman --noconfirm -S nodejs npm 
RUN npm install --global babel-cli

# Install the terminal interface and its deps
USER run
WORKDIR /home/run
RUN git clone https://github.com/jdiez17/serverrr #state
RUN cd serverrr && npm install

EXPOSE 8081
ENTRYPOINT ["babel-node", "/home/run/serverrr/app.js"]
