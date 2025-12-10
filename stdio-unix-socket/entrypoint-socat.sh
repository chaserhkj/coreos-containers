#!/usr/bin/env sh
# Use sh for compatibility

socat PTY,rawer,link=/tmp/service-pty EXEC:"${STDIO_BASE_CMD}" &
SRV_PID=$!

clean() {
    echo "[STDIO_UNIX] Shutting down service process..."
    kill $SRV_PID
    exit 0
}
trap "clean" EXIT

until [ -e /tmp/service-pty ]; do
    echo "[STDIO_UNIX] Waiting for pty to be created..."
    sleep 1
done

echo "[STDIO_UNIX] Forwarding connections from $UNIX_SOCKET_PATH to STDIO through pty, max-children=1 is set"
socat UNIX-LISTEN:${UNIX_SOCKET_PATH},unlink-early,fork,max-children=1 'FILE:/tmp/service-pty,rawer'