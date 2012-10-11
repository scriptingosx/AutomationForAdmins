#!/usr/bin/python

from BaseHTTPServer import BaseHTTPRequestHandler
import commands, urlparse, json

port = 11702
host = ''

errorFlag = "!Error!"
availablebootoptions = ("mac", "win", "net")

rebootFlagFile = "/Library/Application Support/USC/rebooter/.rebootAtLoginWindow"

def currentUsers():
	result = commands.getoutput("who")
	currentusers=[]
	for x in result.splitlines():
		(username, line, time) = x.split(None, 2)
		if line == "console":
			currentusers.append(username)

	return currentusers


def setRebootFlag(flag):
	with open (rebootFlagFile, 'w') as f:
		f.write(flag)
	return flag

def os(elements):
	return "Mac"
	
def boot(elements):
	message = ""
	flag = elements[0]
	if flag != "" and flag in availablebootoptions:
		if flag == "mac":
			message = "Already booted to Mac"
		else:
			message = "Request to boot " + flag.title() + " accepted."
			if len(currentUsers()) > 0:
				message = message + " Waiting for current user to log out."
		setRebootFlag(flag)
	else:
		return errorFlag
	
	return message
	
def bootoptions(elements):
	options = ("Win", "Net")
	return options
	
def status(elements):
	users = currentUsers();
	isLoggedIn = len(users) > 0
	usernames=", ".join(users)
	return { "userLoggedIn" : isLoggedIn, "username" : usernames , "bootoptions" : bootoptions(None), "os" : os(None) }


actions = {"os":os, "boot":boot, "bootoptions":bootoptions, "status":status}

class GetHandler(BaseHTTPRequestHandler):
	
	def do_GET(self):
		path_elements = self.path.split("/")
		path_elements = [x.lower() for x in path_elements]
		print path_elements
		first_element = path_elements[1]
		
		if first_element in actions.keys():
			response = actions[first_element](path_elements[2:])
			
			if response == errorFlag:
				self.send_error(404)
			else:
				self.send_response(200)
				self.send_header("Content-type", "application/json")
				self.end_headers()
				self.wfile.write(json.dumps(response))
				
		else:
			self.send_error(404)
			
		return



if __name__ == '__main__':
	from BaseHTTPServer import HTTPServer
	server = HTTPServer((host, port), GetHandler)
	print 'Starting server, use <Ctrl-C> to stop'
	if host == '':
		hostname = commands.getoutput("hostname")
	else:
		hostname = host
	print "http://%s:%d/" % (hostname, port)
	server.serve_forever()
	
