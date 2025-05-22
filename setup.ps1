# Client Setup Script for AI Scorecard
# Just run this script to set up the application

Write-Host "AI Scorecard - Client Setup Script" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
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

# Create logs directory if it doesn't exist
if (-not (Test-Path -Path "logs")) {
    Write-Host "Creating logs directory..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path "logs" | Out-Null
    Write-Host "✓ Logs directory created" -ForegroundColor Green
}

# Step 1: Install dependencies
Write-Host "Step 1: Installing dependencies..." -ForegroundColor Yellow
try {
    pnpm install
    Write-Host "✓ Dependencies installed successfully" -ForegroundColor Green
}
catch {
    Write-Host "✗ Failed to install dependencies: $_" -ForegroundColor Red
    exit 1
}

# Step 2: Build the application
Write-Host "Step 2: Building the application..." -ForegroundColor Yellow
try {
    pnpm build
    Write-Host "✓ Application built successfully" -ForegroundColor Green
}
catch {
    Write-Host "✗ Build failed: $_" -ForegroundColor Red
    exit 1
}

# Step 3: Start the application
Write-Host "Step 3: Starting the application..." -ForegroundColor Yellow
try {
    Start-Process -FilePath "pnpm" -ArgumentList "start" -NoNewWindow
    Write-Host "✓ Application started successfully" -ForegroundColor Green
    Write-Host "Your application is now running on http://localhost:3006" -ForegroundColor Cyan
}
catch {
    Write-Host "✗ Failed to start the application: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "✓ Setup completed successfully!" -ForegroundColor Green
Write-Host "To stop the application, press Ctrl+C in the terminal window." -ForegroundColor White 