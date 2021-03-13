#!/bin/bash

eksctl create cluster \
--name capstone \
--version 1.19 \
--region us-west-2a, us-west-2b, us-west-2c \
--node-type t2.small \
--nodes 3 \
--nodes-min 1 \
--nodes-max 4 \
--kubeconfig=./eksctl/config \
--managed

eksctl get cluster --name=capstone