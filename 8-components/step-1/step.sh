#!/usr/bin/env bash

# Prerequiresites

# Download and install cfssl and cfssljson

wget -q --show-progress --https-only --timestamping \
  https://storage.googleapis.com/kubernetes-the-hard-way/cfssl/linux/cfssl \
  https://storage.googleapis.com/kubernetes-the-hard-way/cfssl/linux/cfssljson

chmod +x cfssl cfssljson

sudo mv cfssl cfssljson /usr/local/bin/

# Verify cfssl and cfssljson version 1.3.4 or higher is installed

cfssl version

cfssljson --version

# Install kubectl

wget https://storage.googleapis.com/kubernetes-release/release/v1.15.3/bin/linux/amd64/kubectl

chmod +x kubectl

sudo mv kubectl /usr/local/bin/

# Verify kubectl installation

kubectl version --client