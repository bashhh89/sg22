# Docker Setup Script for AI Scorecard (Windows)
# This script will set up and run the AI Scorecard application using Docker

Write-Host "AI Scorecard - Docker Setup Script" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan
Write-Host ""

# Check if Docker is installed
try {
    $dockerVersion = docker --version
    Write-Host "✓ $dockerVersion is installed" -ForegroundColor Green
}
catch {
    Write-Host "✗ Docker is not installed. Please install Docker Desktop from https://www.docker.com/products/docker-desktop/" -ForegroundColor Red
    exit 1
}

# Check if Docker Compose is installed
try {
    $dockerComposeVersion = docker-compose --version
    Write-Host "✓ Docker Compose is installed" -ForegroundColor Green
}
catch {
    Write-Host "✗ Docker Compose is not installed. It usually comes with Docker Desktop for Windows." -ForegroundColor Red
    exit 1
}

# Check if Docker is running
try {
    docker info | Out-Null
    Write-Host "✓ Docker is running" -ForegroundColor Green
}
catch {
    Write-Host "✗ Docker is not running. Please start Docker Desktop." -ForegroundColor Red
    exit 1
}

# Create logs directory if it doesn't exist
if (-not (Test-Path -Path "logs")) {
    Write-Host "Creating logs directory..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path "logs" | Out-Null
    Write-Host "✓ Logs directory created" -ForegroundColor Green
}

# Step 1: Build and start the Docker container
Write-Host "Step 1: Building and starting the Docker container..." -ForegroundColor Yellow
try {
    docker-compose up -d --build
    Write-Host "✓ Docker container built and started successfully" -ForegroundColor Green
}
catch {
    Write-Host "✗ Failed to build and start Docker container: $_" -ForegroundColor Red
    exit 1
}

# Step 2: Check if the application is running
Write-Host "Step 2: Checking if the application is running..." -ForegroundColor Yellow
Start-Sleep -Seconds 5  # Give the container a few seconds to start
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3006" -UseBasicParsing -TimeoutSec 5
    if ($response.StatusCode -eq 200) {
        Write-Host "✓ Application is running successfully" -ForegroundColor Green
    }
    else {
        Write-Host "! Application responded with status code $($response.StatusCode)" -ForegroundColor Yellow
    }
}
catch {
    Write-Host "! Could not connect to the application. It might still be starting up." -ForegroundColor Yellow
    Write-Host "  Try accessing http://localhost:3006 in your browser in a few moments." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "✓ Setup completed successfully!" -ForegroundColor Green
Write-Host "Your application is now running on http://localhost:3006" -ForegroundColor Cyan
Write-Host "  (Docker container port 3000 is mapped to host port 3006)" -ForegroundColor Cyan
Write-Host ""
Write-Host "Useful Docker commands:" -ForegroundColor Cyan
Write-Host "- To view logs: docker-compose logs -f" -ForegroundColor White
Write-Host "- To stop the application: docker-compose down" -ForegroundColor White
Write-Host "- To restart the application: docker-compose restart" -ForegroundColor White 