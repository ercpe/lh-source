#!/usr/bin/python2
# -*- coding: utf-8 -*-

'''
Copyright Information
2010 Johann Schmitz, Duesseldorf, Germany

@author Johann Schmitz (johann@j-schmitz.net)
@version $Id$

Web:  www.j-schmitz.net
Mail: johann@j-schmitz.net
'''

import os
import shutil
import sys
import re
import portage
from portage.versions import _cp, _vr
import argparse

comment_re = re.compile("^\s*#.*", re.IGNORECASE)
# /usr/lib64/portage/pym/portage/versions.py says this
#_cat = r'[\w+][\w+.-]*'
#_pkg = r'[\w+][\w+-]*?'
#_v = r'(\d+)((\.\d+)*)([a-z]?)((_(pre|p|beta|alpha|rc)\d*)*)'
#_rev = r'\d+'
#_vr = _v + '(-r(' + _rev + '))?'
#_cp = '(' + _cat + '/' + _pkg + '(-' + _vr + ')?)'

_verrule = r'([<|>]?=?)?'

uses_re = re.compile("^\s*" + '(?P<catpkg>' + _verrule + _cp + ')' + " (?P<useflags>(.*))", re.IGNORECASE)
split_re = re.compile("\s+", re.IGNORECASE)

prefix_root = portage.settings['EPREFIX']
if not prefix_root.strip():
	prefix_root = "/"
PACKAGE_USE=os.path.join(prefix_root, "etc/portage/package.use")

def argumentparser():
	parser = argparse.ArgumentParser(
						description="Modify local USE flags for packages in /etc/portage/package.use")
	parser.add_argument(
					'package',
					type=str,
					help="Package name: either as Package or Category/Package")
	parser.add_argument(
					'USE',
					type=str,
					nargs=argparse.REMAINDER,
					help="USE flags to change: +foo -bar -baz")
	return parser
	

def read_uses():
	packages = {}
	comments = {}
	garbage = []
	commentsline = []
	
	if os.path.exists(PACKAGE_USE):
		with open(PACKAGE_USE) as f:
			for l in f:
				line = l.strip()

				# skip empty lines and comments
				if line != "":
					if comment_re.match(line):
						commentsline.append(line)
					else:
						match = uses_re.match(line)
						if match:
							pkg = match.group('catpkg')
							uses = split_re.split(match.group('useflags'))
	
							if not pkg or len(pkg.strip()) == 0 or not uses or len(uses) == 0:
								print "Skipping garbage: %s" % line
								continue 
		
							if pkg in packages:
								u = packages[pkg]
								u.extend(uses)
								packages[pkg] = u
							else:
								packages[pkg] = uses
	
							if pkg in comments:
								c = comments[pkg]
								c.extend(commentsline)
								comments[pkg] = c
								del commentsline[:]
							else:
								comments[pkg] = commentsline
								commentsline = []
						else:
							garbage.append(line)
	return packages, comments, garbage

def negate(use):
	if use.startswith("-"):
		return use[1:]
	else:
		return "-%s" % use

def clean_uses(adict):
	newdict = {}

	for pkg, uses in adict.iteritems():
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

def test_package(pkg):
	porttree = portage.db[portage.root]['porttree']

	cp_all = porttree.dbapi.cp_all()

	org_pkg = pkg
	if ':' in pkg:
		# JS, 2011-04-08: slot in cp (#124)
		pkg = pkg[:pkg.index(':')]

	if pkg in cp_all:
		return org_pkg
	else:
		# no exact match found. let the user choose
		matches = [x for x in cp_all if pkg in x]
		
		if len(matches) > 0:
			print "Package name does not exist. Possible packages:"
			print '\n'.join(["[%s] %s" % (i+1, matches[i]) for i in xrange(0, len(matches))])
			print ""
			pkg_num = raw_input("Package number [1-%s]: " % len(matches))
			
			if pkg_num.isdigit():
				pkg_num = int(pkg_num)
				if pkg_num <= len(matches):
					return matches[pkg_num-1]
			else:
				return None 
		else:
			if raw_input("'%s' does not look like a valid package. Add it anyway? [y/N] " % pkg).lower() != "y":
				return None
			else:
				return pkg

def add_use(pkg, uses):

	package = test_package(pkg)

	if not package:
		return
	
	print "Adding uses %s to package %s" % (', '.join(uses), package)

	current_uses, comments_line, trash = read_uses()

	matched = False
	pkg_re = re.compile(_verrule + pkg + '(-' + _vr + ')?', re.IGNORECASE)
	for key in current_uses.keys():
		if pkg_re.search(key):
			u = current_uses[key]
			u.extend(uses)
			current_uses[key] = u
			matched = True
	if not matched:
		current_uses[package] = uses

	uses = clean_uses(current_uses)

	if os.path.exists(PACKAGE_USE):
		shutil.copyfile(PACKAGE_USE, PACKAGE_USE + ".backup")

	with open(PACKAGE_USE, 'w') as f:
		for k in sorted(uses.keys()):
			f.write("%s\n" % (' \n'.join(comments_line[k])))
			f.write("%s %s\n" % (k, ' '.join(uses[k])))

		for x in trash:
			f.write("%s\n" % x)

if __name__ == '__main__':
	j = argumentparser()
	adduseargs = j.parse_args()
	
	if not os.path.exists(PACKAGE_USE):
		if not os.path.exists(os.path.dirname(PACKAGE_USE)):
			try:
				os.makedirs(os.path.dirname(PACKAGE_USE), 0755)
			except:
				print "Could not create directory %s!" % os.path.dirname(PACKAGE_USE)
				sys.exit(1)

	if os.path.exists(PACKAGE_USE) and not os.access(PACKAGE_USE, os.W_OK):
		print "You are not allowed to write to %s." % (PACKAGE_USE)
		sys.exit(1)

	add_use(adduseargs.package, adduseargs.USE)
