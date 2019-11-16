#!/usr/bin/env bash

# Create the deployment
kubectl apply -f deployment-v1.yaml

# Follow the rollout status
kubectl rollout status deployment nginx-deployment

# Find the replicasets
kubectl get rs
# => name is dynamic

# Update the app
kubectl apply -f deployment-v2.yaml

# Follow the rollout status
kubectl rollout status deployment nginx-deployment

# Watch the replicasets
kubectl get rs -w