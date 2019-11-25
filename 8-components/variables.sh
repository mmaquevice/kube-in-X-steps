#!/usr/bin/env bash

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