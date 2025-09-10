#!/usr/bin/env sh
# Use sh for compatibility

${SD_SOCK_ACT_BASE_CMD} &

SRV_PID=$!
clean() {
    echo "[SD_SOCK_ACT] Shutting down service process..."
    kill $SRV_PID
}
trap "clean" EXIT

until socat /dev/null ${SD_SOCK_ACT_FWD_PROTO}:${SD_SOCK_ACT_FWD_ADDR}:${SD_SOCK_ACT_FWD_PORT} >/dev/null 2>&1
do sleep ${SD_SOCK_ACT_POLL_INT};
echo "[SD_SOCK_ACT] Waiting for server to come up..."
done;

if [[ ! -z $SD_SOCK_ACT_IDLE_TIMEOUT ]]; then
    SD_SOCK_ACT_SOCAT_FLAG="$SD_SOCK_ACT_SOCAT_FLAG -T$SD_SOCK_ACT_IDLE_TIMEOUT" 
fi

echo "[SD_SOCK_ACT] Start to forward connections from passed socket /dev/fd/3"
socat $SD_SOCK_ACT_SOCAT_FLAG ACCEPT-FD:3,fork ${SD_SOCK_ACT_FWD_PROTO}:${SD_SOCK_ACT_FWD_ADDR}:${SD_SOCK_ACT_FWD_PORT}