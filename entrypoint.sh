#!/bin/sh

# Retrieve host user and group IDs from environment variables or default to root
HOST_USER_ID=${HOST_USER_ID:-9001}
HOST_GROUP_ID=${HOST_GROUP_ID:-9001}

# Create a user and group with the same IDs as the host user
if ! getent group mygroup >/dev/null 2>&1; then
    groupadd -g "$HOST_GROUP_ID" mygroup
fi
if ! id -u myuser >/dev/null 2>&1; then
    useradd -u "$HOST_USER_ID" -g mygroup -m myuser
fi

# Change ownership of the mounted directory
chown -R myuser:mygroup /usr/src/app
chmod -R 775 /usr/src/app

# Switch to the new user and execute the container's main process
exec su-exec myuser "$@"
