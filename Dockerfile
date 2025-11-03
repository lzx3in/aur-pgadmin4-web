FROM archlinux/archlinux:latest

RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
      # Download source code
      git \
      # Required by makepkg itself
      sudo fakeroot debugedit binutils \
      # Download pgadmin4-server package
      wget jq \
      # Build mod_wsgi
      gcc make

RUN RELEASE_INFO=$(curl -s https://api.github.com/repos/lzx3in/aur-pgadmin4/releases/tags/dev) && \
    TARGET_URL=$(echo ${RELEASE_INFO} | jq -r '.assets[].browser_download_url' | grep pgadmin4-server | grep -v debug) && \
    wget ${TARGET_URL} && \
    pacman -U $(basename ${TARGET_URL}) --noconfirm

RUN useradd -m -u 1001 -s /bin/zsh builder && \
    echo 'builder ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    mkdir /build && chown builder:builder /build && \
    mkdir /target && chown builder:builder /target

USER builder

WORKDIR /build

RUN git clone https://aur.archlinux.org/mod_wsgi.git && \
    cd mod_wsgi && \
    makepkg -si --noconfirm

RUN git clone --branch dev https://github.com/lzx3in/aur-pgadmin4-web.git

RUN cd aur-pgadmin4-web && \
    makepkg -s --noconfirm

RUN mv /build/aur-pgadmin4-web/*.pkg.tar.zst /target/

ENTRYPOINT ["bash"]
