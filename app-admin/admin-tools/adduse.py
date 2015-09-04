#!/usr/bin/env python2
# -*- coding: utf-8 -*-

'''
@version $Id$

Part of the app-admin/admin-tools package in the last-hope overlay (http://www.j-schmitz.net/projects/admin-tools/)
'''

import os
import shutil
import sys
import re
import portage
from portage.versions import _cp, _vr, pkgsplit, pkgcmp, _cpv, _cat, _pkg
import argparse

comment_re = re.compile("^\s*#.*", re.IGNORECASE)
_verrule = r'([<|>]?=?)?'
if isinstance(_cp, dict):
	cp = _cp['dots_disallowed_in_PN']
else:
	cp = _cp
uses_re = re.compile(
	"^\s*" + '(?P<catpkg>' + _verrule + cp + ')' + " (?P<useflags>(.*))", re.IGNORECASE
)


class PackageUSEEntry(object):
	comments = []
	package = None
	uses = []

	def __init__(self, package=None, uses=[], comments=[]):
		self.comments = comments
		self.package = package
		self.uses = uses

	def __cmp__(self, other):
		left = self.package.lstrip("<>=")
		right = other.package.lstrip("<>=")
		# this does not take account of the version numbers, but thats ok
		return cmp(left, right)


class PackageUSEHandler(object):
	_package_use_file = None
	_entries = []
	_garbage = []

	def __init__(self, file=None):

		if file:
			self._package_use_file = file
		else:
			# makes this class PREFIX aware
			prefix_root = portage.settings['EPREFIX']
			if not prefix_root.strip():
				prefix_root = "/"
			self._package_use_file = os.path.join(prefix_root, "etc/portage/package.use")

			if os.path.isdir(self._package_use_file):
				self._package_use_file = os.path.join(self._package_use_file, 'adduse')

		self.read()

	def read(self):
		"""Reads the list of packages/use flags from the package.use file"""

		if not os.path.exists(self._package_use_file):
			return

		if not os.access(self._package_use_file, os.R_OK):
			raise IOError("Cannot read file %s" % self._package_use_file)

		comments = []

		with open(self._package_use_file) as f:
			for l in f:
				line = l.strip()

				if not line:
					continue  # skip empty lines

				if comment_re.match(line):
					comments.append(line)
					continue

				match = uses_re.match(line)
				if not match:
					# the line is not a comment and not a valid entry for the
					# package.use file
					self._garbage.append(line)
					continue

				pkg = match.group('catpkg')
				uses = re.split("\s+", match.group('useflags'))

				if not pkg or len(pkg.strip()) == 0 or not uses or len(uses) == 0:
					self._garbage.append(line)
					continue

				try:
					# this test matches only duplicate strings
					entry = (x for x in self._entries if x.package == pkg).next()
					entry.comments.extend(comments)
					entry.uses.extend(uses)
				except StopIteration:
					entry = PackageUSEEntry(pkg, uses, comments)
					self._entries.append(entry)

				comments = []

		if comments:
			# comments at the end of the file (without a following package
			# specification)
			self._garbage.extend(comments)

	def write(self):
		"""Writes a sorted, cleaned list of packages/use flags to the package.use file"""

		if not os.path.exists(self._package_use_file):
			directory = os.path.dirname(self._package_use_file)
			if not os.path.exists(directory):
				try:
					os.makedirs(directory, 0755)
				except:
					raise IOError("Could not create directory %s!" % directory)

		if os.path.exists(self._package_use_file) and not os.access(self._package_use_file, os.W_OK):
			raise IOError("You are not allowed to write to %s." % (self._package_use_file))

		# sort the entries (uses the __cmp__() function on the entries object)
		self._entries = sorted(self._entries)

		with open(self._package_use_file, 'w') as o:
			for pkg in self._entries:
				pkg.uses = self._clean_uses(pkg.uses)
				if pkg.uses:
					o.writelines(["%s\n" % x for x in pkg.comments])
					o.write("%s %s\n" % (pkg.package, ' '.join(pkg.uses)))

			o.writelines('\n'.join(self._garbage) + '\n')

	def set_use(self, pkg, uses):
		try:
			entry = (x for x in self._entries if x.package == pkg).next()
			entry.uses.extend(uses)
		except StopIteration:
			entry = PackageUSEEntry(pkg, uses)
			self._entries.append(entry)

		if not re.match(r'^' + _verrule, pkg).group(1):
			# we set the use flag for foo/bar baz - change the use flag on all
			# possible version dependent entries
			for p in [x.package for x in self._entries]:
				# pkg in p may be to fuzzy
				if re.match("^" + _verrule, p).group(1) and pkg in p:
					self.remove_use(p, uses)

	def remove_use(self, pkg, uses):
		try:
			entry = (x for x in self._entries if x.package == pkg).next()

			l = uses
			l.extend([self._negate(x) for x in uses])
			for u in l:
				if u in entry.uses:
					entry.uses.remove(u)
		except StopIteration:
			pass

	def _negate(self, use):
		if use.startswith("-"):
			return use[1:]
		else:
			return "-%s" % use

	def _clean_uses(self, uses):
		newuses = []

		for current in uses:
			neg_use = self._negate(current)

			if neg_use in newuses:
				print "Removing flip use: %s (was: %s)" % (neg_use, current)
				newuses.remove(neg_use)

			if not current in newuses:
				newuses.append(current)
			else:
				print "Removing dup use: %s" % current

		return sorted(newuses)


