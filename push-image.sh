#!/bin/bash

REPO_NAME="soulteary/prebuilt-nginx-modules"
RELEASE_DIR="./modules";

for moduleName in $RELEASE_DIR/*; do
    set -a
        . "$moduleName/.env"
    set +a

    tag=$(echo $moduleName | cut -b 11-);

    if [ -f "$moduleName/Dockerfile.alpine" ]; then
        BUILD_NAME="$REPO_NAME:$tag-$NGINX_VERSION-alpine"
        if [[ "$(docker images -q $BUILD_NAME 2> /dev/null)" != "" ]]; then
            echo "Push: $BUILD_NAME";
            docker push $BUILD_NAME;
        fi
    fi

    if [ -f "$moduleName/Dockerfile.debian" ]; then
        BUILD_NAME="$REPO_NAME:$tag-$NGINX_VERSION"
        if [[ "$(docker images -q $BUILD_NAME 2> /dev/null)" != "" ]]; then
            echo "Push: $BUILD_NAME";
            docker push $BUILD_NAME;
        fi
    fi

done
