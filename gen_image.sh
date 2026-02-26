#!/bin/bash

APP_VERSION=$1
APP_NAME=bdz-admin-app

if [ -z "$APP_VERSION" ]
then
        echo "Usage: $0 <app_version>"
        exit 1
fi

./gen_version_info.sh $1

docker build . --target prod --tag $APP_NAME:$APP_VERSION

IMG_ID=$(docker image ls $APP_NAME:$APP_VERSION --format json |sed -e 's/^.*ID":"//;s/".*$//')

docker tag $IMG_ID bdz-admin-app:latest
