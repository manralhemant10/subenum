##!/bin/bash

mkdir ~/Desktop/recondata/$1

echo ""
echo ""
echo "RUNNING AMASS"
echo ""
echo ""

#running amass
amass enum -d $1 -o ~/Desktop/recondata/$1/domains.txt

echo ""
echo ""
echo "count of domains.txt after amass"
cat ~/Desktop/recondata/$1/domains.txt | wc -l

echo ""
echo ""
echo "RUNNING SUBLISTER"
echo ""
echo ""

#starting sublist3r
python ~/tools/Sublist3r/sublist3r.py -d $1 -v -o ~/Desktop/recondata/$1/sublister.txt

#moving data to domains.txt
cat ~/Desktop/recondata/$1/sublister.txt >> ~/Desktop/recondata/$1/domains.txt

echo ""
echo ""
echo "count of domains.txt after sublister"
cat ~/Desktop/recondata/$1/domains.txt | wc -l

echo ""
echo ""
echo "RUNNING ASSETFINDER"
echo ""
echo ""

#running assetfinder
~/go/bin/assetfinder --subs-only $1 | tee -a ~/Desktop/recondata/$1/domains.txt

echo ""
echo ""
echo "count of domains.txt after assetfinder"
cat ~/Desktop/recondata/$1/domains.txt |wc -l

echo ""
echo ""
echo "GETTING ROOT DOMAINS"
echo ""
echo ""
#getting root domains
cat ~/Desktop/recondata/$1/domains.txt | rev|cut --d "." --f 1,2,3 |rev|tee -a ~/Desktop/recondata/$1/rootdomains.txt

echo ""
echo ""
echo "count of rootdomains.txt"
cat ~/Desktop/recondata/$1/rootdomains.txt |wc -l


echo ""
echo ""
echo "CERTIFICATE SEARCH ON ROOT DOMAINS"
echo ""
echo ""
#again loking for more domains from rootdomains
for i in $(cat ~/Desktop/recondata/$1/rootdomains.txt);
 do
	
curl -s https://crt.sh/?q\=%.$i\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | tee -a ~/Desktop/recondata/$1/domains.txt
done

echo ""
echo ""
echo "count of domains.txt after certsearch on rootdomains"
cat ~/Desktop/recondata/$1/domains.txt |wc -l

echo ""
echo ""
echo "REMOVING DUPLICATES"

#removing duplicate entries
sort -u ~/Desktop/recondata/$1/domains.txt -o ~/Desktop/recondata/$1/domains.txt
echo "DUPLICATES REMOVED"

echo ""
echo ""
echo "count of domains.txt after removing duplicate"
cat ~/Desktop/recondata/$1/domains.txt |wc -l

#This takes too much time to run 
#echo ""
#echo ""
#echo "RUNNING ALTDNS"
#echo ""
#echo ""
#Running altdns
#altdns -i ~/Desktop/recondata/$1/domains.txt -o ~/Desktop/recondata/$1/altdns1.txt  -w ~/tools/altdns/words.txt -r -s ~/Desktop/recondata/$1/altdns.txt

#copying data to domains.txt
#cat ~/Desktop/recondata/$1/altdns.txt >> ~/Desktop/recondata/$1/domains.txt
#echo ""
#echo ""
#echo "AGAIN REMOVING DUPLICATES"
#echo ""
#echo ""
#sort -u ~/Desktop/recondata/$1/domains.txt -o ~/Desktop/recondata/$1/domains.txt
#echo "DUPLICATES REMOVED"

#echo ""
#echo ""
#echo "final count of domains.txt"
#cat ~/Desktop/recondata/$1/domains.txt |wc -l

echo "CHECKING FOR ALIVE DOMAINS"
echo ""
echo ""

#checking for alive domains
echo "\n\n[+] Checking for alive domains..\n"
cat ~/Desktop/recondata/$1/domains.txt | ~/go/bin/httprobe | tee -a ~/Desktop/recondata/$1/alive.txt

echo ""
echo ""
echo ""
echo "FORMATING DATA TO JSON"

#formatting the data to json

cat ~/Desktop/recondata/$1/alive.txt | python -c "import sys; import json; print (json.dumps({'domains':list(sys.stdin)}))" > ~/Desktop/recondata/$1/alive.json
cat ~/Desktop/recondata/$1/domains.txt | python -c "import sys; import json; print (json.dumps({'domains':list(sys.stdin)}))" > ~/Desktop/recondata/$1/domains.json

rm ~/Desktop/recondata/$1/rootdomains.txt
rm ~/Desktop/recondata/$1/sublister.txt
