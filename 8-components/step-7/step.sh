#!/usr/bin/env bash

source ./variables.sh

# Provisioning a Kubernetes Worker Node

for instance in "${!workerExternalIps[@]}"; do
  ssh -i ~/.ssh/formation formation@${workerExternalIps[$instance]} 'bash -s' < step-7/worker.sh
done

# Verification

ssh -i ~/.ssh/formation formation@${workerExternalIps["worker-0"]} 'kubectl get nodes --kubeconfig admin.kubeconfig'