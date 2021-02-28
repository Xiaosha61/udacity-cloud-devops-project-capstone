#!/usr/bin/env bash

# define my docker repo
dockerhubrepo=xiaoshax/dummy_node_service

# authenticate
docker login

# tag the image
docker tag dummy_node_service:latest $dockerhubrepo

# push the image
docker push $dockerhubrepo