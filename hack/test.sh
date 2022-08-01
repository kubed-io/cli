#!/usr/bin/env bash

yq e 'select(.kind == "ConfigMap").data.STUFF |= "junk"' $1
