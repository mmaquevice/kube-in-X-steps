#!/usr/bin/env bash

helm upgrade --install nginx nginx -f nginx/values.yaml

kubectl get pods

# Update image version in values.yaml
helm upgrade --install nginx nginx -f nginx/values.yaml
# => conf is updated

helm history nginx

helm rollback nginx 1