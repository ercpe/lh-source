#!/usr/bin/python

import re
import sys
import pickle
import os
import time

STATUS_OK = 0
STATUS_WARN = 1
STATUS_CRIT = 2
STATUS_UNKN = 3

STATE_FILE='/tmp/nagios_traffic.pickle'

r = re.compile('^([\w\d]+):\s*(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)$', re.IGNORECASE)
#                                                      in                                                   out
#                iface        bytes     pkg     err    drop    fifo   frames   comp   mult    bytes    pkg      err    drop    fifo    colls  carrier   comp
#                  1            2        3       4       5       6       7       8      9       10      11       12     13      14      15       16      17

watch_iface = None

if len(sys.argv) == 2:
	watch_iface = sys.argv[1]
else:
	print "USAGE: %s <iface>" % __file__
	sys.exit(STATUS_UNKN)


proc_file = '/proc/net/dev'
lines = []

with open(proc_file, 'r') as proc:
	lines = [x.strip() for x in proc.readlines()[2:]]

current_data = {}
for line in lines:
	match = r.search(line)

	if match:
		iface = match.group(1)
		
		in_bytes = match.group(2)
		in_pkt = match.group(3)
		in_errors = match.group(4)
		
		out_bytes = match.group(10)
		out_pkt = match.group(11)
		out_errors = match.group(12)

		current_data[iface] = (in_bytes, in_pkt, in_errors, out_bytes, out_pkt, out_errors)

last_data = {}

current_checktime = int(time.mktime(time.localtime()))
last_checktime = int(current_checktime) 

if os.path.exists(STATE_FILE):
	last_checktime = os.path.getmtime(STATE_FILE)
	with open(STATE_FILE, 'r') as f:
		last_data = pickle.load(f)

time_diff = current_checktime - last_checktime

with open(STATE_FILE, 'w') as f:
	pickle.dump(current_data, f)

if not watch_iface in current_data.keys():
	print "Interface %s not found" % watch_iface
	sys.exit(STATUS_UNKN)
else:
	last_state = last_data[watch_iface] if watch_iface in last_data.keys() else current_data[watch_iface]
	current_state = current_data[watch_iface]

	perf_data = []
	perf_data_names = ['in_bytes', 'in_pkt', 'in_err', 'out_bytes', 'out_pkt', 'out_err']

	for x in range(0, 6):
		value = 0
		
		if long(last_state[x]) > long(current_state[x]):
			value = current_state[x]
		else:
			value = long(current_state[x]) - long(last_state[x])

		if time_diff > 0:
			value = int(value / time_diff)

		if x >= 3 and value != 0:
			value = value * -1
		
		perf_data.append("%s=%s" % (perf_data_names[x], value))
		
	print "Interface %s: OK|%s" % (watch_iface, ';'.join(perf_data))
