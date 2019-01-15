# kube-in-X-steps

## Prerequisites

#### Install kubectl

###### Ubuntu

```
  sudo apt-get update && sudo apt-get install -y apt-transport-https
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
  echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
  sudo apt-get update
  sudo apt-get install -y kubectl
```

###### macOS

```
brew install kubernetes-cli
```

#### Install helm

###### Ubuntu

```
wget https://storage.googleapis.com/kubernetes-helm/helm-v2.11.0-linux-amd64.tar.gz
tar -zxvf helm-v2.11.0-linux-amd64.tgz
mv linux-amd64/helm /usr/local/bin/helm
```

###### macOS

```
wget https://storage.googleapis.com/kubernetes-helm/helm-v2.11.0-darwin-amd64.tar.gz
tar -zxvf helm-v2.11.0-darwin-amd64.tar.gz
mv darwin-amd64/helm /usr/local/bin/helm
```