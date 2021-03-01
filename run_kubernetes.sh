#!/usr/bin/env bash

# This tags and uploads an image to Docker Hub

# Step 1:
# This is your Docker ID/path
# dockerhubrepo=<>
dockerhubrepo=xiaoshax/dummy_node_service

# Step 2
# Run the Docker Hub container with kubernetes
kubectl run my-capstone-pod --image=$dockerhubrepo --port=3000

# Step 3:
# List kubernetes pods
kubectl get pods

# Step 4:
# Forward the container port to a host
kubectl port-forward my-capstone-pod 8000:3000