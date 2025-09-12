#!/usr/bin/env sh
# Use sh for compatibility

eval "${SD_SOCK_ACT_BASE_CMD}" &

SRV_PID=$!
clean() {
    echo "[SD_SOCK_ACT] Shutting down service process..."
    kill $SRV_PID
    exit 0
}
trap "clean" EXIT

tunnel_pids=""
sock_fd=3

for sock in $SD_SOCK_ACT_FWD_TARGETS; do

until socat /dev/null $sock >/dev/null 2>&1
do sleep ${SD_SOCK_ACT_POLL_INT};
echo "[SD_SOCK_ACT] Waiting for server on $sock to come up..."
done;

if [ ! -z $SD_SOCK_ACT_IDLE_TIMEOUT ]; then
    SD_SOCK_ACT_SOCAT_FLAG="$SD_SOCK_ACT_SOCAT_FLAG -T$SD_SOCK_ACT_IDLE_TIMEOUT" 
fi

echo "[SD_SOCK_ACT] Start to forward connections from passed socket /dev/fd/$sock_fd to $sock"
socat $SD_SOCK_ACT_SOCAT_FLAG ACCEPT-FD:$sock_fd,fork $sock &
tunnel_pids="$tunnel_pids $!"

sock_fd=$((sock_fd + 1))
done

wait $tunnel_pids