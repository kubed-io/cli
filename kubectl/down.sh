#!/usr/bin/env bash
set -e

kubectl build "$@" | kubectl delete -f -