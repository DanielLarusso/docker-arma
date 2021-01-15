FROM ubuntu:18.04

# ubuntu user data
ARG PUID=1000
ARG STEAM_USER=steam
ARG STEAM_DIR=/home/${STEAM_USER}

# arma 3 server data
ARG ARMA3SERVER_NAME=arma3server
ARG ARMA3SERVER_DIR=${STEAM_DIR}/${ARMA3SERVER_NAME}
ARG ARMA3SERVER_APP_ID=233780
ARG ARMA3SERVER_BINARY=arma3server_x64

# steam account user data
ARG STEAM_ACCOUNT_USER=${STEAM_ACCOUNT_USER}
ARG STEAM_ACCOUNT_PASSWORD=${STEAM_ACCOUNT_PASSWORD}

# add the new ubuntu user to run the server with
RUN useradd -u "${PUID}" -m "${STEAM_USER}"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN echo steam steam/question select "I AGREE" | debconf-set-selections \
 && echo steam steam/license note '' | debconf-set-selections

ARG DEBIAN_FRONTEND=noninteractive
RUN dpkg --add-architecture i386 \
 && apt-get update \
 && apt-get install -y --no-install-recommends --no-install-suggests \
    ibsdl2-2.0-0:i386 \
    ca-certificates \
    steamcmd \
 && apt-get clean autoclean \
 && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/* \
 && ln -s /usr/games/steamcmd /usr/bin/steamcmd

USER ${PUID}

RUN mkdir -p ${ARMA3SERVER_DIR} \
 && steamcmd \
    +login ${STEAM_ACCOUNT_USER} ${STEAM_ACCOUNT_PASSWORD} \
    +force_install_dir ${ARMA3SERVER_DIR} \
    +app_update ${ARMA3SERVER_APP_ID} validate \
    +quit

COPY --chown=${PUID}:${PUID} entrypoint.sh ${ARMA3SERVER_DIR}/entrypoint.sh

RUN chmod +x ${ARMA3SERVER_DIR}/entrypoint.sh

WORKDIR ${ARMA3SERVER_DIR}

EXPOSE 2302/udp 2303/udp 2304/udp 2305/udp 2306/udp

ENV ARMA3SERVER_DIR=${ARMA3SERVER_DIR} \
    ARMA3SERVER_APP_ID=${ARMA3SERVER_APP_ID} \
    ARMA3SERVER_BINARY=${ARMA3SERVER_BINARY}

ENTRYPOINT ["./entrypoint.sh"]