#!/usr/bin/osascript
on run argv
	set i to 1
	
	set c to count of argv
	-- help message
	if (c = 0 or item i of argv is in {"-h", "-help"}) then
		
		my logHelpMessage()
		return
	end if
	
	-- observe flag
	if item i of argv is in {"-o", "-observe"} then
		set shouldObserve to true
		set i to i + 1
	else
		set shouldObserve to false
	end if
	
	if c < i then
		my logHelpMessage
		return
	end if
	
	repeat with x from i to c
		
	set theAddress to item x of argv
	log theAddress
			
		tell application "Remote Desktop"
			set theComputer to ""
			try
				set theComputer to (first computer where DNS name is theAddress)
			end try
			if theComputer is "" then
				try
					set theComputer to (first computer where Internet address is theAddress)
				end try
			end if
			
			if theComputer is "" then
				try
					set theComputer to (first computer where name is theAddress)
				end try
			end if
			
			if theComputer is "" then
				log "could not parse address or computer name: " & theAddress
			else
				activate
				if shouldObserve then
					observe theComputer
				else
					control theComputer
				end if
			end if
		end tell
		
	end repeat
end run

on logHelpMessage()
	log "control: launches Remote Desktop or Screen Sharing from the command line to control a given ip address or dns name.\ncontrol -h|-help: prints this message\ncontrol [-o|-observe] <address>\n"
end logHelpMessage