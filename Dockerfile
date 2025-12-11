FROM archlinux/archlinux:latest

RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
      # Download source code
      git \
      # Required by makepkg itself
      sudo fakeroot debugedit binutils \
      # Build mod_wsgi
      gcc make

RUN useradd -m -u 1001 -s /bin/zsh builder && \
    echo 'builder ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    mkdir /build && chown builder:builder /build && \
    mkdir /target && chown builder:builder /target

USER builder

WORKDIR /build

RUN git clone https://aur.archlinux.org/paru-bin.git && \
    cd paru-bin && \
    makepkg -si --noconfirm

RUN paru -Sy mod_wsgi pgadmin4-server --noconfirm

RUN git clone --branch dev https://github.com/lzx3in/aur-pgadmin4-web.git

RUN cd aur-pgadmin4-web && \
    makepkg -s --noconfirm

RUN mv /build/aur-pgadmin4-web/*.pkg.tar.zst /target/

ENTRYPOINT ["bash"]
