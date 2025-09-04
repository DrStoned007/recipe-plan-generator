# GitHub Secrets Setup Guide

This guide outlines all the required secrets and environment variables needed for the NutriPlan CI/CD workflows to function properly.

## Required GitHub Secrets

### Core Application Secrets
- `SUPABASE_URL` - Your Supabase project URL
- `SUPABASE_ANON_KEY` - Your Supabase anonymous key  
- `GOOGLE_SIGN_IN_WEB_CLIENT_ID` - Google OAuth web client ID

### Deployment Platform Secrets

#### Vercel (Web Deployment)
- `VERCEL_TOKEN` - Vercel deployment token
- `VERCEL_ORG_ID` - Vercel organization ID
- `VERCEL_PROJECT_ID` - Vercel project ID

#### Netlify (Alternative Web Deployment)
- `NETLIFY_AUTH_TOKEN` - Netlify authentication token
- `NETLIFY_SITE_ID` - Netlify site ID

#### Cloudflare (CDN)
- `CLOUDFLARE_API_TOKEN` - Cloudflare API token
- `CLOUDFLARE_ACCOUNT_ID` - Cloudflare account ID

### Mobile App Store Secrets

#### iOS App Store
- `IOS_DISTRIBUTION_CERTIFICATE_BASE64` - Base64 encoded iOS distribution certificate
- `IOS_DISTRIBUTION_CERTIFICATE_PASSWORD` - iOS certificate password
- `APP_STORE_CONNECT_ISSUER_ID` - App Store Connect issuer ID
- `APP_STORE_CONNECT_KEY_ID` - App Store Connect key ID  
- `APP_STORE_CONNECT_PRIVATE_KEY` - App Store Connect private key

#### Google Play Store
- `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` - Service account JSON for Google Play
- `ANDROID_KEYSTORE_BASE64` - Base64 encoded Android keystore
- `ANDROID_KEYSTORE_PASSWORD` - Android keystore password
- `ANDROID_KEY_ALIAS` - Android key alias
- `ANDROID_KEY_PASSWORD` - Android key password

### Security & Monitoring Secrets
- `SEMGREP_APP_TOKEN` - Semgrep security scanning token (optional)
- `GITLEAKS_LICENSE` - GitLeaks license (optional)
- `SLACK_WEBHOOK` - Slack webhook for deployment notifications
- `SLACK_WEBHOOK_ALERTS` - Slack webhook for critical alerts
- `SENTRY_DSN` - Sentry error tracking DSN
- `SENTRY_AUTH_TOKEN` - Sentry authentication token

### Performance & Testing Secrets
- `WEBPAGETEST_API_KEY` - WebPageTest API key (optional)
- `LHCI_GITHUB_APP_TOKEN` - Lighthouse CI GitHub app token (optional)
- `FOSSA_API_KEY` - FOSSA license scanning API key (optional)

### Desktop Distribution Secrets
- `SNAPCRAFT_STORE_CREDENTIALS` - Snapcraft store credentials for Linux
- `WINDOWS_CERTIFICATE_BASE64` - Windows code signing certificate
- `WINDOWS_CERTIFICATE_PASSWORD` - Windows certificate password
- `MACOS_CERTIFICATE_BASE64` - macOS developer certificate
- `MACOS_CERTIFICATE_PASSWORD` - macOS certificate password

## How to Add Secrets

1. Go to your GitHub repository
2. Navigate to Settings → Secrets and variables → Actions
3. Click "New repository secret"
4. Add the secret name and value
5. Click "Add secret"

## Environment-Specific Secrets

Secrets are organized by environment (staging/production) in the environment configuration files.

## Minimum Required Secrets for Basic Functionality

To get started with basic CI/CD functionality, you need these essential secrets:

### Essential Secrets
1. `SUPABASE_URL`
2. `SUPABASE_ANON_KEY`  
3. `SLACK_WEBHOOK` (for notifications)

### For Web Deployment
4. `VERCEL_TOKEN`
5. `VERCEL_ORG_ID`
6. `VERCEL_PROJECT_ID`

All other secrets are optional and can be added as you expand your deployment capabilities.

## Setup Priority

### Phase 1: Basic CI/CD (Essential)
- SUPABASE_URL
- SUPABASE_ANON_KEY
- SLACK_WEBHOOK (can use a test webhook initially)

### Phase 2: Web Deployment
- VERCEL_TOKEN
- VERCEL_ORG_ID  
- VERCEL_PROJECT_ID

### Phase 3: Mobile Deployment
- iOS App Store secrets
- Google Play Store secrets
- Code signing certificates

### Phase 4: Enhanced Security & Monitoring
- Security scanning tokens
- Performance monitoring tools
- Advanced analytics

## Testing Your Setup

After adding the essential secrets:

1. Commit and push to the `develop` branch
2. Check GitHub Actions tab for workflow execution
3. Monitor the workflow logs for any missing secret errors
4. Add additional secrets as needed based on workflow requirements

## Troubleshooting

### Common Issues
- **Secret not found**: Ensure secret name matches exactly (case-sensitive)
- **Invalid token**: Verify the token has correct permissions
- **Environment mismatch**: Check if secret is added to correct environment

### Validation
You can test individual secrets by creating a simple workflow that echoes the secret length (never echo the actual secret value).
