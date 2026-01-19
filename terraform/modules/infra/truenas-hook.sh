#!/usr/bin/env bash

VMID=$1
PHASE=$2

if [ "$PHASE" == "pre-stop" ]; then
    echo "TrueNAS (VM $VMID) is stopping. Cleaning up NFS mounts to prevent host hang..."
    
    pvesm set shared-nfs-storage --disable 1
    
    umount -l /mnt/pve/shared-nfs-storage
    
elif [ "$PHASE" == "post-start" ]; then
    echo "TrueNAS (VM $VMID) started. Re-enabling storage..."
    
    (sleep 30 && pvesm set shared-nfs-storage --disable 0) &
fi

exit 0
