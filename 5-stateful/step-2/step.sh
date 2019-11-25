#!/usr/bin/env bash

kubectl apply -f pvc.yaml
kubectl apply -f deployment.yaml

kubectl get pv
kubectl exec -it nginx-volume-[pod id] bash
# in container $> lsblk
# in container $> cd /my-disk
# in container $> echo "toto" > myData.txt
# in container $> exit

kubectl get pods -o wide # find node
kubectl delete pod nginx-volume-[pod id]
kubectl get pods -o wide # find new node => volume must have followed
kubectl exec -it nginx-volume-[new pod id] bash
# in container $> cat /my-disk/myData.txt
