#!/usr/bin/env bash
set -e

kubectl build "$@" | kubectl apply -f -