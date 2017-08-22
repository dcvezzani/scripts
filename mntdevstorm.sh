#!/bin/bash
# mntdevstorm.sh

if [ -z "$1" ]; then
  echo "Usage: mntdevstorm.sh dvezzani@devstormdv0:/usr/local/storm/mod_storm"
  return
fi

if [ -z "$2" ]; then
  mntpoint='/Users/dcvezzani/.mnt/devstorm'
  echo "no mount point specified; using default: $mntpoint"
else
  mntpoint="$2"
fi

echo "Executing: sshfs -o allow_other,defer_permissions $1 $mntpoint"

sshfs -o allow_other,defer_permissions "$1" "$mntpoint"
cd "$mntpoint"
