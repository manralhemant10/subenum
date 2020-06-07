Command to use:

./enum.sh example.com


Tools used :
1. Amass 		(https://github.com/OWASP/Amass)
2. sublist3r 	(https://github.com/aboul3la/Sublist3r)
3. assetfinder  (https://github.com/tomnomnom/assetfinder)
4. certsh 		(https://crt.sh/)
5. httprobe 	(https://github.com/tomnomnom/httprobe)

You must have following before use: 

amass executable should be in /usr/bin/           
sublist3r should be in root/tools         		
assetfinder should be in ~/go/bin/assetfinder 	

or if you dont want you will have to change call of this tool from the script

after complete running of the script, you will get following files:

1. domains.txt 	(all domains collected)
2. domains.json (same as above point but in json format)
3. alive.txt 	(all live domains after )
4. alive.json 	(same as above point but in json format)
