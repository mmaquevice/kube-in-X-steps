#!/usr/bin/env bash

# Basic logging
kubectl apply -f pod-counter.yaml
kubectl logs -f counter
# => Logs from standard output
