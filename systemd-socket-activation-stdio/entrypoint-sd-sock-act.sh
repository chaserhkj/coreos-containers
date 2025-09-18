#!/usr/bin/env sh
# Use sh for compatibility

socat PTY,rawer,link=/tmp/service-pty EXEC:"${SD_SOCK_ACT_BASE_CMD}" &
SRV_PID=$!

clean() {
    echo "[SD_SOCK_ACT] Shutting down service process..."
    kill $SRV_PID
    exit 0
}
trap "clean" EXIT

if [ ! -z $SD_SOCK_ACT_IDLE_TIMEOUT ]; then
    SD_SOCK_ACT_SOCAT_FLAG="$SD_SOCK_ACT_SOCAT_FLAG -T$SD_SOCK_ACT_IDLE_TIMEOUT" 
fi

until [ -e /tmp/service-pty ]; do
    echo "[SD_SOCK_ACT] Waiting for pty to be created..."
    sleep 1
done

echo "[SD_SOCK_ACT] Start to forward connections from passed socket /dev/fd/3 to STDIO through pty, max-children=1 is set"
socat $SD_SOCK_ACT_SOCAT_FLAG ACCEPT-FD:3,fork,max-children=1 'FILE:/tmp/service-pty,rawer'