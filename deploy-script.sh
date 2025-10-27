#!/bin/bash
set -e

IMAGE="$1"
CONTAINER="hello-world-container"

echo "Deploying $IMAGE..."

docker stop $CONTAINER 2>/dev/null || true
docker rm $CONTAINER 2>/dev/null || true

$(aws ecr get-login --no-include-email --region ap-south-1)
docker pull $IMAGE
docker run -d --name $CONTAINER -p 8080:8080 --restart unless-stopped $IMAGE

echo "✅ Deployment complete!"

