#!/usr/bin/env bash

kubectl apply -f configmap.yaml
kubectl apply -f secret.yaml
kubectl apply -f pod.yaml

kubectl logs pod-envs

kubectl create configmap my-config-from-file --from-file=my-file.properties
kubectl get configmap my-config-from-file -o yaml

kubectl create configmap my-config-from-env-file --from-env-file=my-file.properties
kubectl get configmap my-config-from-env-file -o yaml

kubectl apply -f pod-volume.yaml
kubectl logs pod-config-volume