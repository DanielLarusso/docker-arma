FROM ubuntu:18.04

ARG PUID=1000

# ubuntu user data
ENV STEAM_USER steam
ENV STEAM_DIR /home/${STEAM_USER}

# arma 3 server data
ENV ARMA3SERVER_NAME arma3server
ENV ARMA3SERVER_DIR ${STEAM_DIR}/${ARMA3SERVER_NAME}
ENV ARMA3SERVER_APP_ID 233780
ENV ARMA3SERVER_BINARY arma3server_x64

ENV ARMA3SERVER_PARAMETER_MOD ${ARMA3SERVER_PARAMETER_MOD}
ENV ARMA3SERVER_PARAMETER_SERVERMOD ${ARMA3SERVER_PARAMETER_SERVERMOD}

# steam account user data
ENV STEAM_ACCOUNT_USER ${STEAM_ACCOUNT_USER:-anonymous}
ENV STEAM_ACCOUNT_PASSWORD ${STEAM_ACCOUNT_PASSWORD:-}

# add the new ubuntu user to run the server with
RUN useradd -u "${PUID}" -m "${STEAM_USER}"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN echo steam steam/question select "I AGREE" | debconf-set-selections \
 && echo steam steam/license note '' | debconf-set-selections

ARG DEBIAN_FRONTEND=noninteractive
RUN dpkg --add-architecture i386 \
 && apt-get update \
 && apt-get install -y --no-install-recommends --no-install-suggests \
    ca-certificates \
    steamcmd \
 && apt-get clean autoclean \
 && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/* \
 && ln -s /usr/games/steamcmd /usr/bin/steamcmd \
 && su ${STEAM_USER} -c "steamcmd +quit"

USER ${STEAM_USER}

RUN mkdir -p ${ARMA3SERVER_DIR} \
 && steamcmd \
    +login ${STEAM_ACCOUNT_USER} ${STEAM_ACCOUNT_PASSWORD} \
    +force_install_dir ${ARMA3SERVER_DIR} \
    +app_update ${ARMA3SERVER_APP_ID} validate \
    +quit

WORKDIR ${ARMA3SERVER_DIR}

EXPOSE 2302/udp 2303/udp 2304/udp 2305/udp 2306/udp

ENTRYPOINT ["/bin/bash", "-c", "${ARMA3SERVER_DIR}/${ARMA3SERVER_BINARY} -name=default -profile=default -world=empty"]

#sed -c -i "s/\($TARGET_KEY *= *\).*/\1$REPLACEMENT_VALUE/" $CONFIG_FILE