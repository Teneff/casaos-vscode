FROM ghcr.io/linuxserver/baseimage-ubuntu:jammy

RUN apt-get update \
    && apt-get install -y locales wget gpg apt-transport-https \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"
ENV HOME="/config/projects"
ENV LANG="en_US.utf8"
ENV APP_HOST="0.0.0.0"
ENV APP_PORT="8000"
ENV CONNECTION_TOKEN="tkn"

RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg \
    && install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg \
    && sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/projects.list' \
    && rm -f packages.microsoft.gpg

RUN apt-get update \
    && apt-get install -y \
        git \
        jq \
        libatomic1 \
        nano \
        net-tools \
        netcat \
        sudo \
        code \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash \
    && apt-get clean \
    && rm -rf \
        /config/* \
        /tmp/* \
        /var/lib/apt/lists/* \
        /etc/apt/sources.list.d/projects.list \
        /var/tmp/*

COPY /root /

##############################################
### Run with non-root
# RUN mkdir /projects \
#     && chown -R daemon:daemon /projects

# RUN usermod -d /projects daemon
# USER daemon
