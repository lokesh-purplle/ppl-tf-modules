#!/bin/bash
set -euxo pipefail

MOUNT_DIR=${MOUNT_DIR:-/var/opt}
REMOTE_FS=${REMOTE_FS:-/dev/disk/by-id/google-storage-disk}

if mount | awk '{if ($3 == "${MOUNT_DIR}") { exit 0}} ENDFILE{exit -1}'; then
  exit
else 
  sudo mkfs.ext4 -m 0 -F -E lazy_itable_init=0,lazy_journal_init=0,discard $REMOTE_FS; \
  sudo mkdir -p $MOUNT_DIR
  sudo mount -o discard,defaults $REMOTE_FS $MOUNT_DIR
  
  # Add fstab entry
  echo UUID=`sudo blkid -s UUID -o value $REMOTE_FS` $MOUNT_DIR ext4 discard,defaults,nofail 0 2 | sudo tee -a /etc/fstab
fi
