#!/usr/bin/env bash

set -e

all_items=$(kubectl get-all ${@} -o name 2> /dev/null)

kubectl get ${target_kind} -o name | \
	sed -e 's/.*\///g' | \
	xargs -I {} kubectl patch ${target_kind} {} --type=json \
	-p='[{"op": "remove", "path": "/metadata/finalizers/0"}]'