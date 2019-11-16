#!/usr/bin/env bash

# Run pause container
docker run -d --name pause -p 8080:80 gcr.io/google_containers/pause-amd64:3.0

# Run app container
docker run -d --name nginx --net=container:pause --pid=container:pause nginx

# What if:
# You connect to localhost:8080?
# You stop pause container?
