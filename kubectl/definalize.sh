#!/usr/bin/env bash

set -e

target_kind=$1

kubectl get ${target_kind} -o name | \
	sed -e 's/.*\///g' | \
	xargs -I {} kubectl patch ${target_kind} {} --type=json \
	-p='[{"op": "remove", "path": "/metadata/finalizers/0"}]'