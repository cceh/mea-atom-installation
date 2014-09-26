#!/bin/sh

set -e
set -u

version="stable"
#version="git"
version="mea"

A="atom-2.0.1"
[ "$version" = "git" ] && A="atom-qa-2.1.x"
[ "$version" = "mea" ] && A="atom-qa-2.1.x-mea"

printf "%s" "About to import data into Atom ($version) = '$A' [press ENTER]" ; read enter

printf "%s" "Is the German language set up in Atom? [press ENTER]" ; read enter

cd "$A"

sentinel_file='config/search.yml'
if [ ! -f "$sentinel_file" ] ; then
	echo "ERROR: Atom ($version) in '$A' is not configured: '$sentinel_file' not found."
	exit 1
fi

ead_dir="../ead-imports/import6"

echo "Importing EAD from directory '$ead_dir'..."
./symfony import:bulk "$ead_dir"

echo "Populating the search indexes..."
./symfony search:populate

echo "Crearing the cache..."
./symfony cache:clear
