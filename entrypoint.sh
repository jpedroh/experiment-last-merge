#!/bin/sh

# Retrieve host user and group IDs from environment variables or default to root
HOST_USER_ID=${HOST_USER_ID:-9001}
HOST_GROUP_ID=${HOST_GROUP_ID:-9001}

# Create a user and group with the same IDs as the host user
if ! grep -q "^mygroup:" /etc/group; then
    addgroup -g "$HOST_GROUP_ID" mygroup
fi
if ! grep -q "^myuser:" /etc/passwd; then
    adduser -D -u "$HOST_USER_ID" -G mygroup myuser
fi

# Change ownership of the mounted directory
chown -R myuser:mygroup /usr/src/app
chmod -R 775 /usr/src/app

# Switch to the new user and execute the container's main process
exec su-exec myuser "$@"
