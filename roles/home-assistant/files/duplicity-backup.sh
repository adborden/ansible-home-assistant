#!/bin/bash

set -o errexit
set -o pipefail

lockfile=/var/lib/home-assistant/config/home-assistant_v2.db
archive=$(mktemp -d)/$(date +%Y%m%d-%H%M)-home-assistant.tar

# Pre-backup scripts, like archiving a live database
sqlite3 home-assistant_v2.db ".backup 'home-assistant_v2.db.backup'"

# Run duplicity

function cleanup () {
  rm -rf $archive
}

trap cleanup exit

set +e
flock --shared $lockfile tar -cf $archive --warning=no-file-changed -C / etc/letsencrypt var/lib/home-assistant
if [[ "$?" -gt 1 ]]; then  # tar exists 1 when files change
  exit 1
fi
set -e

# Compress + copy
xz --stdout --compress $archive | ssh -T home-assistant@gnubee-pc1 tee $(basename $archive).xz > /dev/null

# Cleanup old archives (90+ days)
ssh -T home-assistant@gnubee-pc1 sh -c 'ls -1 -r /home/home-assistant/*-home-assistant.tar.xz  | tail -n +2160'
