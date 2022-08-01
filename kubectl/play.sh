#!/usr/bin/env bash

# get the file for the play and make sure it exists
PLAYBOOK="$CLUSTER_HOME/plays/${1}.yaml"
shift
if [ ! -f "$PLAYBOOK" ]; then
    echo "$PLAYBOOK does not exist."
    exit 1
fi

ansible-playbook "$PLAYBOOK" "$@" 