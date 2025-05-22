/**
 * Deployment Setup Script
 * Sets up the environment for deployment
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

// Colors for console output
const colors = {
  reset: '\x1b[0m',
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m'
};

console.log(`${colors.blue}Starting deployment setup...${colors.reset}\n`);

// Create logs directory if it doesn't exist
if (!fs.existsSync(path.join(process.cwd(), 'logs'))) {
  console.log(`${colors.yellow}Creating logs directory...${colors.reset}`);
  fs.mkdirSync(path.join(process.cwd(), 'logs'));
  console.log(`${colors.green}✓${colors.reset} Logs directory created`);
}

// Check if PM2 is installed
console.log(`\n${colors.blue}Checking PM2 installation...${colors.reset}`);
try {
  const pm2Version = execSync('pm2 --version').toString().trim();
  console.log(`${colors.green}✓${colors.reset} PM2 version: ${pm2Version} is already installed`);
} catch (error) {
  console.log(`${colors.yellow}⚠${colors.reset} PM2 is not installed. Installing globally...`);
  try {
    execSync('pnpm add -g pm2', { stdio: 'inherit' });
    console.log(`${colors.green}✓${colors.reset} PM2 installed successfully`);
  } catch (installError) {
    console.log(`${colors.red}✗${colors.reset} Failed to install PM2: ${installError.message}`);
    process.exit(1);
  }
}

// Install dependencies
console.log(`\n${colors.blue}Installing dependencies...${colors.reset}`);
try {
  execSync('pnpm install', { stdio: 'inherit' });
  console.log(`${colors.green}✓${colors.reset} Dependencies installed successfully`);
} catch (error) {
  console.log(`${colors.red}✗${colors.reset} Failed to install dependencies: ${error.message}`);
  process.exit(1);
}

// Build the application
console.log(`\n${colors.blue}Building the application...${colors.reset}`);
try {
  execSync('pnpm build', { stdio: 'inherit' });
  console.log(`${colors.green}✓${colors.reset} Application built successfully`);
} catch (error) {
  console.log(`${colors.red}✗${colors.reset} Build failed: ${error.message}`);
  process.exit(1);
}

// Start PM2
console.log(`\n${colors.blue}Starting the application with PM2...${colors.reset}`);
try {
  execSync('pm2 start ecosystem.config.js', { stdio: 'inherit' });
  console.log(`${colors.green}✓${colors.reset} Application started successfully with PM2`);
} catch (error) {
  console.log(`${colors.red}✗${colors.reset} Failed to start with PM2: ${error.message}`);
  process.exit(1);
}

// Save PM2 process list
console.log(`\n${colors.blue}Saving PM2 process list...${colors.reset}`);
try {
  execSync('pm2 save', { stdio: 'inherit' });
  console.log(`${colors.green}✓${colors.reset} PM2 process list saved`);
} catch (error) {
  console.log(`${colors.yellow}⚠${colors.reset} Failed to save PM2 process list: ${error.message}`);
}

// Setup PM2 to start on system startup (Windows)
console.log(`\n${colors.blue}Setting up PM2 startup script...${colors.reset}`);
try {
  execSync('pm2 startup', { stdio: 'inherit' });
  console.log(`${colors.green}✓${colors.reset} PM2 startup script created. Follow the instructions above to set it up.`);
} catch (error) {
  console.log(`${colors.yellow}⚠${colors.reset} Failed to create PM2 startup script: ${error.message}`);
}

console.log(`\n${colors.green}✓${colors.reset} Deployment setup completed successfully!`);
console.log(`${colors.blue}Your application is now running on port 3006${colors.reset}`);
console.log(`${colors.blue}To monitor your application, use: ${colors.reset}pm2 monit`);
console.log(`${colors.blue}To view logs, use: ${colors.reset}pm2 logs aiscorecard`);
console.log(`${colors.blue}To restart the application, use: ${colors.reset}pm2 reload aiscorecard`);

process.exit(0); 