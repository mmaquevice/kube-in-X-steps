#!/usr/bin/env bash

kubectl apply -f deployment-nginx.yaml

# Find on which node nginx is running:
kubectl get pods -o wide

# Connect to this node
ssh ...

# Find pause container
docker ps

# Find PID of pause container
docker inspect --format '{{ .State.Pid }}' container-id-or-name

# Find IP
nsenter -t your-container-pid -n ip addr

# => same as "kubectl get pods -o wide"
# Kubelet configure pod ips based on its network plugin