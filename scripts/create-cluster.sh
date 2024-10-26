#! /bin/bash

# Hardcoded values
CLUSTER_NAME="project3-udacity"
REGION="us-east-1"
PROFILE="udacity"

eksctl create cluster --name "$CLUSTER_NAME" --region "$REGION" --nodes-min=2 --nodes-max=3 --profile "$PROFILE"
aws eks update-kubeconfig --region "$REGION" --name "$CLUSTER_NAME" --profile "$PROFILE"
