FROM cm2network/steamcmd

ENV STEAMAPPID ${STEAMAPPID:-233780}
ENV STEAMAPPDIR ${STEAMAPPDIR:-/home/steam/arma3server}
ENV ARMASERVERCONFIG ${ARMASERVERCONFIG:-server.cfg}
ENV ARMABASICCONFIG ${ARMABASICCONFIG:-basic.cfg}
ENV ARMABASICCONFIG ${ARMABASICCONFIG:-basic.cfg}

RUN ${STEAMCMDDIR}/steamcmd.sh +login anonymous +quit
RUN echo 233780 > ${STEAMCMDDIR}/steam_appid.txt

COPY entrypoint.sh ${STEAMAPPDIR}/entrypoint.sh

WORKDIR $STEAMAPPDIR

USER steam

ENTRYPOINT ["/home/steam/arma3server/entrypoint.sh"]

VOLUME $STEAMAPPDIR

CMD ["./arma3server", "-port=2302", "-config=./configs/server.cfg", "-cfg=./configs/basic.cfg", "-name=default", "-world=empty"]
