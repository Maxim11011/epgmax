#!/bin/bash
rm *.json
wget --no-check-certificate --no-cache --no-cookies --limit-rate=50k -i ch2.txt
wget -N --no-check-certificate --no-cache --no-cookies --limit-rate=50k -i ch2.txt
if [ -e channels.xml ]; then
	echo "File for channels exists, skeeping...";
else 
	echo "File for channels does not exist, creating...";
for f in ./*.json; do 
echo "Processing $f file for channel..."; 
jq -r -f channels.jq $f >> channels.xml
done
fi
 
if [ -e ./prog.xml ]; then
rm ./prog.xml
fi
for f in ./*.json; do 
echo "Processing $f file for programme..."; 
jq -r -f prog.jq $f | awk -f prog.awk >> prog.xml
done
echo '<?xml version="1.0" encoding="utf-8" ?>' > epg.xml
echo '<!DOCTYPE tv SYSTEM "xmltv.dtd">' >> epg.xml 
echo '<tv generator-info-name="Vladimir">' >> epg.xml
cat channels.xml >> epg.xml
cat prog.xml >> epg.xml
echo '</tv>' >> epg.xml

