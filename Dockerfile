# Dockerfile for AmrA 3 Dedicated Server

FROM cm2network/steamcmd:latest

LABEL maintainer="daniel.pogodda@googlemail.com"

ENV STEAMAPPID 233780
ENV STEAMAPP arma3server
ENV STEAMAPPDIR "${HOMEDIR}/${STEAMAPP}"
ENV ARMASERVERCONFIG ${ARMASERVERCONFIG:-server.cfg}
ENV ARMABASICCONFIG ${ARMABASICCONFIG:-basic.cfg}

RUN set -x \
    && mkdir -p "${STEAMAPPDIR}" \
    && { \
            echo '@ShutdownOnFailedCommand 1'; \
            echo '@NoPromptForPassword 1'; \
            echo 'login ${STEAMACCUSER} ${STEAMACCPASSWORD}'; \
            echo 'force_install_dir '"${STEAMAPPDIR}"''; \
            echo 'quit'; \
        } > "${HOMEDIR}/${STEAMAPP}_update.txt"

COPY entrypoint.sh ${HOMEDIR}/entrypoint.sh

RUN chmod -x "${HOMEDIR}/entrypoint.sh" \
    && chown -R "${USER}:${USER}" "${HOMEDIR}/entrypoint.sh" "${STEAMAPPDIR}" "${HOMEDIR}/${STEAMAPP}_update.txt" \
    && rm -rf /var/lib/apt/lists/*

USER ${USER}

VOLUME ${STEAMAPPDIR}

WORKDIR ${HOMEDIR}

CMD ["bash", "entrypoint.sh"]

EXPOSE 2302/udp \
        2303/udp \
        2304/udp \
        2305/udp \
        2306/udp
