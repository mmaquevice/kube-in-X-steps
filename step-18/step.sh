#!/usr/bin/env bash

kubectl apply -f deployment-cpu.yaml

# Wait metrics to be available
kubectl top pods
# => CPU is capped

kubectl apply -f deployment-ram.yaml
kubectl describe pod stress-[pod id]
# => OOMKilled

kubectl apply -f deployment-burstable.yaml
kubectl apply -f deployment-guaranteed.yaml

kubectl describe pod [pod name] | grep -i "QoS Class"

