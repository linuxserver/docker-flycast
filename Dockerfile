# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-selkies:debiantrixie

# set version label
ARG BUILD_DATE
ARG VERSION
ARG FLYCAST_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE=Flycast

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/flycast-logo.png && \
  echo "**** install packages ****" && \
  DOWNLOAD_URL=$(curl -sX GET "https://api.github.com/repos/flyinghead/flycast/releases/latest" \
    | awk -F '(": "|")' '/browser.*.AppImage/ {print $3}') && \
  curl -o \
    /tmp/fly.app -L \
    "${DOWNLOAD_URL}" && \
  cd /tmp && \
  chmod +x fly.app && \
  ./fly.app --appimage-extract && \
  mv \
    squashfs-root \
    /opt/flycast && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000

VOLUME /config