def sorted_best(pkg_query, a, b):
	qcat, qname = pkg_query.split('/') if '/' in pkg_query else "", pkg_query
	acat, aname = a.split('/')
	adiff = len(aname.replace(qname, ''))
	bcat, bname = b.split('/')
	bdiff = len(bname.replace(qname, ''))

	if adiff == bdiff:
		return cmp(acat, bcat)

	return cmp(adiff, bdiff)


def test_package(package):
	porttree = portage.db[portage.root]['porttree']
	cp_all = porttree.dbapi.cp_all()

	pkg = package

	if ':' in pkg:
		# JS, 2011-04-08: slot in cp (#124)
		pkg = pkg[:pkg.index(':')]
	else:
		vm = re.match("^" + _verrule, pkg)  # < or > or =
		if vm and vm.group(1):
			m = re.match(
				"^" + _verrule + r'([\w+][\w+.-]*/[\w\-]+)' + _vr, pkg
				)
			if not m:
				raise Exception("Invalid cpv")
			pkg = m.group(2).strip("-")

	if pkg in cp_all:  # exact match for cp
		return package

	# no exact match found. let the user choose
	matches = [x for x in cp_all if pkg in x]

	if len(matches) == 1:
		return matches[0]
	elif len(matches) > 1:
		matches = sorted(matches, cmp=lambda x, y: sorted_best(pkg, x, y))

		print "Package name does not exist. Possible packages:"
		print '\n'.join(["[%s] %s" % (i + 1, matches[i]) for i in xrange(0, len(matches))])
		print ""

		pkg_num = raw_input("Package number [1]: ")
		if not pkg_num.strip():
			pkg_num = "1"

		if pkg_num.isdigit():
			pkg_num = int(pkg_num)
			if pkg_num <= len(matches):
				return matches[pkg_num - 1]
		else:
			return None
	else:
		if raw_input("'%s' does not look like a valid package. Add it anyway? [y/N] " % pkg).lower() != "y":
			return None
		else:
			return package


if __name__ == '__main__':
	parser = argparse.ArgumentParser(description="Modify local USE flags for packages in /etc/portage/package.use")
	parser.add_argument('package', type=str, nargs=1, help="Package name: either as 'package' or 'category/package'")
	parser.add_argument('USE', type=str, nargs=argparse.REMAINDER, help="USE flags to change: +foo -bar -baz")
	parser.add_argument('-f', '--file', type=str,
						help="Alternate package.use file (defaults to the prefix-aware etc/portage/package.use)")
	args = parser.parse_args()

	# We cannot exchange this, because positional arguments are only allowed to
	# start with "-" if -- is specified before or they look like neg. numbers.
	# http://docs.python.org/dev/library/argparse.html#arguments-containing
	if not args.USE:
		parser.print_help()
		sys.exit(1)

	try:
		package = test_package(args.package[0])
		if not package:
			sys.exit(1)
	except KeyboardInterrupt:
		sys.exit(0)

	print "Adding uses %s to package %s" % (', '.join(args.USE), package)

	puh = PackageUSEHandler(args.file)
	puh.set_use(package, args.USE)
	puh.write()
