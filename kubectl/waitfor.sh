#!/usr/bin/env bash
set -e

while : ; do
  res="$(kubectl get "$@" 2>&1)" && break
  sleep 5
done

