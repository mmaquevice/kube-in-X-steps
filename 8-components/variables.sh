#!/usr/bin/env bash

export CLUSTER_ID="1"

declare -A workerExternalIps=( ["worker-${CLUSTER_ID}-0"]="34.89.243.148"\
                         ["worker-${CLUSTER_ID}-1"]="34.89.144.214"\
                         ["worker-${CLUSTER_ID}-2"]="35.242.229.168")

declare -A workerInternalIps=( ["worker-${CLUSTER_ID}-0"]="10.240.0.20"\
                         ["worker-${CLUSTER_ID}-1"]="10.240.0.21"\
                         ["worker-${CLUSTER_ID}-2"]="10.240.0.22")

declare -A controllerExternalIps=( ["controller-${CLUSTER_ID}-0"]="34.89.221.185"\
                         ["controller-${CLUSTER_ID}-1"]="35.198.179.49"\
                         ["controller-${CLUSTER_ID}-2"]="34.89.179.221")

export KUBERNETES_PUBLIC_ADDRESS="35.246.200.36"