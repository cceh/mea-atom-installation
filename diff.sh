#!/bin/sh

A=$(readlink atom-testing)

diff --exclude='cache' -Nur "$A-orig" "$A"
