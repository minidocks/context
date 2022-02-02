#!/bin/sh
set -e

image="${namespace:-minidocks}/context"
versions="
beta;latest
beta-with-fonts;latest;fonts
beta-with-docs;latest;docs
current;current
current-with-fonts;current;fonts
current-with-docs;current;docs
lmtx;lmtx
lmtx-with-fonts;lmtx;fonts
lmtx-with-docs;lmtx;docs
latest;latest
latest-with-fonts;latest;fonts
latest-with-docs;latest;docs
"

build() {
    IFS=" "
    docker buildx build $docker_opts --target="${3:-latest}" --build-arg version="$2" -t "$image:$1" "$(dirname $0)"
}

case "$1" in
    --versions) echo "$versions" | awk 'NF' | cut -d';' -f1;;
    '') echo "$versions" | grep -v "^$" | while read -r version; do IFS=';'; build $version; done;;
    *) args="$(echo "$versions" | grep -E "^$1(;|$)")"; if [ -n "$args" ]; then IFS=';'; build $args; else echo "Version $1 does not exist." >/dev/stderr; exit 1; fi
esac
