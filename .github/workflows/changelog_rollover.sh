#!/bin/sh
set -e

FILE=$1
TAG=$2
VERSION=$3

DATE=$(date +%F)

sed -i \
  -e 's/## Unreleased/## Unreleased\n\n## '$VERSION' - '$DATE'/' \
  -e 's/\.\.\.HEAD/...'$TAG'/' \
  -e 's/\[Unreleased\]/[Unreleased]: https:\/\/github.com\/eighty4\/libtab\/compare\/'$TAG'...HEAD\n['$VERSION']/' \
  "$FILE"
