#!/usr/bin/env bash

kubectl apply -f deployment-nginx.yaml
kubectl apply -f svc-nginx.yaml

# Curl to any node
curl http://[public ip]:30080

# Connect to any node
ssh ...

# Find your cluster ip service
sudo iptables -t nat -L KUBE-SERVICES

# Find node port listening
sudo netstat -ntpl