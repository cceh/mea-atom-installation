#!/bin/sh

set -e
set -u

. "$(dirname $0)/params.sh"

printf "%s" "About to set the default culture of Atom ($version) = '$A' [press ENTER]" ; read enter

printf "%s" "Is the German language set up in Atom? [press ENTER]" ; read enter

cd "$A"

echo "Replacing configuration key in settings.yml..."
sed -e "s/\(default_culture: \+\)en/\1de/" -i.bak apps/qubit/config/settings.yml
sed -e "s#\(default_timezone: \+\)America/Vancouver#\1Europe/Berlin#" -i.bak apps/qubit/config/settings.yml
