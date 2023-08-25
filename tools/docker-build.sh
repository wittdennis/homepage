#!/bin/bash

set -e

function join {
  local d=${1-} f=${2-}
  if shift 2; then
    printf %s "$f" "${@/#/$d}"
  fi
}

SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")

CONTAINER_REGISTRY=${CONTAINER_REGISTRY:-"localhost:5000"}
IMAGE_NAME=${IMAGE_NAME:-"homepage"}

ARGS=("$@")
TAGS=()
if [ ${#ARGS[@]} -eq 0 ]; then
    TAGS+=("latest")
else
    for ARG in ${ARGS[@]}; do
        TAGS+=($ARG)
    done
fi
echo $TAGS

REPOSITORY="$CONTAINER_REGISTRY/$IMAGE_NAME"
PLATFORMS=("linux/amd64" "linux/arm/v7" "linux/arm64/v8")

CONTAINER_CMD="docker"
if [ -x "$(command -v podman)" ]; then
    CONTAINER_CMD=$(command -v podman)
fi
echo "Using $CONTAINER_CMD as container runtime"
$CONTAINER_CMD version

MANIFESTS=()
for TAG in ${TAGS[@]}; do
    MANIFESTS+=("$REPOSITORY:$TAG")
done

# build images
for PLATFORM in ${PLATFORMS[@]}; do  
    PLATFORM_TAG=$(echo $PLATFORM | sed 's|/|-|g')
    echo "Building image for platform $PLATFORM using platform tag: $PLATFORM_TAG"

    TAG_OPTIONS=""
    for MANIFEST in ${MANIFESTS[@]}; do
        TAG_OPTIONS+=" -t $MANIFEST-$PLATFORM_TAG"
    done

    $CONTAINER_CMD build \
            --platform "$PLATFORM" $TAG_OPTIONS -f "$SCRIPT_PATH/../Dockerfile" "$SCRIPT_PATH/.."

    for MANIFEST in ${MANIFESTS[@]}; do
        $CONTAINER_CMD push $MANIFEST-$PLATFORM_TAG
    done    
done  

# create manifests
for MANIFEST in ${MANIFESTS[@]}; do
    MANIFEST_IMAGES=()
    for PLATFORM in ${PLATFORMS[@]}; do
        PLATFORM_TAG=$(echo $PLATFORM | sed 's|/|-|g')
        MANIFEST_IMAGES+=($MANIFEST-$PLATFORM_TAG)
    done

    MANIFEST_AMENDS=$(join ' --amend ' ${MANIFEST_IMAGES[@]})
    $CONTAINER_CMD manifest rm "$MANIFEST" 2> /dev/null || true
    $CONTAINER_CMD manifest create "$MANIFEST" --amend $MANIFEST_AMENDS

    $CONTAINER_CMD manifest push "$MANIFEST"
done