#!/bin/bash

# make sure the arma 3 server directory exists
mkdir -p ${ENV_ARMA3SERVER_DIR} || true

# jump into the arma 3 server directory
cd ${ENV_ARMA3SERVER_DIR}

# make sure the arma 3 server is up-to-date
steamcmd \
    +login ${ENV_STEAM_ACCOUNT_USER} ${ENV_STEAM_ACCOUNT_PASSWORD} \
    +force_install_dir ${ENV_ARMA3SERVER_DIR} \
    +app_update ${ENV_ARMA3SERVER_APP_ID} validate \
    +quit

# start the arma 3 server
./${ENV_ARMA3SERVER_BINARY} \
    -port="2302" \
    -config="configs/server.cfg" \
    -cfg="configs/basic.cfg" \
    -name="default" \
    -world="empty" \
    -profiles="profiles" \
    -mod={${ENV_ARMA3SERVER_PARAMETER_MOD}} \
    -serverMod={${ENV_ARMA3SERVER_PARAMETER_SERVERMOD}} \
    -loadMissionToMemory