#!/usr/bin/env bash

## Complete the following steps to get Docker running locally

# Step 1:
# Build image and add a descriptive tag
docker build -t dummy_node_service .

# Step 2: 
# List docker images
docker image ls | grep dummy_node_service

# Step 3: 
# Start a docker container to run the service
docker run --name dummy_node_service -p 8080:3000 -d dummy_node_service

# Test it by sending a request and check server logs
# curl -s http://localhost:8080
# docker logs -f dummy_node_service