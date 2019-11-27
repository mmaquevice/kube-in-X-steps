#!/usr/bin/env bash

set -x

source ./variables.sh

# Prerequiresites
#bash step-1/step.sh

# TLS certificates
bash step-2/step.sh

# Generating Kubernetes Configuration Files for Authentication
bash step-3/step.sh

# Generating the Data Encryption Config and Key
bash step-4/step.sh

# Bootstrapping the etcd Cluster
bash step-5/step.sh

# Bootstrapping the Kubernetes Control Plane
bash step-6/step.sh

# Bootstrapping the Kubernetes Worker Nodes
bash step-7/step.sh

# Configuring kubectl for Remote Access
bash step-8/step.sh

# Deploying the DNS Cluster Add-on
bash step-9/step.sh

# Smoke Test
bash step-10/step.sh

