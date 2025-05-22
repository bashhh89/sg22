#!/bin/bash

# Docker Setup Script for AI Scorecard (Linux/Mac)
# This script will set up and run the AI Scorecard application using Docker

echo -e "\e[36mAI Scorecard - Docker Setup Script\e[0m"
echo -e "\e[36m=================================\e[0m"
echo ""

# Check if Docker is installed
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version)
    echo -e "\e[32m✓ $DOCKER_VERSION is installed\e[0m"
else
    echo -e "\e[31m✗ Docker is not installed. Please install Docker from https://docs.docker.com/get-docker/\e[0m"
    exit 1
fi

# Check if Docker Compose is installed
if command -v docker-compose &> /dev/null; then
    COMPOSE_VERSION=$(docker-compose --version)
    echo -e "\e[32m✓ Docker Compose is installed\e[0m"
else
    echo -e "\e[31m✗ Docker Compose is not installed. Please install it from https://docs.docker.com/compose/install/\e[0m"
    exit 1
fi

# Check if Docker is running
if docker info &> /dev/null; then
    echo -e "\e[32m✓ Docker is running\e[0m"
else
    echo -e "\e[31m✗ Docker is not running. Please start the Docker service.\e[0m"
    exit 1
fi

# Create logs directory if it doesn't exist
if [ ! -d "logs" ]; then
    echo -e "\e[33mCreating logs directory...\e[0m"
    mkdir -p logs
    echo -e "\e[32m✓ Logs directory created\e[0m"
fi

# Step 1: Build and start the Docker container
echo -e "\e[33mStep 1: Building and starting the Docker container...\e[0m"
if docker-compose up -d --build; then
    echo -e "\e[32m✓ Docker container built and started successfully\e[0m"
else
    echo -e "\e[31m✗ Failed to build and start Docker container\e[0m"
    exit 1
fi

# Step 2: Check if the application is running
echo -e "\e[33mStep 2: Checking if the application is running...\e[0m"
sleep 5  # Give the container a few seconds to start
if curl -s -o /dev/null -w "%{http_code}" http://localhost:3006 | grep -q "200"; then
    echo -e "\e[32m✓ Application is running successfully\e[0m"
else
    echo -e "\e[33m! Could not connect to the application. It might still be starting up.\e[0m"
    echo -e "\e[33m  Try accessing http://localhost:3006 in your browser in a few moments.\e[0m"
fi

echo ""
echo -e "\e[32m✓ Setup completed successfully!\e[0m"
echo -e "\e[36mYour application is now running on http://localhost:3006\e[0m"
echo ""
echo -e "\e[36mUseful Docker commands:\e[0m"
echo "- To view logs: docker-compose logs -f"
echo "- To stop the application: docker-compose down"
echo "- To restart the application: docker-compose restart" 