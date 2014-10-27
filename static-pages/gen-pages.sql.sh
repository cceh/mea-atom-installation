#!/bin/bash

set -e
set -u

# elasticsearch-0.9
object_base=382;
slug_base=339;

# elasticsearch 1.3
object_base=388;
slug_base=347;

N=$(ls -1 `dirname $0`/*.html | wc -l)

object_next=$((object_base + N))
slug_next=$((slug_base + N))

echo "ALTER TABLE \`object\` AUTO_INCREMENT=${object_next};"
echo "ALTER TABLE \`slug\` AUTO_INCREMENT=${slug_next};"

idx=0
for page in $(ls -1 `dirname $0`/*.html) ; do
	object_idx=$((object_base + idx))
	slug_idx=$((slug_base + idx))

	slug=$(basename $page .html)
	title=$(cat $page | head -n 1 | sed -e "s/'/''/g")
	content=$(cat $page | tail -n +2 | sed -e "s/'/''/g")
	seconds=$(printf "%02d" "$idx")

	echo

	echo "INSERT INTO \`object\` VALUES ('QubitStaticPage','2014-09-23 02:16:${seconds}','2014-09-23 02:16:${seconds}',${object_idx},0);"
	echo "INSERT INTO \`static_page\` VALUES (${object_idx},'en');"
	echo "INSERT INTO \`static_page_i18n\` VALUES ('${title}','${content}',${object_idx},'en');"

	echo "INSERT INTO \`slug\` VALUES (${object_idx},'${slug}',${slug_idx},0);"
	idx=$((idx + 1))
done
