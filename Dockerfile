###########################################################
# Dockerfile that builds a The Isle EVRIMA Gameserver
###########################################################
FROM cm2network/steamcmd:root as build_stage

LABEL maintainer="jays.gaming.contact@gmail.com"

ENV STEAMAPPID 412680
ENV STEAMAPP evrima
ENV STEAMAPPDIR "${HOMEDIR}/${STEAMAPP}-dedicated"
ENV SERVERPORT 2456
RUN echo $HOME

RUN set -x \
        && apt-get update \
        && mkdir -p "${STEAMAPPDIR}"

COPY etc/entry.sh "${HOMEDIR}/entry.sh"
COPY etc/tinyentry.sh "${HOMEDIR}/tinyentry.sh"
RUN chmod +x "${HOMEDIR}/entry.sh" "${HOMEDIR}/tinientry.sh" \
        && chown -R "${USER}:${USER}" "${HOMEDIR}/entry.sh" "${HOMEDIR}/tinientry.sh" "${STEAMAPPDIR}"

FROM build_stage AS steamcmd-base

ENV SERVER_PORT=${SERVERPORT} \
    SERVER_PUBLIC=1 \
	SERVER_WORLD_NAME="TheIsleEvrima-Jays" \
	SERVER_PW="${PASSWORD}" \
	SERVER_NAME="New \"${STEAMAPP}\" Server" \
	SERVER_LOG_PATH="logs_output/outputlog_server.txt" \
	SERVER_SAVE_DIR="Worlds" \
	SCREEN_QUALITY="Fastest" \
	SCREEN_WIDTH=640 \
	SCREEN_HEIGHT=480 \
	ADDITIONAL_ARGS="" \
	STEAMCMD_UPDATE_ARGS=""

USER ${USER}

WORKDIR ${HOMEDIR}

STOPSIGNAL SIGINT

ENTRYPOINT ["tini", "-g", "/home/steam/tinientry.sh"]

EXPOSE ${SERVERPORT}/tcp \
        ${SERVERPORT}/udp \
        ${SERVERPORT + 1}/udp

FROM steamcmd-base AS steamcmd-plus
