#!/bin/sh

gsutil mb gs://$DEVSHELL_PROJECT_ID-bucket

gcloud compute instances create my-instance \
    --zone $ZONE \
    --machine-type e2-medium \
    --boot-disk-size 10GB \
    --boot-disk-type pd-balanced \
    --tags http-server

gcloud compute disks create mydisk --size=200GB \
--zone $ZONE

gcloud compute instances attach-disk my-instance --disk mydisk --zone $ZONE

gcloud compute ssh my-instance --zone $ZONE

ls -l /dev/disk/by-id/

sudo mkdir /mnt/mydisk

sudo mkfs.ext4 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/disk/by-id/scsi-0Google_PersistentDisk_persistent-disk-1

sudo mount -o discard,defaults /dev/disk/by-id/scsi-0Google_PersistentDisk_persistent-disk-1 /mnt/mydisk

sudo nano /etc/fstab

/dev/disk/by-id/scsi-0Google_PersistentDisk_persistent-disk-1 /mnt/mydisk ext4 defaults 1 1

# 1. Update the package lists:
sudo apt update

# 2. Install NGINX:
sudo apt install nginx -y

# 3. Check the status of NGINX:
sudo systemctl status nginx