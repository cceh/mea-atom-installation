#!/bin/sh

set -e
set -u

. /etc/sysconfig/elasticsearch

CONF_FILE=/var/local/elasticsearch/etc/elasticsearch/elasticsearch.yml

grep "CONFIGURED" $CONF_FILE && exit 1

echo "Applying CCeH configuration"

echo "discovery.zen.ping.multicast.enabled: false" >> $CONF_FILE
echo "# ALREADY CONFIGURED" >> $CONF_FILE
