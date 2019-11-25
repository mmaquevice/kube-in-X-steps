#!/usr/bin/env bash

# Pod affinity

kubectl apply -f deployment-pod-affinity-hard.yaml
# => try to create 3 replicas

kubectl apply -f deployment-pod-affinity-soft.yaml
# => create 3 replicas



# Node affinity

kubectl apply -f deployment-node-affinity.yaml
# => Pod pending

kubectl label nodes <your-node-name> kubernetes.io/e2e-az-name=e2e-az1
kubectl get nodes --show-labels

kubectl label nodes <another-node-name> kubernetes.io/e2e-az-name=e2e-az1
kubectl label nodes <another-node-name> another-node-label-key=another-node-label-value
# => Has the pod changed node ?

kubectl delete -f deployment-node-affinity.yaml
kubectl apply -f deployment-node-affinity.yaml
# => Has the pod changed node ?