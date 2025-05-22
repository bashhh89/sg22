#!/bin/bash

# Client Setup Script for AI Scorecard
# Just run this script to set up the application

echo -e "\e[36mAI Scorecard - Client Setup Script\e[0m"
echo -e "\e[36m==================================\e[0m"
echo ""

# Check if Node.js is installed
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo -e "\e[32m✓ Node.js $NODE_VERSION is installed\e[0m"
else
    echo -e "\e[31m✗ Node.js is not installed. Please install Node.js 18.x or later.\e[0m"
    exit 1
fi

# Check if PNPM is installed
if command -v pnpm &> /dev/null; then
    PNPM_VERSION=$(pnpm --version)
    echo -e "\e[32m✓ PNPM $PNPM_VERSION is installed\e[0m"
else
    echo -e "\e[33m✗ PNPM is not installed. Installing...\e[0m"
    npm install -g pnpm
    if [ $? -eq 0 ]; then
        echo -e "\e[32m✓ PNPM installed successfully\e[0m"
    else
        echo -e "\e[31m✗ Failed to install PNPM. Please install it manually: npm install -g pnpm\e[0m"
        exit 1
    fi
fi

# Kill any processes running on port 3006
echo -e "\e[33mChecking if port 3006 is in use...\e[0m"
PORT_PROCESS=$(lsof -i :3006 -t 2>/dev/null)
if [ -n "$PORT_PROCESS" ]; then
    echo -e "\e[33mPort 3006 is in use. Attempting to close process...\e[0m"
    kill -9 $PORT_PROCESS 2>/dev/null
    echo -e "\e[32m✓ Process using port 3006 has been terminated\e[0m"
else
    echo -e "\e[32m✓ Port 3006 is available\e[0m"
fi

# Create logs directory if it doesn't exist
if [ ! -d "logs" ]; then
    echo -e "\e[33mCreating logs directory...\e[0m"
    mkdir -p logs
    echo -e "\e[32m✓ Logs directory created\e[0m"
fi

# Step 1: Install dependencies
echo -e "\e[33mStep 1: Installing dependencies...\e[0m"
pnpm install
if [ $? -eq 0 ]; then
    echo -e "\e[32m✓ Dependencies installed successfully\e[0m"
else
    echo -e "\e[31m✗ Failed to install dependencies\e[0m"
    exit 1
fi

# Step 2: Build the application
echo -e "\e[33mStep 2: Building the application...\e[0m"
pnpm build
if [ $? -eq 0 ]; then
    echo -e "\e[32m✓ Application built successfully\e[0m"
else
    echo -e "\e[31m✗ Build failed\e[0m"
    exit 1
fi

# Step 3: Start the application
echo -e "\e[33mStep 3: Starting the application...\e[0m"
nohup pnpm start > logs/app.log 2>&1 &
if [ $? -eq 0 ]; then
    echo -e "\e[32m✓ Application started successfully\e[0m"
    echo -e "\e[36mYour application is now running on http://localhost:3006\e[0m"
else
    echo -e "\e[31m✗ Failed to start the application\e[0m"
    exit 1
fi

echo ""
echo -e "\e[32m✓ Setup completed successfully!\e[0m"
echo -e "To check the application logs: cat logs/app.log"
echo -e "To stop the application: pkill -f 'pnpm start'" 