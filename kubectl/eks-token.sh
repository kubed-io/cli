#!/usr/bin/env bash

aws eks get-token $@ | jq '.apiVersion = "client.authentication.k8s.io/v1beta1"'
