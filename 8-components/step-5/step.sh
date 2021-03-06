#!/usr/bin/env bash

set -x

source ./variables.sh

# run ssh root@MachineB 'echo "rootpass" | sudo -Sv && bash -s' < local_script.sh
for instance in "${!controllerExternalIps[@]}"; do
  ssh -i ~/.ssh/formation formation@${controllerExternalIps[$instance]} 'bash -s' < step-5/controller-etcd.sh 1
done

