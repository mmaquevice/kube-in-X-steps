#!/usr/bin/env bash

# Generate TLS certificates for the following components: etcd, kube-apiserver, kube-controller-manager, kube-scheduler, kubelet, and kube-proxy

# Fill with your ips
declare -A workerExternalIps=( ["worker-0"]="34.89.221.185"\
                         ["worker-1"]="34.89.243.148"\
                         ["worker-2"]="35.242.229.168")

declare -A workerInternalIps=( ["worker-0"]="10.240.0.20"\
                         ["worker-1"]="10.240.0.21"\
                         ["worker-2"]="10.240.0.22")

declare -A controllerExternalIps=( ["controller-0"]="35.246.200.36"\
                         ["controller-1"]="34.89.179.221"\
                         ["controller-2"]="35.198.179.49")

KUBERNETES_PUBLIC_ADDRESS="34.89.144.214"

# Generate the CA configuration file, certificate, and private key

cat > ca-config.json <<EOF
{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "kubernetes": {
        "usages": ["signing", "key encipherment", "server auth", "client auth"],
        "expiry": "8760h"
      }
    }
  }
}
EOF

cat > ca-csr.json <<EOF
{
  "CN": "Kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "Kubernetes",
      "OU": "CA",
      "ST": "Oregon"
    }
  ]
}
EOF

cfssl gencert -initca ca-csr.json | cfssljson -bare ca

# => ca-key.pem
#    ca.pem



# Generate the admin client certificate and private key

cat > admin-csr.json <<EOF
{
  "CN": "admin",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "system:masters",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  admin-csr.json | cfssljson -bare admin

# => admin-key.pem
#    admin.pem



# The Kubelet Client Certificates

for instance in "${!workerExternalIps[@]}"; do
cat > ${instance}-csr.json <<EOF
{
  "CN": "system:node:${instance}",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "system:nodes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF

EXTERNAL_IP=${workerExternalIps[$instance]}

INTERNAL_IP=${workerInternalIps[$instance]}

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=${instance},${EXTERNAL_IP},${INTERNAL_IP} \
  -profile=kubernetes \
  ${instance}-csr.json | cfssljson -bare ${instance}
done

# => worker-0-key.pem
#    worker-0.pem
#    worker-1-key.pem
#    worker-1.pem
#    worker-2-key.pem
#    worker-2.pem



# The Controller Manager Client Certificate

cat > kube-controller-manager-csr.json <<EOF
{
  "CN": "system:kube-controller-manager",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "system:kube-controller-manager",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kube-controller-manager-csr.json | cfssljson -bare kube-controller-manager

# => kube-controller-manager-key.pem
#    kube-controller-manager.pem



# The Kube Proxy Client Certificate

cat > kube-proxy-csr.json <<EOF
{
  "CN": "system:kube-proxy",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "system:node-proxier",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kube-proxy-csr.json | cfssljson -bare kube-proxy

# => kube-proxy-key.pem
#    kube-proxy.pem



# The Scheduler Client Certificate

cat > kube-scheduler-csr.json <<EOF
{
  "CN": "system:kube-scheduler",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "system:kube-scheduler",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kube-scheduler-csr.json | cfssljson -bare kube-scheduler

# => kube-scheduler-key.pem
#    kube-scheduler.pem



# The Kubernetes API Server Certificate

KUBERNETES_HOSTNAMES=kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster,kubernetes.svc.cluster.local

cat > kubernetes-csr.json <<EOF
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "Kubernetes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF

# The Kubernetes API server is automatically assigned the kubernetes internal dns name, which will be linked to the first IP address (10.32.0.1) from the address range (10.32.0.0/24) reserved for internal cluster services
cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=10.32.0.1,10.240.0.10,10.240.0.11,10.240.0.12,${KUBERNETES_PUBLIC_ADDRESS},127.0.0.1,${KUBERNETES_HOSTNAMES} \
  -profile=kubernetes \
  kubernetes-csr.json | cfssljson -bare kubernetes

# => kubernetes-key.pem
#    kubernetes.pem



# The Service Account Key Pair

cat > service-account-csr.json <<EOF
{
  "CN": "service-accounts",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "Kubernetes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  service-account-csr.json | cfssljson -bare service-account

# => service-account-key.pem
#    service-account.pem



# Distribute the Client and Server Certificates

for instance in "${!workerExternalIps[@]}"; do
  scp -i ~/.ssh/formation ca.pem formation@${workerExternalIps[$instance]}:~/
  scp -i ~/.ssh/formation ${instance}-key.pem formation@${workerExternalIps[$instance]}:~/
  scp -i ~/.ssh/formation ${instance}.pem formation@${workerExternalIps[$instance]}:~/
done

for instance in "${!controllerExternalIps[@]}"; do
  scp -i ~/.ssh/formation ca.pem formation@${controllerExternalIps[$instance]}:~/
  scp -i ~/.ssh/formation ca-key.pem formation@${controllerExternalIps[$instance]}:~/
  scp -i ~/.ssh/formation kubernetes-key.pem formation@${controllerExternalIps[$instance]}:~/
  scp -i ~/.ssh/formation kubernetes.pem formation@${controllerExternalIps[$instance]}:~/
  scp -i ~/.ssh/formation service-account-key.pem formation@${controllerExternalIps[$instance]}:~/
  scp -i ~/.ssh/formation service-account.pem formation@${controllerExternalIps[$instance]}:~/
done



# The kube-proxy, kube-controller-manager, kube-scheduler, and kubelet client certificates will be used to generate client authentication configuration files in the next lab.