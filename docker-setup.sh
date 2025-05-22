#!/bin/bash

# Docker Setup Script for AI Scorecard (Linux)
# This script will set up and run the AI Scorecard application using Docker

# Text formatting
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${CYAN}AI Scorecard - Docker Setup Script${NC}"
echo -e "${CYAN}=================================${NC}"
echo ""

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if a port is in use
port_in_use() {
    if command_exists lsof; then
        lsof -i:"$1" >/dev/null 2>&1
        return $?
    elif command_exists netstat; then
        netstat -tuln | grep ":$1 " >/dev/null 2>&1
        return $?
    else
        echo -e "${YELLOW}Warning: Cannot check if port $1 is in use (lsof/netstat not available)${NC}"
        return 1
    fi
}

# Check if Docker is installed
if command_exists docker; then
    DOCKER_VERSION=$(docker --version)
    echo -e "${GREEN}✓ $DOCKER_VERSION is installed${NC}"
else
    echo -e "${RED}✗ Docker is not installed. Please install Docker from https://docs.docker.com/get-docker/${NC}"
    exit 1
fi

# Check if Docker Compose is installed
if command_exists docker-compose; then
    COMPOSE_VERSION=$(docker-compose --version)
    echo -e "${GREEN}✓ Docker Compose is installed${NC}"
elif docker compose version >/dev/null 2>&1; then
    echo -e "${GREEN}✓ Docker Compose plugin is installed${NC}"
    # Create an alias for compatibility
    alias docker-compose="docker compose"
else
    echo -e "${RED}✗ Docker Compose is not installed. Please install it from https://docs.docker.com/compose/install/${NC}"
    exit 1
fi

# Check if Docker is running
if docker info >/dev/null 2>&1; then
    echo -e "${GREEN}✓ Docker is running${NC}"
else
    echo -e "${RED}✗ Docker is not running. Please start the Docker service.${NC}"
    exit 1
fi

# Check if port 3006 is in use
if port_in_use 3006; then
    echo -e "${RED}✗ Port 3006 is already in use. Please free up this port before continuing.${NC}"
    exit 1
else
    echo -e "${GREEN}✓ Port 3006 is available${NC}"
fi

# Create logs directory if it doesn't exist
if [ ! -d "logs" ]; then
    echo -e "${YELLOW}Creating logs directory...${NC}"
    mkdir -p logs
    echo -e "${GREEN}✓ Logs directory created${NC}"
fi

# Step 1: Stop any existing containers with the same name
echo -e "${YELLOW}Step 1: Cleaning up any existing containers...${NC}"
docker-compose down >/dev/null 2>&1
echo -e "${GREEN}✓ Cleanup completed${NC}"

# Step 2: Build and start the Docker container
echo -e "${YELLOW}Step 2: Building and starting the Docker container...${NC}"
if docker-compose up -d --build; then
    echo -e "${GREEN}✓ Docker container built and started successfully${NC}"
else
    echo -e "${RED}✗ Failed to build and start Docker container${NC}"
    echo -e "${YELLOW}Showing logs for debugging:${NC}"
    docker-compose logs
    exit 1
fi

# Step 3: Wait for the application to be ready
echo -e "${YELLOW}Step 3: Waiting for the application to be ready...${NC}"
MAX_RETRIES=30
RETRY_INTERVAL=2
RETRY_COUNT=0
SERVER_IP=$(hostname -I | awk '{print $1}')

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if curl -s -o /dev/null -w "%{http_code}" http://localhost:3006 | grep -q "200\|304"; then
        echo -e "${GREEN}✓ Application is running successfully${NC}"
        break
    else
        if [ $RETRY_COUNT -eq 0 ]; then
            echo -e "${YELLOW}Waiting for application to start...${NC}"
        else
            echo -n "."
        fi
        RETRY_COUNT=$((RETRY_COUNT + 1))
        sleep $RETRY_INTERVAL
    fi

    # If we've reached max retries, show an error
    if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
        echo -e "\n${RED}✗ Application did not start properly within the expected time.${NC}"
        echo -e "${YELLOW}Container logs:${NC}"
        docker-compose logs
        echo -e "\n${YELLOW}Troubleshooting steps:${NC}"
        echo "1. Check if port 3006 is open in your firewall: sudo ufw allow 3006/tcp"
        echo "2. Verify Docker container is running: docker ps"
        echo "3. Check container logs: docker-compose logs"
        exit 1
    fi
done

# Check if the server has a public IP
if [ -n "$SERVER_IP" ] && [ "$SERVER_IP" != "127.0.0.1" ]; then
    # Try to access the application using the server's IP
    if curl -s -o /dev/null -w "%{http_code}" http://$SERVER_IP:3006 | grep -q "200\|304"; then
        echo -e "${GREEN}✓ Application is also accessible via server IP: http://$SERVER_IP:3006${NC}"
    else
        echo -e "${YELLOW}! Application may not be accessible via server IP: http://$SERVER_IP:3006${NC}"
        echo -e "${YELLOW}  This could be due to firewall settings. Try: sudo ufw allow 3006/tcp${NC}"
    fi
fi

echo ""
echo -e "${GREEN}✓ Setup completed successfully!${NC}"
echo -e "${CYAN}Your application is now running on:${NC}"
echo -e "${CYAN}  - Local: http://localhost:3006${NC}"
if [ -n "$SERVER_IP" ] && [ "$SERVER_IP" != "127.0.0.1" ]; then
    echo -e "${CYAN}  - Server IP: http://$SERVER_IP:3006${NC}"
fi
echo -e "${CYAN}  (Docker container port 3000 is mapped to host port 3006)${NC}"
echo ""
echo -e "${CYAN}Useful Docker commands:${NC}"
echo "- To view logs: docker-compose logs -f"
echo "- To stop the application: docker-compose down"
echo "- To restart the application: docker-compose restart"
echo ""
echo -e "${YELLOW}IMPORTANT:${NC} If you cannot access the application via server IP, ensure port 3006 is open in your firewall:"
echo "  sudo ufw allow 3006/tcp"
echo "  sudo ufw status" 