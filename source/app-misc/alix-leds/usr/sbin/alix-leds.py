#!/usr/bin/python
# -*- coding: utf-8 -*-

'''
Copyright 2010 Johann Schmitz (johann@j-schmitz.net)

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License 
version 2 as published by the Free Software Foundation.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
'''

import os
import sys
import time
from optparse import OptionParser


def test_led_support():
	return os.path.exists('/sys/class/leds/alix:1') and os.path.exists('/sys/class/leds/alix:2') and os.path.exists('/sys/class/leds/alix:3')

def set_led_status(led_id, on=True):
	with open('/sys/class/leds/alix:%s/brightness' % led_id, 'w') as l:
		l.write(str(int(on)))

def get_led_status(led_id):
	with open('/sys/class/leds/alix:%s/brightness' % led_id, 'r') as l:
		return bool(int(l.read()))


def set_led_trigger(led_id, trigger_name, **kwargs):
	with open('/sys/class/leds/alix:%s/trigger' % led_id, 'w') as l:
		l.write(trigger_name)

	for k, v in kwargs.iteritems():
		if k and v:
			file = '/sys/class/leds/alix:%s/%s' % (led_id, k)
			if os.path.exists(file):
				with open(file, 'w') as o:
					o.write(v)


def disco():
	for x in [1, 2, 3]: set_led_status(x, False)

	for y in xrange(0, 5):
		for outer in [1, 2, 3]:
			set_led_status(outer, True)
			time.sleep(0.2)
			for x in [1, 2, 3]: set_led_status(x, False)

	for x in [1, 2, 3]: set_led_status(x, False)

	for x in range(0, 3):
		for x in [1, 2, 3]: set_led_status(x, True)
		time.sleep(0.5)
		for x in [1, 2, 3]: set_led_status(x, False)
		time.sleep(0.5)


if __name__ == "__main__":
	if not test_led_support():
		print "Alix LED support not found! Exiting."
		sys.exit(1)

	parser = OptionParser(usage="usage: %prog [options]")
	parser.add_option("-l", "--led", dest="led_id", type="int", help="set status of led #LED")
	parser.add_option("-t", "--trigger", dest="trigger", help="sets the trigger of the led to TRIGGER")
	parser.add_option("--on", dest="set_on", action="store_true", help="sets the led status to ON")
	parser.add_option("--off", dest="set_off", action="store_true", help="sets the led status to OFF")
	parser.add_option("--switch", dest="switch", action="store_true", help="switch the status of led")
	parser.add_option("-d", "--disco", dest="disco", action="store_true", help="do some disco stuff")

	parser.add_option("--delay-on", dest="delay_on", help="On delay for timer trigger")
	parser.add_option("--delay-off", dest="delay_off", help="Off delay for timer trigger")
	
	(options, args) = parser.parse_args()

	if options.disco:
		disco()
	else:
		if options.led_id:
			led = int(options.led_id)
			if led < 1 or led > 3:
				print "Invalid LED"
				sys.exit(1)

			if options.led_id and (options.set_on or options.set_off):
				set_led_status(options.led_id, True if options.set_on else False)
			elif options.led_id and options.switch:
				set_led_status(options.led_id, not get_led_status(options.led_id))
			elif options.led_id and options.trigger:
				set_led_trigger(int(options.led_id), options.trigger, delay_on=options.delay_on, delay_off=options.delay_off)
			else:
				parser.print_help()

		else:
			parser.print_help()
