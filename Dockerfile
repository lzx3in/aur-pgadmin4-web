FROM archlinux/archlinux:latest

RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
      # Download source code
      git \
      # Required by makepkg itself
      sudo fakeroot debugedit binutils \
      # Download pgadmin4-server package
      wget

RUN wget https://github.com/lzx3in/aur-pgadmin4-server/releases/download/dev/pgadmin4-server-9.8-2-x86_64.pkg.tar.zst && \
    pacman -U pgadmin4-server-9.8-2-x86_64.pkg.tar.zst --noconfirm

RUN useradd -m -u 1001 -s /bin/zsh builder && \
    echo 'builder ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    mkdir /build && chown builder:builder /build && \
    mkdir /target && chown builder:builder /target

USER builder

WORKDIR /build

RUN git clone --branch dev https://github.com/lzx3in/aur-pgadmin4-web.git

RUN cd aur-pgadmin4-web && \
    makepkg -s --noconfirm

RUN mv /build/aur-pgadmin4-web/*.pkg.tar.zst /target/

ENTRYPOINT ["bash"]
