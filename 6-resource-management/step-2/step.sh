#!/usr/bin/env bash

kubectl apply -f resource-quota.yaml

kubectl get resourcequota object-quota-demo --output=yaml

kubectl apply -f pvc-1.yaml
# => Success

kubectl apply -f pvc-2.yaml
# => Failed