#!/usr/bin/env bash

source ./variables.sh

# Provision the Kubernetes Control Plane

# run ssh root@MachineB 'echo "rootpass" | sudo -Sv && bash -s' < local_script.sh
for instance in "${!controllerExternalIps[@]}"; do
  ssh -i ~/.ssh/formation formation@${controllerExternalIps[$instance]} 'bash -s' < step-6/controller-plane.sh
done

# RBAC for Kubelet Authorization

ssh -i ~/.ssh/formation formation@${controllerExternalIps["controller-0"]} 'bash -s' < step-6/rbac-apiserver-to-kubelet.sh

# Check the Kubernetes Frontend Load Balancer

curl --cacert ca.pem https://${KUBERNETES_PUBLIC_ADDRESS}:6443/version