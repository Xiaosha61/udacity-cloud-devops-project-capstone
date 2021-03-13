#!/bin/bash

eksctl create cluster \
--name capstone1 \
--version 1.19 \
--region=us-west-2 \
--node-type t3.medium \
--nodes 3 \
--nodes-min 1 \
--nodes-max 4 \
--kubeconfig=./eksctl/config \
--managed

eksctl get cluster --name=capstone1