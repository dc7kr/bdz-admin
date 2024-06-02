#!/bin/bash

APP_VERSION=$1

if [ -z "$APP_VERSION" ]
then
        echo "Usage: $0 <app_version>"
        exit 1
fi

./gen_version_info.sh $1

docker build .  --tag bdz-admin-app:$APP_VERSION

IMG_ID=$(docker image ls bdz-admin-app:$APP_VERSION |tail -1 | awk '{print $3}')

docker tag $IMG_ID bdz-admin-app:latest
