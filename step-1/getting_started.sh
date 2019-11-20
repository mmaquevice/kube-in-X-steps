#!/usr/bin/env bash

# 3 Management techniques
# Imperative commands: Live objects
# Imperative object: configuration Individual files
# Declarative object: configuration	Directories of files

# Imperative commands
kubectl run nginx --image nginx
kubectl delete deployment nginx

# Imperative object
kubectl create -f pod.yaml
kubectl delete -f pod.yaml

# Declarative object
kubectl diff -R -f configs/
kubectl apply -R -f configs/
