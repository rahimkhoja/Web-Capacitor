#!/bin/sh
# Domain/Subdomain Submitter
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
echo "---Domain & Subdomain submitter for Bing and Google---"
echo "---By: Rahim Khoja (rahim.khoja@alumni.ubc.ca)---"
echo
echo " Please note, this script has only been tested with users who are under 5 foot 8 inches in height!"
echo
echo " You must have a sitemap.xml file within your website for this submitter to work"
# Default Variables
domain=freevoid.org
subdomainlist=google-keywords.txt

# Get SSL Domain Name
finish="-1"
while [ "$finish" = '-1' ]
do
    finish="1"
    echo
    read -p "Enter Domain to submit to Google & Bing [$domain]: " HOSTNAME
    HOSTNAME=${HOSTNAME:-$domain}
    echo
    read -p "Domain: $HOSTNAME [y/n]? " answer

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



finish="-1"
while [ "$finish" = '-1' ]
do
    finish="1"
    echo
    read -p "Please enter subdomain list file [$subdomainlist]: " SUBLIST
    SUBLIST=${SUBLIST:-$subdomainlist}
    echo
    read -p "Domain: $SUBLIST [y/n]? " answer

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

cat $subdomainlist | \
while read CMD; do
    php submit.php http://$CMD.$HOSTNAME/sitemap.xml
    echo $CMD
done
