#!/usr/bin/env bash


selector="topology.kubernetes.io/region=us-east-2,topology.kubernetes.io/zone=us-east-2c"
results=($(kubectl get Subnets -l "$selector" -o custom-columns=":metadata.name" --no-headers))
# echo "${results[@]}"

for each in "${results[@]}";
do
  echo $each
done

