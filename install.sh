#!/bin/sh

use_git='true'
#use_git='false'

A="atom-2.0.1"
[ "$use_git" = "true" ] && A="atom-2.x"

echo "Removing..."
rm -Rf atom-2.*

echo "Downloading..."
if [ "$use_git" = "true" ] ; then
	url="https://github.com/artefactual/atom/archive/2.x.tar.gz"
else
	url="https://storage.accesstomemory.org/releases/$A.tar.gz"
fi
wget $url -O $A.tar.gz

echo "Unpacking..."
tar -xzf $A.tar.gz

if [ ! -f $A/plugins/arDominionPlugin/css/min.css ] ; then
	echo "Fix CSS"
	cp files/min.css $A/plugins/arDominionPlugin/css/
fi

echo "Patching"
patch -d $A -p1 < files/0001-Avoid-requiring-the-PHP-readline-extension.patch
patch -d $A -p1 < files/0002-Instrument-PropelPDO-to-log-all-SQL-queries.patch

echo "Linking..."
rm -f atom-testing
ln -s $A atom-testing

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
