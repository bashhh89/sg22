# SG Ready - AI Scorecard PDF Generation

This repository contains the AI Scorecard application with PDF generation capabilities built with Next.js.

## Project Structure

- `components/ui/pdf-download/` - Contains the components for PDF generation and download
  - `ScorecardPDFDocument.tsx` - The main component for rendering the PDF
  - `ScorecardPDFDownloadButton.tsx` - Button component for triggering PDF download
  - `markdownRenderer.tsx` - Utility for rendering markdown in PDFs
  - `pdfStyles.ts` - Styling definitions for PDFs
- `app/` - Next.js app router pages and API routes
- `ecosystem.config.js` - PM2 configuration for production deployment
- `scripts/` - Deployment and utility scripts

## Getting Started

1. Install dependencies:
```bash
pnpm install
```

2. Run the development server:
```bash
pnpm dev
```

3. Build for production:
```bash
pnpm build
```

4. Start the production server:
```bash
pnpm start
```

## Pushing to GitHub

To push this codebase to a new GitHub repository (https://github.com/bashhh89/sg22):

1. Initialize the Git repository (if not already done):
```bash
git init
```

2. Add the GitHub repository as the origin:
```bash
git remote add origin https://github.com/bashhh89/sg22.git
```

3. Add all files:
```bash
git add .
```

4. Commit the changes:
```bash
git commit -m "Initial commit: AI Scorecard application"
```

5. Push to the main branch:
```bash
git push -u origin main
```

## Deployment

### Using PM2 (Production)

1. Make sure PM2 is installed globally:
```bash
pnpm add -g pm2
```

2. Start the application using PM2:
```bash
pm2 start ecosystem.config.js
```

3. To restart the application:
```bash
pm2 reload aiscorecard
```

### Using GitHub Actions

The repository includes a GitHub Actions workflow for automated deployment. The workflow:
1. Installs dependencies
2. Builds the application
3. Deploys using PM2

To customize the deployment, edit the `.github/workflows/deploy.yml` file.

### Windows Deployment Script

For Windows users, a deployment script is provided:
```powershell
.\scripts\deploy-windows.ps1
```

## Environment Variables

This application requires certain environment variables to be set in the `.env.local` file. Make sure to set these before deployment:

```
# Add your environment variables here
# Example:
# NEXT_PUBLIC_API_URL=https://api.example.com
```

## Deployment Checklist

See [PRODUCTION_DEPLOYMENT_CHECKLIST.md](PRODUCTION_DEPLOYMENT_CHECKLIST.md) for a complete checklist of deployment steps and verification.

## Next Steps

- Integrate pdfmake for high-quality PDF generation
- Create a "PDF Version 2" that aims for a highly polished, "HubSpot-like" visual quality
- Implement a template-based PDF generation system 