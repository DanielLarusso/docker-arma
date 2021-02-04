#!/bin/bash

# make sure the arma 3 server directory exists
mkdir -p ${ARMA3SERVER_DIR} || true

# jump into the arma 3 server directory
cd ${ARMA3SERVER_DIR}

# make sure the arma 3 server is up-to-date
steamcmd \
    +login ${STEAM_ACCOUNT_USER} ${STEAM_ACCOUNT_PASSWORD} \
    +force_install_dir ${ARMA3SERVER_DIR} \
    +app_update ${ARMA3SERVER_APP_ID} validate \
    +quit

# start the arma 3 server
./${ARMA3SERVER_BINARY} \
    -port="2302" \
    -config="configs/server.cfg" \
    -cfg="configs/basic.cfg" \
    -name="default" \
    -world="empty" \
    -profiles="profiles" \
    -mod={${ARMA3SERVER_PARAMETER_MOD}} \
    -serverMod={${ARMA3SERVER_PARAMETER_SERVERMOD}}