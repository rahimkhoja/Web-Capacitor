#!/bin/bash
# GlusterFS Replica Deployment Script
# By Rahim Khoja (rahim@khoja.ca)

echo
echo -e "\033[0;31m░░░░░░░░▀▀▀██████▄▄▄"
echo "░░░░░░▄▄▄▄▄░░█████████▄ "
echo "░░░░░▀▀▀▀█████▌░▀▐▄░▀▐█ "
echo "░░░▀▀█████▄▄░▀██████▄██ "
echo "░░░▀▄▄▄▄▄░░▀▀█▄▀█════█▀"
echo "░░░░░░░░▀▀▀▄░░▀▀███░▀░░░░░░▄▄"
echo "░░░░░▄███▀▀██▄████████▄░▄▀▀▀██▌"
echo "░░░██▀▄▄▄██▀▄███▀▀▀▀████░░░░░▀█▄"
echo "▄▀▀▀▄██▄▀▀▌█████████████░░░░▌▄▄▀"
echo "▌░░░░▐▀████▐███████████▌"
echo "▀▄░░▄▀░░░▀▀██████████▀"
echo "░░▀▀░░░░░░▀▀█████████▀"
echo "░░░░░░░░▄▄██▀██████▀█"
echo "░░░░░░▄██▀░░░░░▀▀▀░░█"
echo "░░░░░▄█░░░░░░░░░░░░░▐▌"
echo "░▄▄▄▄█▌░░░░░░░░░░░░░░▀█▄▄▄▄▀▀▄"
echo -e "▌░░░░░▐░░░░░░░░░░░░░░░░▀▀▄▄▄▀\033[0m"
echo "---GlusterFS - CentOS 7.x GlusterFS Replica Deployment Script---"
echo "---By: Rahim Khoja (rahim@khoja.ca)---"
echo
echo " Please note, this script has only been tested with users who are under 5 foot 8 inches in height!"
echo

# Variables
glusterdevice=/dev/sdb

# Install GlusterFS 
yum -y install centos-release-gluster
yum -y install glusterfs gluster-cli glusterfs-libs glusterfs-server

# Create GlusterFS Volume
pvcreate $glusterdevice
vgcreate vg_gluster $glusterdevice
lvcreate -l 100%FREE -n brick1 vg_gluster
mkfs.xfs /dev/vg_gluster/brick1

# Start & Enable GlusterFS Server
service glusterd start
systemctl enable glusterd

# GlusterFS Server Firewall Rules
firewall-cmd --add-port=24009/tcp --permanent
firewall-cmd --add-port=24007-24008/tcp --permanent
firewall-cmd --add-port=49152-49251/tcp --permanent
firewall-cmd --reload


mkdir -p /local/gluster_volume
mount /dev/vg_gluster/brick1 /local/gluster_volume
echo "/dev/vg_gluster/brick1 /local/gluster_volume  xfs defaults  0 0" >> /etc/fstab
mount -a
mkdir /local/gluster_volume/data
# Only Run Next Lines From A Single Peer
#gluster volume create glustervol replica 5 transport tcp 172.18.254.231:/local/gluster_volume/data \ 172.18.254.232:/local/gluster_volume/data \ 172.18.254.233:/local/gluster_volume/data \ 172.18.254.234:/local/gluster_volume/data \ 172.18.254.235:/local/gluster_volume/data
#gluster volume start glustervol
#gluster volume info all



# Client Configuration
yum install glusterfs glusterfs-fuse attr -y
echo "localhost:/glustervol       /local/gluster_replica  glusterfs   defaults,_netdev  0  0" >> /etc/fstab
mount -a
