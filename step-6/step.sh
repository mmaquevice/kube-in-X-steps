#!/usr/bin/env bash

kubectl apply -f deployment-v0.yaml --record=true

# 2 deployment strategies:
# Recreate
kubectl apply -f deployment-v1-recreate.yaml --record=true

# Rolling Update (default)
kubectl apply -f deployment-v2-rolling-update.yaml --record=true

# Watch the pods
kubectl get pods -w

# History
kubectl rollout history deployment nginx-deployment

# Revision Details
kubectl rollout history deployment nginx-deployment --revision=1

# Rolling Back
kubectl rollout undo deployment nginx-deployment --to-revision=1