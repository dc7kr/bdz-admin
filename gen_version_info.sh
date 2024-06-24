#!/bin/bash

if [ -z "$1" ]
then
	echo "Usage: $0 <docker image version>"
	exit 1
fi

VERSION_CONF=config/version.yml

VER=$(git describe --dirty --abbrev=6 --always)

echo "version_info:" > $VERSION_CONF
echo "  current: \"$VER\"" >> $VERSION_CONF
echo "  image: \"$1\"" >>$VERSION_CONF

git log --abbrev-commit --max-count=10 >changelog.txt

realpath $VERSION_CONF
