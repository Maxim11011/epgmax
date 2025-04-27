#!/bin/bash
wget --no-check-certificate --header="Accept-encoding: gzip" -i ch2.txt

# Rename all .json files to .json.gz
for file in *.json; do
    if [ -f "$file" ]; then
        mv "$file" "${file%.json}.json.gz"
    fi
done

# Decompress all .json.gz files
for file in *.json.gz; do
    if [ -f "$file" ]; then
        gunzip -f "$file"
    fi
done

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
