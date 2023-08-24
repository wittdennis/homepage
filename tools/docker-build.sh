#!/bin/bash

SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")

CONTAINER_CMD="docker"
LOCAL_REGISTRY="N"
if [ -x "$(command -v podman)" ]; then
    CONTAINER_CMD=$(command -v podman)
    LOCAL_REGISTRY="Y"
fi

REPOSITORY_NAME="local/homepage"
TAG="latest"

$CONTAINER_CMD build -t $REPOSITORY_NAME:$TAG -f "$SCRIPT_PATH/../Dockerfile" "$SCRIPT_PATH/.."
if [ $LOCAL_REGISTRY=="Y" ]; then
    $CONTAINER_CMD tag $REPOSITORY_NAME:$TAG localhost:5000/$REPOSITORY_NAME:$TAG
    $CONTAINER_CMD push localhost:5000/$REPOSITORY_NAME:$TAG
fi