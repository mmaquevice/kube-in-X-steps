#!/usr/bin/env bash

# Tutorial based on https://sysdig.com/blog/kubernetes-security-rbac-tls/

# Find your user
kubectl config view

# Create a new user John

### Create a new private key

openssl genrsa -out john.key 2048

### Create a certificate signing request containing the public key and other subject information
openssl req -new -key john.key -out john.csr -subj "/CN=john/O=examplegroup"

### Sign this CSR using the root Kubernetes CA
openssl x509 -req -in john.csr -CA [CA CLUSTER CRT] -CAkey [CA CLUSTER KEY] -CAcreateserial -out john.crt

### Inspect the new certificate
openssl x509 -in john.crt -text

# Create a new user Mary
openssl genrsa -out mary.key 2048
openssl req -new -key mary.key -out mary.csr -subj "/CN=mary/O=examplegroup"
openssl x509 -req -in mary.csr -CA [CA CLUSTER CRT] -CAkey [CA CLUSTER KEY] -CAcreateserial -out mary.crt

# Register the new credentials and config context
kubectl config set-credentials john --client-certificate=[JOHN CRT] --client-key=[JOHN KEY] --embed-certs=true # If you want this file to be portable between hosts you need to embed the certificates inline. You can do this automatically appending the --embed-certs=true parameter to the kubectl config set-credentials command.
kubectl config set-context john@kubernetes --cluster=kubernetes --user=john
kubectl config get-contexts

# Use this context
kubectl config use-context john@kubernetes
kubectl get pods

# Use Admin context and create cluster role binding
kubectl config use-context kubernetes-admin@kubernetes
kubectl create clusterrolebinding examplegroup-admin-binding --clusterrole=cluster-admin --group=examplegroup

# Retry
kubectl config use-context john@kubernetes
kubectl get pods

# Try with Mary
kubectl config set-credentials mary --client-certificate=[MARY CRT] --client-key=[MARY KEY] --embed-certs=true # If you want this file to be portable between hosts you need to embed the certificates inline. You can do this automatically appending the --embed-certs=true parameter to the kubectl config set-credentials command.
kubectl config set-context mary@kubernetes --cluster=kubernetes --user=mary
kubectl config get-contexts
kubectl config use-context mary@kubernetes
kubectl get pods

# It works, why ?
