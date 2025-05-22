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
    try {
        $dockerComposeVersion = docker compose version
        Write-Host "✓ Docker Compose plugin is installed" -ForegroundColor Green
        # Create an alias for compatibility
        Set-Alias -Name docker-compose -Value "docker compose"
    }
    catch {
        Write-Host "✗ Docker Compose is not installed. It usually comes with Docker Desktop for Windows." -ForegroundColor Red
        exit 1
    }
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

# Check if port 3006 is in use
try {
    $portInUse = Get-NetTCPConnection -LocalPort 3006 -ErrorAction SilentlyContinue
    if ($portInUse) {
        Write-Host "✗ Port 3006 is already in use. Please free up this port before continuing." -ForegroundColor Red
        exit 1
    }
    else {
        Write-Host "✓ Port 3006 is available" -ForegroundColor Green
    }
}
catch {
    Write-Host "! Unable to check if port 3006 is in use. Continuing anyway..." -ForegroundColor Yellow
}

# Create logs directory if it doesn't exist
if (-not (Test-Path -Path "logs")) {
    Write-Host "Creating logs directory..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path "logs" | Out-Null
    Write-Host "✓ Logs directory created" -ForegroundColor Green
}

# Step 1: Stop any existing containers with the same name
Write-Host "Step 1: Cleaning up any existing containers..." -ForegroundColor Yellow
try {
    docker-compose down 2>$null
    Write-Host "✓ Cleanup completed" -ForegroundColor Green
}
catch {
    Write-Host "! No existing containers to clean up" -ForegroundColor Yellow
}

# Step 2: Build and start the Docker container
Write-Host "Step 2: Building and starting the Docker container..." -ForegroundColor Yellow
try {
    docker-compose up -d --build
    Write-Host "✓ Docker container built and started successfully" -ForegroundColor Green
}
catch {
    Write-Host "✗ Failed to build and start Docker container: $_" -ForegroundColor Red
    Write-Host "Showing logs for debugging:" -ForegroundColor Yellow
    docker-compose logs
    exit 1
}

# Step 3: Wait for the application to be ready
Write-Host "Step 3: Waiting for the application to be ready..." -ForegroundColor Yellow
$maxRetries = 30
$retryInterval = 2
$retryCount = 0

while ($retryCount -lt $maxRetries) {
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:3006" -UseBasicParsing -TimeoutSec 5
        if ($response.StatusCode -eq 200 -or $response.StatusCode -eq 304) {
            Write-Host "✓ Application is running successfully" -ForegroundColor Green
            break
        }
    }
    catch {
        if ($retryCount -eq 0) {
            Write-Host "Waiting for application to start..." -ForegroundColor Yellow
        }
        else {
            Write-Host "." -NoNewline
        }
        $retryCount++
        Start-Sleep -Seconds $retryInterval
    }
    
    # If we've reached max retries, show an error
    if ($retryCount -eq $maxRetries) {
        Write-Host "`n✗ Application did not start properly within the expected time." -ForegroundColor Red
        Write-Host "Container logs:" -ForegroundColor Yellow
        docker-compose logs
        Write-Host "`nTroubleshooting steps:" -ForegroundColor Yellow
        Write-Host "1. Check if port 3006 is open in your firewall"
        Write-Host "2. Verify Docker container is running: docker ps"
        Write-Host "3. Check container logs: docker-compose logs"
        exit 1
    }
}

# Try to get the server's IP address
try {
    $serverIP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notlike "*Loopback*" -and $_.IPAddress -notlike "127.*" -and $_.IPAddress -notlike "169.254.*" } | Select-Object -First 1).IPAddress
    
    if ($serverIP) {
        # Try to access the application using the server's IP
        try {
            $response = Invoke-WebRequest -Uri "http://$serverIP`:3006" -UseBasicParsing -TimeoutSec 5
            if ($response.StatusCode -eq 200 -or $response.StatusCode -eq 304) {
                Write-Host "✓ Application is also accessible via server IP: http://$serverIP`:3006" -ForegroundColor Green
            }
        }
        catch {
            Write-Host "! Application may not be accessible via server IP: http://$serverIP`:3006" -ForegroundColor Yellow
            Write-Host "  This could be due to firewall settings. Check Windows Firewall for port 3006." -ForegroundColor Yellow
        }
    }
}
catch {
    Write-Host "! Unable to determine server IP address" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "✓ Setup completed successfully!" -ForegroundColor Green
Write-Host "Your application is now running on:" -ForegroundColor Cyan
Write-Host "  - Local: http://localhost:3006" -ForegroundColor Cyan
if ($serverIP) {
    Write-Host "  - Server IP: http://$serverIP`:3006" -ForegroundColor Cyan
}
Write-Host "  (Docker container port 3000 is mapped to host port 3006)" -ForegroundColor Cyan
Write-Host ""
Write-Host "Useful Docker commands:" -ForegroundColor Cyan
Write-Host "- To view logs: docker-compose logs -f" -ForegroundColor White
Write-Host "- To stop the application: docker-compose down" -ForegroundColor White
Write-Host "- To restart the application: docker-compose restart" -ForegroundColor White
Write-Host ""
Write-Host "IMPORTANT: If you cannot access the application via server IP, ensure port 3006 is allowed in your Windows Firewall" -ForegroundColor Yellow 