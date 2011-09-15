#!/usr/bin/python

import re
import sys
from optparse import OptionParser


parser = OptionParser()
parser.add_option("-f", "--file", dest="filename", help="the mail.log to read from", metavar="FILE")
parser.add_option("-n", "--nagios", action="store_true", dest="nagios_output", default=False, help="Print NRPE compatible output")

(options, args) = parser.parse_args()

if not options.filename:
	parser.print_help()
	sys.exit(1)

lines = []
timing_re = re.compile(".*TIMING-SA total \d+ ms - (.*)", re.IGNORECASE)

with open(options.filename, 'r') as f:
	lines = [(x.strip(), timing_re.match(x.strip())) for x in f.readlines()]

timings = {}
check_timing_re = re.compile("(?P<check>[\w\d\-_]+): (?P<duration>[\d\.]+) \((?P<fraction>[\d\.]+)%\)", re.IGNORECASE)

for line, match in [x for x in lines if x[1]]:
	for sub_check in match.group(1).split(', '):
		m = check_timing_re.match(sub_check)
		if not m:
			continue

		try:
			check = m.group('check')
			duration = float(m.group('duration'))
			fraction = m.group('fraction')
			
			#print "Check '%s' took %s ms (%s %% of this run)" % (check, duration, fraction)
			
			if check in timings.keys():
				timings[check].append(duration)
			else:
				timings[check] = [duration]
			
		except Exception as ex:
			#print ex
			pass

if options.nagios_output:
	perf_data = []
	for check_name in sorted(timings.keys()):
		data = timings[check_name]
		avg = sum(data) / len(data)
		perf_data.append("%s=%s" % (check_name, round(avg, 2)))
		
	print "Timings OK | %s" % ';'.join(perf_data)
else:
	for check_name, data in timings.iteritems():
		print "%s: Min %s, Max: %s, Avg: %s" % (check_name, min(data), max(data), sum(data) / len(data))
