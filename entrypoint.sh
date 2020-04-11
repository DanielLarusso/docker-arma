#!/bin/bash

${STEAMCMDDIR}/steamcmd.sh +login ${STEAMACCUSER} ${STEAMACCPASSWORD} +force_install_dir ${STEAMAPPDIR} +app_update ${STEAMAPPID} validate +quit
