#!/usr/bin/python
# -*- coding: utf-8 -*-

'''
Copyright Information
2010 Johann Schmitz, Duesseldorf, Germany

@author Johann Schmitz (johann@j-schmitz.net)
@version $Id: adduse.py 1401 2010-11-12 18:53:35Z johann $

Web:  www.j-schmitz.net
Mail: johann@j-schmitz.net
'''

import os
import shutil
import sys
import re
import portage

comment_re = re.compile("^\s*#.*", re.IGNORECASE)
uses_re = re.compile("^\s*([\w_\-0-9\+]+/[\w_\-0-9\+]+) (.*)", re.IGNORECASE)
split_re = re.compile("\s+", re.IGNORECASE)

prefix_root = portage.settings['EPREFIX']
PACKAGE_USE=os.path.join(prefix_root, "/etc/portage/package.use")

def read_uses():
	packages = {}
	garbage = []
	
	if os.path.exists(PACKAGE_USE):
		with open(PACKAGE_USE) as f:
			for l in f:
				line = l.strip() 
				if line != "" and not comment_re.match(line):
					match = uses_re.match(line)
					if match:
						pkg = match.group(1)
						uses = split_re.split(match.group(2))
						#print "%s: %s" % (pkg, ' '.join(uses))
	
						if not pkg or len(pkg.strip()) == 0 or not uses or len(uses) == 0:
							print "Skipping garbage: %s" % line
							continue 
	
						if pkg in packages.keys():
							u = packages[pkg]
							u.extend(uses)
							packages[pkg] = u
						else:
							packages[pkg] = uses
					else:
						garbage.append(line)
	return packages, garbage

def negate(use):
	if use.startswith("-"):
		return use[1:]
	else:
		return "-%s" % use

def clean_uses(adict):
	newdict = {}
	for pkg, uses in adict.iteritems():
		#print "cleaning package %s" % pkg

		newuses = []

		for currentUse in uses:
			negUse = negate(currentUse)

			if negUse in newuses:
				print "Removing flip use: %s for package %s (was: %s)" % (negUse, pkg, currentUse)
				newuses.remove(negUse)

			if not currentUse in newuses:
				newuses.append(currentUse)
			else:
				print "Removing dup use: %s for package %s" % (currentUse, pkg)

		newdict[pkg] = sorted(newuses)

	return newdict

def add_use(pkg, uses):
	print "Adding uses %s to package %s" % (', '.join(uses), pkg)

	current_uses, trash = read_uses()

	if pkg in current_uses.keys():
		u = current_uses[pkg]
		u.extend(uses)
		current_uses[pkg] = u
	else:
		current_uses[pkg] = uses

	uses = clean_uses(current_uses)

	if os.path.exists(PACKAGE_USE):
		shutil.copyfile(PACKAGE_USE, PACKAGE_USE + ".backup")

	with open(PACKAGE_USE, 'w') as f:
		#for k, v in uses.iteritems():
		for k in sorted(uses.keys()):
			f.write("%s %s\n" % (k, ' '.join(uses[k])))
			#f.write("%s %s\n" % (k, ' '.join(v)))

		for x in trash:
			f.write("%s\n" % x)

if __name__ == '__main__':
	args = sys.argv[1:]

	if not os.path.exists(PACKAGE_USE):
		if not os.path.exists(os.path.dirname(PACKAGE_USE)):
			try:
				os.makedirs(os.path.dirname(PACKAGE_USE), 0755)
			except:
				print "Could not create directory %s!" % os.path.dirname(PACKAGE_USE)
				sys.exit(1)

	if os.path.exists(PACKAGE_USE) and not os.access(PACKAGE_USE, os.W_OK):
		print "%s is not writable!" % PACKAGE_USE
		sys.exit(1)

	if len(args) >= 2:
		add_use(args[0], args[1:])
	else:
		print "USAGE: adduse <package> use1... useN"
		sys.exit(1)

