#!/bin/bash

IMAGE=$1
CONTAINER_NAME="hello-world-app"

echo "Deploying $IMAGE..."

# Login to ECR
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 221082195621.dkr.ecr.ap-south-1.amazonaws.com

# Stop and remove old container (if exists)
docker stop $CONTAINER_NAME || true
docker rm $CONTAINER_NAME || true

# Pull and run the latest image
docker pull $IMAGE
docker run -d --name $CONTAINER_NAME -p 5000:5000 $IMAGE

echo "✅ Deployment successful!"
