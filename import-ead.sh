#!/bin/sh

set -e
set -u

. "$(dirname $0)/params.sh"

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
