#!/bin/bash

PATH=/bin:/usr/bin:/sbin:/usr/sbin export PATH

flagFile="/Library/Application Support/USC/rebooter/.rebootAtLoginWindow"

# read first line of flag file
read -r tgt < "$flagFile"

tgt = `echo $tgt | tr '[A-Z]' '[a-z]' | tr -d '\n'`

if [[ $tgt == "win" ]]
then
	bless --setBoot --mount "/Volumes/Bootcamp" --legacy
elif [[ $tgt == "net" ]]
then
	bless --netboot --server bsdp://128.125.5.196 --nextonly
else
	bless --setBoot --mount "/"
fi
	
rm "$flagFile"

#jamf displayMessage -message "This is where I would reboot! (target: $tgt)"
reboot

exit 0