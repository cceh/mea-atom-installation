#!/bin/sh

set -e
set -u

LC_ALL=C ; export LC_ALL

. "$(dirname $0)/params.sh"

printf "%s" "About to install Atom ($version) = '$A' [press ENTER]" ; read enter

if [ -d "$trans_version" ] ; then
	echo "Saving translations from '$trans_version'..."
	rm -Rf translations/
	mkdir -p translations/
	find "$trans_version" -type f -iname 'messages.xml' -exec cp --parents {} translations/ \;
	cp --parents -r "$trans_version/data/fixtures" translations/
else
	echo
	echo "WARNING: the base version for translations '$trans_version' is not available [press ENTER]"
	read enter
fi

echo "Removing..."
rm -Rf "$A/"

echo "Downloading..."
if [ "$version" = "stable" ] ; then
	url="https://storage.accesstomemory.org/releases/$A.tar.gz"
elif [ "$version" = "git" ] ; then
	url="https://github.com/artefactual/atom/archive/qa/2.1.x.tar.gz"
else
	git clone --branch "$git_branch" -- 'https://github.com/cceh/atom' "$A"
fi

echo "Unpacking..."
[ "$version" != "mea" ] && tar -xzf $A.tar.gz

if [ ! -f $A/plugins/arDominionPlugin/css/min.css ] ; then
	echo "Fix CSS"
	cp files/min.css $A/plugins/arDominionPlugin/css/
fi

echo "Checking translations..."
set +e
if [ -d "translations/" ] ; then
	diffs=$(diff -urq "$A" "translations/$trans_version" | grep -v '^Only')
	no_diff=$?
	if [ "$no_diff" -eq 0 ] ; then
		echo "...found differences. Please merge them in '$A' before installing it."
		echo
		echo "$diffs" | sed -e 's/^/    /'
		echo
		diff -ur "$A" "translations/$trans_version" | grep -v '^Only'
		echo
		printf "%s" "WARNING: Translations not up to date, continue? [yn] " ; read yn
		[ "$yn" != "y" ] && exit 1
	else
		echo "...OK: no new translations"
	fi
else
	echo "...skipped: directory 'translation' not found."
fi
set -e

echo "Patching"
patch -d $A -p1 < files/0002-Instrument-PropelPDO-to-log-all-SQL-queries.patch
patch -d $A -p1 < files/0003-Disable-elasticsearch-version-cache-REMOVE.patch

echo "Linking..."
if [ "$version" != "mea" ] ; then
	rm -f atom-testing
	ln -s $A atom-testing
fi

echo "Create missing directories..."
mkdir -p $A/uploads

echo "Set permissions..."
find $A -type d -exec fs setacl -dir {} -acl w-mhart write \;
( cd $A; ./symfony project:permissions )

#echo "More permissions..."
#find $A -type d -exec chmod a+rwx {} \;
#find $A -type f -exec chmod a+rw {} \;

echo "DB password:"
cat ../../.db

echo "Error log..."
tail -n 2 -f ../../logs/error_log
