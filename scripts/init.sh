#!/bin/bash

# Get current user ID and group ID
PUID=$(id -u)
PGID=$(id -g)

# Detect system timezone, fallback to Europe/London if unknown
if [ -f /etc/timezone ]; then
  TZ=$(cat /etc/timezone)
elif [ -L /etc/localtime ]; then
  TZ=$(readlink /etc/localtime | sed 's|.*/zoneinfo/||')
else
  TZ="Europe/London"
fi

# Create media folders
mkdir -p ~/Videos/Movies
mkdir -p ~/Videos/Shows
mkdir -p ~/Videos/Downloads/complete/movies
mkdir -p ~/Videos/Downloads/complete/shows
mkdir -p ~/Videos/Downloads/incomplete

# Create .env file
cat <<EOF > .env
PUID=$PUID
PGID=$PGID
TZ=$TZ
EOF

echo ".env file created with:"
echo "PUID=$PUID"
echo "PGID=$PGID"
echo "TZ=$TZ"

