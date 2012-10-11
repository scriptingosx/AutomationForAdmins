#!/bin/bash

PATH=/bin:/usr/bin:/sbin:/usr/sbin export PATH

launchctl load -w /Library/LaunchAgents/edu.usc.remotebooter.plist
launchctl load -w /Library/LaunchDaemons/edu.usc.remotebootpicker.plist

exit 0