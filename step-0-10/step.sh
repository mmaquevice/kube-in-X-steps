#!/usr/bin/env bash

kubectl apply -f deployment-nginx.yaml
kubectl apply -f svc-nginx.yaml

# Find on which node nginx is running:
kubectl get pods -o wide

# Connect to this node
ssh ...

# Find your cluster ip service
iptables -t nat -L KUBE-SERVICES