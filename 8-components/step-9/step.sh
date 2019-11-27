#!/usr/bin/env bash

set -x

source ./variables.sh

# The DNS Cluster Add-on

kubectl apply -f step-9/coredns.yaml
kubectl get pods -l k8s-app=kube-dns -n kube-system

# Verification

kubectl run --generator=run-pod/v1 busybox --image=busybox:1.28 --command -- sleep 3600
sleep 20
kubectl get pods -l run=busybox

POD_NAME=$(kubectl get pods -l run=busybox -o jsonpath="{.items[0].metadata.name}")
kubectl exec -ti $POD_NAME -- nslookup kubernetes
