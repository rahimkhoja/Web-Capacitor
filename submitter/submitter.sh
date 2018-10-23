cat google-keywords.txt | \
while read CMD; do
    php submit.php http://$CMD.wesupportford.ca/sitemap.xml
    echo $CMD
done
