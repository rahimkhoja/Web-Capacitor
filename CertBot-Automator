#!/bin/sh
# Add New CertBot SSL Domain to NGINX-Certbot for Rahim's Semi-High Availability Web Capacitor
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
echo "---NGINX/Certbot Add new LetsEncrypt SSL Domain to NGINX Script---"
echo "---By: Rahim Khoja (rahim.khoja@alumni.ubc.ca)---"
echo "---For Rahim's Semi-High Availability Web Capacitor---"
echo
echo " Please note, this script has only been tested with users who are under 5 foot 8 inches in height!"
echo
# Default Variables
defaulthn="cookiethief.mech.ubc.ca"
defaultproxy="http://10.10.10.60:8080/"
lbserver1=172.18.254.232
lbserver2=172.18.254.233
lbserver3=172.18.254.234
lbserver4=172.18.254.235


# Check the bash shell script is being run by root
if [[ $EUID -ne 0 ]];
then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Move to Root Folder
cd /root

# Add new Certbot SSL domain Prompt
finish="-1"
adddomain="0"
while [ "$finish" = '-1' ]
do
    finish="1"
    echo
    read -p "Add new SSL domain to NGINX & Certbot [y/n]? " answer

    if [ "$answer" = '' ];
    then
        answer=""
    else
        case $answer in
            y | Y | yes | YES ) answer="y"; adddomain="1";;
            n | N | no | NO ) answer="n"; adddomain="0"; exit 1;;
            *) finish="-1";
                echo -n 'Invalid Response\n';
        esac
    fi
done

# Get SSL Domain Name
finish="-1"
while [ "$finish" = '-1' ]
do
    finish="1"
    echo
    read -p "Enter Domain to generate a SSL certificate for [$defaulthn]: " HOSTNAME
    HOSTNAME=${HOSTNAME:-$defaulthn}
    echo
    read -p "SSL Domain: $HOSTNAME [y/n]? " answer

    if [ "$answer" = '' ];
    then
        answer=""
    else
        case $answer in
            y | Y | yes | YES ) answer="y";;
            n | N | no | NO ) answer="n"; finish="-1"; exit 1;;
            *) finish="-1";
            echo -n 'Invalid Response\n';
        esac
    fi
done

# Get Proxy Site URL
finish="-1"
while [ "$finish" = '-1' ]
do
    finish="1"
    echo
    read -p "Enter destination proxy URL for $HOSTNAME SSL domain [$defaultproxy]: " PROXY
    PROXY=${PROXY:-$defaultproxy}
    echo
    read -p "Proxy URL: $PROXY [y/n]? " answer

    if [ "$answer" = '' ];
    then
        answer=""
    else
        case $answer in
            y | Y | yes | YES ) answer="y";;
            n | N | no | NO ) answer="n"; finish="-1"; exit 1;;
            *) finish="-1";
            echo -n 'Invalid Response\n';
        esac
    fi
done

# Create SSL Domain NGINX Virtual Host
cp /local/gluster_replica/etc/nginx/conf.d/nginx-confd-default /local/gluster_replica/etc/nginx/conf.d/$HOSTNAME.conf
sed -i "s/<domain>/$HOSTNAME/g" /local/gluster_replica/etc/nginx/conf.d/$HOSTNAME.conf
sed -i "s@<proxy>@$PROXY@g" /local/gluster_replica/etc/nginx/conf.d/$HOSTNAME.conf

# Create Site Root for SSL Domain
mkdir /local/gluster_replica/var/www/$HOSTNAME/
mkdir /local/gluster_replica/var/www/$HOSTNAME/.well-known

# Restart NGINX to enable http for cert generation
# service nginx reload - Thanks for the Advice Nathan
ssh root@$lbserver1 "service nginx reload"
ssh root@$lbserver2 "service nginx reload"
ssh root@$lbserver3 "service nginx reload"
ssh root@$lbserver4 "service nginx reload"

# Create Initial Lets Encrypt Cert for SSL Domain
certbot certonly --webroot -w /local/gluster_replica/var/www/$HOSTNAME -d $HOSTNAME -d www.$HOSTNAME

# Create Local Cert
openssl dhparam -out /local/gluster_replica/etc/letsencrypt/live/$HOSTNAME/dhparams.pem 2048

# Update Selinux and Permissions
chown -R nginx:nginx /local/gluster_replica/var/www

semanage fcontext -a -t httpd_sys_content_t /local/gluster_replica/var/www/$HOSTNAME/*
ssh root@172.18.254.232 "semanage fcontext -a -t httpd_sys_content_t /local/gluster_replica/var/www/$HOSTNAME/*"
ssh root@172.18.254.233 "semanage fcontext -a -t httpd_sys_content_t /local/gluster_replica/var/www/$HOSTNAME/*"
ssh root@172.18.254.234 "semanage fcontext -a -t httpd_sys_content_t /local/gluster_replica/var/www/$HOSTNAME/*"
ssh root@172.18.254.235 "semanage fcontext -a -t httpd_sys_content_t /local/gluster_replica/var/www/$HOSTNAME/*"


restorecon -R -v /local/gluster_replica/var/www
ssh root@172.18.254.232 "restorecon -R -v /local/gluster_replica/var/www"
ssh root@172.18.254.233 "restorecon -R -v /local/gluster_replica/var/www"
ssh root@172.18.254.234 "restorecon -R -v /local/gluster_replica/var/www"
ssh root@172.18.254.235 "restorecon -R -v /local/gluster_replica/var/www"

# certbot --dry-run renew

# Enable SSL in NGINX Virtual Host File
sed -i '/^#/ s/^#//' /local/gluster_replica/etc/nginx/conf.d/$HOSTNAME.conf

# Restart NGINX to enable SSL
# service nginx reload - Thanks for the Advice Nathan
ssh root@$lbserver1 "service nginx reload"
ssh root@$lbserver2 "service nginx reload"
ssh root@$lbserver3 "service nginx reload"
ssh root@$lbserver4 "service nginx reload"

echo
echo "If there are no errors above, the new SSL certificate is installed correctly."
echo
echo "After SSL redirection is enabled and tested, run the command to test SSL certificate renwals: certbot --dry-run renew"
