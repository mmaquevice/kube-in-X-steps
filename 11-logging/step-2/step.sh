#!/usr/bin/env bash

kubectl apply -f two-files-counter-pod.yaml
kubectl logs -f counter

kubectl apply -f two-files-counter-pod-streaming-sidecar.yaml
kubectl logs counter count-log-1
kubectl logs counter count-log-2