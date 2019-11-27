#!/usr/bin/env bash

kubectl get serviceAccounts
# => default service account

kubectl get svc
# => kubernetes service to send request to API server

kubectl get secret
# => secret of the service account

kubectl run -i --tty --rm tools-curl --image=giantswarm/tiny-tools
# => run busybox with curl
# in container $> curl https://kubernetes/api
# => no response

# in container $> cd /var/run/secrets/kubernetes.io/serviceaccount
# in container $> ls

# => service account related files
# in container $> CA_CERT=/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
# in container $> TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
# in container $> NAMESPACE=$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace)
# in container $> curl --cacert $CA_CERT -H "Authorization: Bearer $TOKEN" "https://kubernetes/api/v1/namespaces/$NAMESPACE/services/"
# => 403

kubectl create rolebinding default-view \
  --clusterrole=view \
  --serviceaccount=default:default \
  --namespace=default

# in container $> curl --cacert $CA_CERT -H "Authorization: Bearer $TOKEN" "https://kubernetes/api/v1/namespaces/$NAMESPACE/services/"
# => OK