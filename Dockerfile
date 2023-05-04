###########################################################
# Dockerfile that builds a The Isle EVRIMA Gameserver
###########################################################
FROM cm2network/steamcmd:root as build_stage

LABEL maintainer="jays.gaming.contact@gmail.com"

ENV STEAMAPPID 412680
ENV STEAMAPP evrima
ENV STEAMAPPDIR "${HOMEDIR}/${STEAMAPP}-dedicated"
ENV DLURL https://raw.githubusercontent.com/hermesdj/evrima-server

RUN set -x \
        && apt-get update \
        && apt-get install -y --no-install-recommends --no-install-suggests \
        		wget=1.21-1+deb11u1 \
        		ca-certificates=20210119 \
        		lib32z1=1:1.2.11.dfsg-2+deb11u2 \
        		tini=0.19.0-1 \
        		libc6-dev=2.31-13+deb11u6 \
        		file=1:5.39-3 \
        && mkdir -p "${STEAMAPPDIR}" \
        && wget --max-redirect=30 "${DLURL}/dev/etc/entry.sh" -O "${HOMEDIR}/entry.sh" \
        && wget --max-redirect=30 "${DLURL}/dev/etc/tinientry.sh" -O "${HOMEDIR}/tinientry.sh" \
        && chmod +x "${HOMEDIR}/entry.sh" "${HOMEDIR}/tinientry.sh" \
        && chown -R "${USER}:${USER}" "${HOMEDIR}/entry.sh" "${HOMEDIR}/tinientry.sh" "${STEAMAPPDIR}" \
        # Clean up
        && rm -rf /var/lib/apt/lists/*

FROM build_stage AS steamcmd-base

ENV SERVER_PORT=2456 \
    SERVER_PUBLIC=1 \
	SERVER_WORLD_NAME="TheIsleEvrima-Test" \
	SERVER_PW="${PASSWORD}" \
	SERVER_NAME="New \"${STEAMAPP}\" Server" \
	SERVER_LOG_PATH="logs_output/outputlog_server.txt" \
	SERVER_SAVE_DIR="Isles" \
	SCREEN_QUALITY="Fastest" \
	SCREEN_WIDTH=640 \
	SCREEN_HEIGHT=480 \
	ADDITIONAL_ARGS="" \
	STEAMCMD_UPDATE_ARGS=""

USER ${USER}

WORKDIR ${HOMEDIR}

STOPSIGNAL SIGINT

ENTRYPOINT ["tini", "-g", "/home/steam/tinientry.sh"]

EXPOSE 2456/tcp \
       2456/udp \
       2457/udp

FROM steamcmd-base AS steamcmd-plus
