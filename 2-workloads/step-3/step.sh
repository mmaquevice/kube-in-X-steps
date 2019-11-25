#!/usr/bin/env bash

kubectl apply -f daemonset.yaml

# 2 update strategies:
# OnDelete
kubectl apply -f daemonset-ondelete.yaml
# RollingUpdate (default)
kubectl apply -f daemonset-rollingupdate.yaml
