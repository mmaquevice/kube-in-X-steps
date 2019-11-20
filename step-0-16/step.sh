#!/usr/bin/env bash

kubectl apply -f svc-endpoints.yaml
kubectl run -i --rm  --tty busybox --image=busybox -- sh
# in container $> wget http://my-service-with-no-selector

kubectl apply -f svc-external-name.yaml
kubectl run -i --rm  --tty busybox --image=busybox -- sh
# in container $> wget http://my-service-external