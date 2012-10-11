#!/bin/bash

PATH=/bin:/usr/bin:/sbin:/usr/sbin export PATH

if [[ -e /Library/LaunchAgents/edu.usc.remotebooter.plist ]]
then
	launchctl unload /Library/LaunchAgents/edu.usc.remotebooter.plist
fi

if [[ -e /Library/LaunchDaemons/edu.usc.remotebootpicker.plist ]]
then
	launchctl unload /Library/LaunchDaemons/edu.usc.remotebootpicker.plist
fi

exit 0