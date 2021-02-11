#!/bin/bash

echo "**************************************************"
echo "**                                              **"
echo "**         DanielLarusso's Arma3Server          **"
echo "**                                              **"
echo "** https://github.com/DanielLarusso/docker-arma **"
echo "**                                              **"
echo "**************************************************"
echo ""

# make sure the arma 3 server directory exists
mkdir -p ${ARMA3SERVER_DIR} || true

# jump into the arma 3 server directory
cd ${ARMA3SERVER_DIR}

if ${ARMA3SERVER_UPDATE_ON_STARTUP}; then
  echo "Initialising Arma3Server update"
  echo ""
  # make sure the arma 3 server is up-to-date
  steamcmd \
      +login ${STEAM_ACCOUNT_USER} ${STEAM_ACCOUNT_PASSWORD} \
      +force_install_dir ${ARMA3SERVER_DIR} \
      +app_update ${ARMA3SERVER_APP_ID} validate \
      +quit

  echo ""
  echo "Finished Arma3Server update"
fi

echo ""
echo "Launching Arma3Server with port ${ARMA3SERVER_PORT}"
if [[ ${ARMA3SERVER_PARAMETER_MOD} ]]; then
  echo "Mods: ${ARMA3SERVER_PARAMETER_MOD}"
fi
echo ""

# start the arma 3 server
./${ARMA3SERVER_BINARY} \
    -port="2302" \
    -config="configs/server.cfg" \
    -cfg="configs/basic.cfg" \
    -name="default" \
    -world="empty" \
    -profiles="profiles" \
    -mod={${ARMA3SERVER_PARAMETER_MOD}} \
    -serverMod={${ARMA3SERVER_PARAMETER_SERVERMOD}} \
    -loadMissionToMemory

# start headless clients
if [[ 0 < ${ARMA3SERVER_HEADLESS_CLIENTS} ]]; then
  echo ""
  echo "Initialising ${ARMA3SERVER_HEADLESS_CLIENTS} headless clients"
  for i in {1..${ARMA3SERVER_HEADLESS_CLIENTS}}; do
    echo ""
    echo "Initialize headless client #${i}"
    ./${ARMA3SERVER_BINARY} \
    -client -connect=127.0.0.1
    -port="2302" \
    -config="configs/server.cfg" \
    -cfg="configs/basic.cfg" \
    -name="default" \
    -world="empty" \
    -profiles="profiles" \
    -mod={${ARMA3SERVER_PARAMETER_MOD}} \
    -password=${ARMA3SERVER_PASSWORD}
  done
  echo ""
  echo "Finished headless clients"
fi

echo ""
echo "Done"