#!/bin/sh

set -e
set -u

. /etc/sysconfig/elasticsearch

: ${CONF_FILE:="/var/local/elasticsearch/etc/elasticsearch/elasticsearch.yml"}

grep "CONFIGURED" $CONF_FILE && exit 1

echo "Applying CCeH configuration"

echo "cluster.name: cceh" >> $CONF_FILE
echo "discovery.zen.ping.multicast.enabled: false" >> $CONF_FILE

# See http://www.cve.mitre.org/cgi-bin/cvename.cgi?name=2014-3120
echo "script.disable_dynamic: true" >> $CONF_FILE

echo "# ALREADY CONFIGURED" >> $CONF_FILE
