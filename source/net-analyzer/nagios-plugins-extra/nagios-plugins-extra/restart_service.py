#!/usr/bin/python
# -*- coding: utf-8 -*-

from optparse import OptionParser
from subprocess import call
import sys


if __name__ == "__main__":
	parser = OptionParser()
	parser.add_option("-r", "--restart", dest="restart", help="Restart the service in state (comma-seperated list of \"SOFT\" and \"HARD\"")
	parser.add_option("-s", "--state", dest="state", help="The service state")
	parser.add_option("-t", "--type", dest="type", help="The state type (SOFT or HARD)")
	parser.add_option("-a", "--attempt", dest="attempt", help="The service attempt")
	parser.add_option("-d", "--dosudo", dest="sudo", action="store_true", default=False, help="Prefix restart with 'sudo'")


	parser.add_option("-e", "--email", dest="email", help="Send a notification to this address")
	parser.add_option("-n", "--name", dest="service", help="The name of the init.d script of the service")


	(options, args) = parser.parse_args()

	if not (options.service and options.state and options.type and options.attempt):
		parser.print_help()
		sys.exit(1)

	
	restart_types = [x.strip().lower() for x in options.restart.split(",")]

	if options.state == "CRITICAL":
		if options.type.lower() in restart_types:
			cmd = "/etc/init.d/%s restart" % options.service
			if options.sudo:
				cmd = "/usr/bin/sudo %s" % cmd 

			print "RESTART: %s" % cmd
			call(cmd, shell=True)

			if options.email:
				call('echo "Service restarted" | mail -s "Restarted service %s" %s' % (options.service, options.email), shell=True)