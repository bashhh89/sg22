/**
 * Deployment Readiness Check Script
 * Verifies that all required dependencies and configurations are in place
 * for a successful deployment.
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

console.log(`${colors.blue}Starting deployment readiness check...${colors.reset}\n`);

let errors = 0;
let warnings = 0;

// Check for required files
const requiredFiles = [
  { path: 'package.json', name: 'Package configuration' },
  { path: 'pnpm-lock.yaml', name: 'PNPM lock file' },
  { path: 'ecosystem.config.js', name: 'PM2 configuration' },
  { path: '.env.local', name: 'Environment variables' }
];

console.log(`${colors.blue}Checking required files...${colors.reset}`);
requiredFiles.forEach(file => {
  if (fs.existsSync(path.join(process.cwd(), file.path))) {
    console.log(`${colors.green}✓${colors.reset} ${file.name} (${file.path}) exists`);
  } else {
    if (file.path === '.env.local') {
      console.log(`${colors.yellow}⚠${colors.reset} ${file.name} (${file.path}) is missing - will be created during deployment`);
      warnings++;
    } else {
      console.log(`${colors.red}✗${colors.reset} ${file.name} (${file.path}) is missing!`);
      errors++;
    }
  }
});

// Check Node.js and PNPM versions
console.log(`\n${colors.blue}Checking environment...${colors.reset}`);
try {
  const nodeVersion = execSync('node --version').toString().trim();
  console.log(`${colors.green}✓${colors.reset} Node.js version: ${nodeVersion}`);
  
  try {
    const pnpmVersion = execSync('pnpm --version').toString().trim();
    console.log(`${colors.green}✓${colors.reset} PNPM version: ${pnpmVersion}`);
  } catch (error) {
    console.log(`${colors.red}✗${colors.reset} PNPM is not installed!`);
    errors++;
  }
} catch (error) {
  console.log(`${colors.red}✗${colors.reset} Could not detect Node.js version!`);
  errors++;
}

// Check if the application can build without errors
console.log(`\n${colors.blue}Running test build...${colors.reset}`);
try {
  console.log('Building the application might take a while...');
  execSync('pnpm build --no-lint', { stdio: 'pipe' });
  console.log(`${colors.green}✓${colors.reset} Application builds successfully`);
} catch (error) {
  console.log(`${colors.red}✗${colors.reset} Build failed with error: ${error.message}`);
  errors++;
}

// Final status
console.log(`\n${colors.blue}Deployment readiness summary:${colors.reset}`);
if (errors === 0 && warnings === 0) {
  console.log(`${colors.green}✓ All checks passed! Your application is ready for deployment.${colors.reset}`);
} else if (errors === 0) {
  console.log(`${colors.yellow}⚠ Deployment possible with ${warnings} warning(s). Review the warnings above.${colors.reset}`);
} else {
  console.log(`${colors.red}✗ Deployment not recommended! Fix the ${errors} error(s) listed above.${colors.reset}`);
}

// Exit with appropriate code
process.exit(errors > 0 ? 1 : 0); 