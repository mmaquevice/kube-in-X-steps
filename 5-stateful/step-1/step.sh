#!/usr/bin/env bash

kubectl apply -f pod-volume-hostPath.yaml

kubectl exec -it pod-volume-host-path bash
# in container $> cd /test-pd
# in container $> ls

kubectl apply -f pod-volume-gce.yaml
kubectl exec -it pod-volume-gce bash
# in container $> cd /test-pd
# in container $> echo "key=value" > myData.conf

kubectl delete -f pod-volume-gce.yaml
kubectl apply -f pod-volume-gce.yaml
kubectl exec -it pod-volume-gce bash
# in container $> cd /test-pd
# in container $> cat myData.conf