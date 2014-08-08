#!/bin/sh

set -e
set -u

version="stable"
#version="git"
#version="mea"

A="atom-2.0.1"
[ "$version" = "git" ] && A="atom-qa-2.1.x"
[ "$version" = "mea" ] && A="atom-qa-2.1.x-mea"

echo "About to install Atom ($version) =  '$A' [press ENTER]" ; read enter

echo "Removing..."
rm -Rf "$A/"

echo "Downloading..."
if [ "$version" = "git" ] ; then
	url="https://github.com/artefactual/atom/archive/qa/2.1.x.tar.gz"
else
	url="https://storage.accesstomemory.org/releases/$A.tar.gz"
fi
[ "$version" != "mea" ] && wget $url -O $A.tar.gz

echo "Unpacking..."
tar -xzf $A.tar.gz

if [ ! -f $A/plugins/arDominionPlugin/css/min.css ] ; then
	echo "Fix CSS"
	cp files/min.css $A/plugins/arDominionPlugin/css/
fi

echo "Patching"
patch -d $A -p1 < files/0002-Instrument-PropelPDO-to-log-all-SQL-queries.patch

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
