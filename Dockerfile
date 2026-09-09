FROM ghcr.io/pgaskin/nickeltc:1.0

USER root

RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
    sed -i 's/security.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
    sed -i '/buster-updates/d' /etc/apt/sources.list && \
    dpkg --add-architecture armhf && \
    apt-get -o Acquire::Check-Valid-Until=false update && \
    apt-get install -y --no-install-recommends \
        g++-arm-linux-gnueabihf \
        qtbase5-dev:armhf \
        libqt5widgets5:armhf && \
    rm -rf /var/lib/apt/lists/*
