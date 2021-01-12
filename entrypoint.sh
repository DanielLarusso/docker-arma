#!/bin/bash
mkdir -p "${STEAMAPPDIR}" || true

bash "${STEAMCMDDIR}/steamcmd.sh" +login ${STEAMACCUSER} ${STEAMACCPASSWORD} \
                                  +force_install_dir ${STEAMAPPDIR} \
                                  +app_update ${STEAMAPPID} validate \
                                  +quit

cd ${STEAMAPPDIR}

#bash "${STEAMAPPDIR}/arma3server" -port=2302, -config="./configs/server.cfg" -cfg="./configs/basic.cfg" -name="default" -world="empty"