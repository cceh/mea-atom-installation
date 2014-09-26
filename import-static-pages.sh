#!/bin/sh

. "$(dirname $0)/params.sh"

echo "Generating SQL instructions from static HTML files..."
$(dirname $0)/static-pages/gen-pages.sql.sh > $(dirname $0)/static-pages/pages.sql

echo "Adding the static pages to the DB..."
mysql --host "$db_host" \
      --user "$db" -p \
      --default_character_set utf8 \
      "$db" < $(dirname $0)/static-pages/pages.sql
