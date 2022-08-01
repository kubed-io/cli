#!/usr/bin/env bash
set -e

project=$1
shift

kubectl kustom ctx "$project"
kustomize build \
  --enable-alpha-plugins \
  --enable-helm \
  --enable-exec \
  "$@" \
  "$project" | yq e - -P