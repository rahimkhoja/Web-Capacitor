cat maxkey.txt | \
while read CMD; do
    php sitemap.php http://$CMD.wesupportford.ca/sitemap.xml
    echo $CMD
done
