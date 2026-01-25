#!/bin/bash

set -e

IP="127.0.0.1"

HOSTS_FILE="/etc/hosts"

check_and_add() {
  local domain=$1
  if ! grep -qE "^\s*$IP\s+$domain\s*$" "$HOSTS_FILE"; then
    echo "Adding $domain to $HOSTS_FILE"
    echo -e "$IP\t$domain" | sudo tee -a "$HOSTS_FILE" > /dev/null
  else
    echo "$domain already exists in $HOSTS_FILE"
  fi
}

check_and_add "media.local"
check_and_add "search.media.local"

