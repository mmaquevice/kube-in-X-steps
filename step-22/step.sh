#!/usr/bin/env bash

#kubectl taint nodes nodename key=value:effect
kubectl taint nodes <your-node-name> not-for-you=true:NoSchedule

kubectl apply -f deployment.yaml
# => Pod can be schedule to all nodes
# Pods already on tainted node are not modified

kubectl taint nodes <your-node-name> not-for-you-
# => taint removed