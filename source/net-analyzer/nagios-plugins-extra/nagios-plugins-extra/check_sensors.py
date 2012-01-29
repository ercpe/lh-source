#!/usr/bin/python
# -*- coding: utf-8 -*-

import sensors
import optparse
import sys
import traceback
import re

DataTypeVoltage = 0
DataTypeRPM = 1
DataTypeTemperature = 2
DataTypeOther = -1

MY_VERSION="%prog 1.0"

OK = 0
WARNING = 1
CRITICAL = 2
UNKOWN = 3

def get_type_name(type):
	if type == DataTypeVoltage:
		return 'Voltage'
	elif type == DataTypeRPM:
		return 'RPM'
	elif type == DataTypeTemperature:
		return 'Temperature'
	else:
		return 'Other'


parser = optparse.OptionParser(version=MY_VERSION, description="Nagios plugin wo check sensors via libsensors including perfdata. Uses libsensors via ctypes.")
parser.add_option("-d", "--debug", dest="debug", help="enabled debug output", action="store_true", default=False)
parser.add_option("-t", "--temperatures", action="store_true", dest="temps", default=True, help="include temperatures (default: True)")
parser.add_option("-f", "--fans", action="store_true", dest="fans", default=True, help="include fan speeds (default: True)")
parser.add_option("-v", "--voltages", action="store_true", dest="voltages", default=False, help="include voltages (default: False)")
parser.add_option("-e", "--exclude", dest="exclude", default="", help="exclude features (e.g. 'fan1,temp3')")
parser.add_option("--warn-temperature", dest="warn_temp", default=80, type="int", help="warning limit for temperatures (default: 80)")
parser.add_option("--crit-temperature", dest="crit_temp", default=100, type="int", help="critical limit for temperatures (default: 100)")
parser.add_option("--warn-speed", dest="warn_speed", default=100, type="int", help="warning limit for fan speeds (default: 100)")
parser.add_option("--crit-speed", dest="crit_speed", default=300, type="int", help="critical limit for fan speeds (default: 300)")
parser.add_option("--no-temperatures", action="store_false", dest="temps", help="exclude all temperatures")
parser.add_option("--no-fans", action="store_false", dest="fans", help="exclude all fans")
parser.add_option("--no-voltages", action="store_false", dest="voltages", help="exclude all voltages")

(options, args) = parser.parse_args()

exclude_feature_names = re.split("\s*,\s*", options.exclude, re.IGNORECASE)

# a list of tuples (chip, feature, value)
sensor_values = []
exit = OK

sensors.init()

abnormal_features = []

try:
	# iterate over all sensor-chips
	for chip in sensors.iter_detected_chips():
		chip_name = str(chip)

		if options.debug:
			print '%s at %s in %s on bus %s with prefix %s' % (chip, chip.adapter_name, chip.path, chip.bus, chip.prefix)

		for feature in chip:
			# restrict to the selected feature types
			if (feature.type == DataTypeVoltage and options.voltages) or (feature.type == DataTypeRPM and options.fans) or (feature.type == DataTypeTemperature and options.temps):
				value = feature.get_value()
				
				if feature.type == DataTypeRPM:
					# we dont care about fraction on fan speeds
					value = int(value)
				
				if not feature.name in exclude_feature_names:
					sensor_values.append((chip_name, feature.name, value))
					
					# it would be better to check against the configured warning/alarm thresholds in sensors,
					# but i see no easy way to add this via the ctypes bindings
					if feature.type == DataTypeRPM:
						if value <= options.warn_speed:
							abnormal_features.append(feature.name)
							if exit < WARNING: exit = WARNING

						if value <= options.crit_speed:
							abnormal_features.append(feature.name)
							if exit < CRITICAL: exit = CRITICAL
							
					elif feature.type == DataTypeTemperature:
						if value >= options.warn_temp:
							abnormal_features.append(feature.name)
							if exit < WARNING: exit = WARNING

						if value >= options.crit_temp:
							abnormal_features.append(feature.name)
							if exit < CRITICAL: exit = CRITICAL

			if options.debug:
				print '  %s (name: %s, number: %s, type %s - %s): %.2f' % (feature.label, feature.name, feature.number, feature.type, get_type_name(feature.type), feature.get_value())
	
	sensor_values = sorted(sensor_values)

	perfdata = []
	
	# coretemp values may be on multiple adapters, and may be start on another index than 0 or 1
	# normalize values to provide stable perfdata output
	coretemp_idx = 0
	for chip_name, feature_name, feature_value in sensor_values:
		name = feature_name # breaks on systems with multiple chips!
		
		if 'coretemp' in chip_name or 'cputemp' in chip_name:
			name = "coretemp%s" % coretemp_idx
			coretemp_idx += 1
		
		perfdata.append("%s=%s" % (name, feature_value)) 

	abnormal_features = sorted(list(set(abnormal_features)))
	status_str = "OK"
	if exit == WARNING:
		status_str = "WARNING: %s above threshold" % ', '.join(abnormal_features)
	elif exit == CRITICAL:
		status_str = "CRITICAL: %s above threshold" % ', '.join(abnormal_features)

	print "Sensors %s|%s" % (status_str, ';'.join(perfdata))
except Exception as ex:
	print "Error reading sensor values (%s)" % ex
	
	if options.debug:		
		print traceback.format_exc()

	sys.exit(UNKOWN)
finally:
	sensors.cleanup()

sys.exit(exit)