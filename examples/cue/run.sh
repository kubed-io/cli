#!/usr/bin/env bash

kubectl build ../kompose | \
cue import -f --list -l '"items"' yaml: - | \
cue eval -p 'foo' ./*.cue - | cue import -


