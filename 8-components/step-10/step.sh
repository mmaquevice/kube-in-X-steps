#!/usr/bin/env bash

set -x

source ./variables.sh

# Data Encryption

kubectl create secret generic kubernetes-the-hard-way \
  --from-literal="mykey=mydata"


ssh -i ~/.ssh/formation formation@${controllerExternalIps["controller-${CLUSTER_ID}-0"]} "sudo ETCDCTL_API=3 etcdctl get \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/etcd/ca.pem \
  --cert=/etc/etcd/kubernetes.pem \
  --key=/etc/etcd/kubernetes-key.pem \
  /registry/secrets/default/kubernetes-the-hard-way | hexdump -C"

# Deployments

kubectl create deployment nginx --image=nginx
sleep 30
kubectl get pods -l app=nginx

### Port Forwarding

POD_NAME=$(kubectl get pods -l app=nginx -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $POD_NAME 8080:80 &
sleep 2
curl --head http://127.0.0.1:8080
pkill -f "kubectl port-forward $POD_NAME 8080:80"

### Logs

kubectl logs $POD_NAME

### Exec

kubectl exec -ti $POD_NAME -- nginx -v

# Services

# set node port
kubectl expose deployment nginx --port 80 --type NodePort

NODE_PORT=$(kubectl get svc nginx \
  --output=jsonpath='{range .spec.ports[0]}{.nodePort}')

for instance in "${!workerExternalIps[@]}"; do
  curl -I http://${workerExternalIps[$instance]}:${NODE_PORT}
done