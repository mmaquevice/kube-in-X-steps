#!/usr/bin/env bash

kubectl apply -f job-basic.yaml

kubectl apply -f job-completions.yaml

kubectl apply -f job-completions-parallelism.yaml

kubectl apply -f job-deadline.yaml

kubectl apply -f job-backoff.yaml
