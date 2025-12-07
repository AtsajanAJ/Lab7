#!/bin/bash

# Build and Push Script for Clicker App
# Usage: ./build-and-push.sh <username> <tag>

USERNAME=${1:-your_username}
TAG=${2:-v1}

echo "🔨 Building and pushing Docker images..."
echo "Username: $USERNAME"
echo "Tag: $TAG"
echo ""

# Build and push Frontend
echo "📦 Building clicker-frontend..."
cd clicker-frontend
docker build -t ${USERNAME}/clicker-frontend:${TAG} -f Dockerfile.production .
docker push ${USERNAME}/clicker-frontend:${TAG}
cd ..

# Build and push Backend
echo "📦 Building clicker-backend..."
cd clicker-backend
docker build -t ${USERNAME}/clicker-backend:${TAG} -f Dockerfile.production .
docker push ${USERNAME}/clicker-backend:${TAG}
cd ..

# Build and push Plugin P1
echo "📦 Building clicker-plugin P1..."
cd clicker-plugin-P1
docker build -t ${USERNAME}/clicker-plugin:P1 -f Dockerfile.production .
docker push ${USERNAME}/clicker-plugin:P1
cd ..

# Build and push Plugin P2
echo "📦 Building clicker-plugin P2..."
cd clicker-plugin-P2
docker build -t ${USERNAME}/clicker-plugin:P2 -f Dockerfile.production .
docker push ${USERNAME}/clicker-plugin:P2
cd ..

echo ""
echo "✅ All images built and pushed successfully!"
echo ""
echo "Images:"
echo "  - ${USERNAME}/clicker-frontend:${TAG}"
echo "  - ${USERNAME}/clicker-backend:${TAG}"
echo "  - ${USERNAME}/clicker-plugin:P1"
echo "  - ${USERNAME}/clicker-plugin:P2"

