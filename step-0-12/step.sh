#!/usr/bin/env bash

kubectl apply -f deployment-nginx.yaml
kubectl apply -f svc-nginx.yaml
kubectl apply -f ingress.yaml

kubectl get ingress

curl http://[LB IP]:80
# => default backend

echo "[LB IP]    my-nginx.com" >> /etc/hosts
curl http://my-nginx.com:80
# => OK

kubectl -n support exec -it nginx-ingress-controller-[id pod] -- cat /etc/nginx/nginx.conf
# => conf has been hot reloaded