# PowerShell script for deploying the AI Scorecard application on Windows
Write-Host "AI Scorecard Windows Deployment Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Node.js is installed
try {
    $nodeVersion = node --version
    Write-Host "✓ Node.js $nodeVersion is installed" -ForegroundColor Green
}
catch {
    Write-Host "✗ Node.js is not installed. Please install Node.js 18.x or later." -ForegroundColor Red
    exit 1
}

# Check if PNPM is installed
try {
    $pnpmVersion = pnpm --version
    Write-Host "✓ PNPM $pnpmVersion is installed" -ForegroundColor Green
}
catch {
    Write-Host "✗ PNPM is not installed. Installing..." -ForegroundColor Yellow
    try {
        npm install -g pnpm
        Write-Host "✓ PNPM installed successfully" -ForegroundColor Green
    }
    catch {
        Write-Host "✗ Failed to install PNPM. Please install it manually: npm install -g pnpm" -ForegroundColor Red
        exit 1
    }
}

# Kill any processes running on port 3006
Write-Host "Checking if port 3006 is in use..." -ForegroundColor Yellow
$portInUse = Get-NetTCPConnection -LocalPort 3006 -ErrorAction SilentlyContinue
if ($portInUse) {
    Write-Host "Port 3006 is in use. Attempting to close process..." -ForegroundColor Yellow
    $processId = $portInUse.OwningProcess
    Stop-Process -Id $processId -Force -ErrorAction SilentlyContinue
    Write-Host "✓ Process using port 3006 has been terminated" -ForegroundColor Green
}
else {
    Write-Host "✓ Port 3006 is available" -ForegroundColor Green
}

# Install dependencies
Write-Host "Installing dependencies..." -ForegroundColor Yellow
try {
    pnpm install
    Write-Host "✓ Dependencies installed successfully" -ForegroundColor Green
}
catch {
    Write-Host "✗ Failed to install dependencies: $_" -ForegroundColor Red
    exit 1
}

# Build the application
Write-Host "Building the application..." -ForegroundColor Yellow
try {
    pnpm build
    Write-Host "✓ Application built successfully" -ForegroundColor Green
}
catch {
    Write-Host "✗ Build failed: $_" -ForegroundColor Red
    exit 1
}

# Check if PM2 is installed
try {
    $pm2Version = pm2 --version
    Write-Host "✓ PM2 $pm2Version is installed" -ForegroundColor Green
}
catch {
    Write-Host "PM2 is not installed. Installing globally..." -ForegroundColor Yellow
    try {
        pnpm add -g pm2
        Write-Host "✓ PM2 installed successfully" -ForegroundColor Green
    }
    catch {
        Write-Host "✗ Failed to install PM2. Please install it manually: pnpm add -g pm2" -ForegroundColor Red
        exit 1
    }
}

# Create logs directory if it doesn't exist
if (-not (Test-Path -Path "logs")) {
    Write-Host "Creating logs directory..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path "logs" | Out-Null
    Write-Host "✓ Logs directory created" -ForegroundColor Green
}

# Start the application with PM2
Write-Host "Starting the application with PM2..." -ForegroundColor Yellow
try {
    pm2 start ecosystem.config.js
    Write-Host "✓ Application started successfully with PM2" -ForegroundColor Green
}
catch {
    Write-Host "✗ Failed to start with PM2: $_" -ForegroundColor Red
    exit 1
}

# Save PM2 process list
Write-Host "Saving PM2 process list..." -ForegroundColor Yellow
try {
    pm2 save
    Write-Host "✓ PM2 process list saved" -ForegroundColor Green
}
catch {
    Write-Host "! Failed to save PM2 process list: $_" -ForegroundColor Yellow
}

# Final success message
Write-Host ""
Write-Host "✓ Deployment completed successfully!" -ForegroundColor Green
Write-Host "Your application is now running on port 3006" -ForegroundColor Cyan
Write-Host ""
Write-Host "Useful commands:" -ForegroundColor Cyan
Write-Host "- To monitor your application: pm2 monit" -ForegroundColor White
Write-Host "- To view logs: pm2 logs aiscorecard" -ForegroundColor White
Write-Host "- To restart the application: pm2 reload aiscorecard" -ForegroundColor White
Write-Host "- To stop the application: pm2 stop aiscorecard" -ForegroundColor White 