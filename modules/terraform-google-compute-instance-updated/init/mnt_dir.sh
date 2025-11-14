#!/bin/bash
set -euxo pipefail

# Fetch metadata from GCP
MOUNT_DIR=$(curl -s "http://metadata.google.internal/computeMetadata/v1/instance/attributes/MOUNT_DIR" -H "Metadata-Flavor: Google" || echo "/data")
REMOTE_FS=$(curl -s "http://metadata.google.internal/computeMetadata/v1/instance/attributes/REMOTE_FS" -H "Metadata-Flavor: Google" || echo "/dev/sdb")

if mount | grep -q " $MOUNT_DIR "; then
  echo "Already mounted at $MOUNT_DIR"
  exit 0
fi

sudo mkfs.ext4 -m 0 -F -E lazy_itable_init=0,lazy_journal_init=0,discard $REMOTE_FS
sudo mkdir -p $MOUNT_DIR
sudo mount -o discard,defaults $REMOTE_FS $MOUNT_DIR

# Add fstab entry
echo UUID=$(sudo blkid -s UUID -o value $REMOTE_FS) $MOUNT_DIR ext4 discard,defaults,nofail 0 2 | sudo tee -a /etc/fstab