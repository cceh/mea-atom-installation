#!/bin/sh

set -e
set -u

. "$(dirname $0)/params.sh"

img_dir="$A/images/slideshow"

echo "Setting up images and text for the carousel in '$A'..."
mkdir -p "$img_dir"

cp -v $(dirname $0)/carousel/* "$img_dir"
