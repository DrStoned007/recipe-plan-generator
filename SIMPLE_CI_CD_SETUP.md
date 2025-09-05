# Simplified CI/CD Setup Guide

## Overview

The GitHub Actions workflows have been simplified to focus on essential functionality:

- **GitGuardian Security Scanning**: Detects secrets and security issues
- **Simple Build & Deploy**: Builds Flutter web app and deploys to Netlify
- **Minimal Dependencies**: Uses only required secrets for basic functionality

## Active Workflows

### 1. `simple-deploy.yml` - Main Deployment Workflow
**Triggers:**
- Push to: `master`, `development`, `release` branches
- Pull requests to: `master`
- Manual dispatch

**Features:**
- ✅ GitGuardian secret scanning
- ✅ Flutter web build
- ✅ Netlify deployment
- ✅ Build artifact upload
- ✅ Comprehensive status reporting

### 2. `test-simple.yml` - Quick Validation
**Triggers:**
- Push to: `development` branch
- Manual dispatch

**Features:**
- ✅ Environment validation
- ✅ Repository structure check
- ✅ Workflow configuration verification

## Required Secrets

### Essential (Required)
```
SUPABASE_URL=your-supabase-project-url
SUPABASE_ANON_KEY=your-supabase-anon-key
```

### Deployment (Recommended)
```
NETLIFY_AUTH_TOKEN=your-netlify-token
NETLIFY_SITE_ID=your-netlify-site-id
```

### Security (Optional but Recommended)
```
GITGUARDIAN_API_KEY=your-gitguardian-api-key
```

### Additional (Optional)
```
GOOGLE_SIGN_IN_WEB_CLIENT_ID=your-google-client-id
```

## GitGuardian Setup

1. **Sign up** at [GitGuardian](https://www.gitguardian.com/)
2. **Get API Key** from your GitGuardian dashboard
3. **Add to GitHub Secrets** as `GITGUARDIAN_API_KEY`

If you don't have GitGuardian, the workflow will still work but skip the security scan.

## Deployment Behavior

### Branch-Based Deployment
- **Production**: `master` and `release` branches
- **Staging**: `development` branch and pull requests

### Deployment Conditions
- ✅ **With Netlify secrets**: Automatic deployment
- ❌ **Without Netlify secrets**: Build artifacts uploaded for manual deployment

## Disabled Workflows

The following workflows have been disabled (renamed with `.disabled` extension):
- `ci-main.yml.disabled` - Complex CI/CD pipeline
- `deploy-web.yml.disabled` - Advanced web deployment
- `deploy-android.yml.disabled` - Android deployment
- `deploy-ios.yml.disabled` - iOS deployment
- `deploy-desktop.yml.disabled` - Desktop deployment
- `security-scan.yml.disabled` - Advanced security scanning
- `monitoring.yml.disabled` - Application monitoring
- `dependency-management.yml.disabled` - Dependency updates

## Testing the Workflow

1. **Commit changes** to the `development` branch
2. **Monitor GitHub Actions** tab for workflow execution
3. **Check workflow summary** for detailed status reports
4. **Verify deployment** if Netlify secrets are configured

## Re-enabling Complex Workflows

To re-enable the full CI/CD pipeline:
```bash
cd .github/workflows
Get-ChildItem -Name "*.disabled" | ForEach-Object { 
    $newName = $_ -replace '\.disabled$', ''
    Move-Item $_ $newName 
}
```

## Troubleshooting

### Common Issues
1. **Workflow not triggering**: Check branch names match exactly
2. **Build failures**: Verify required secrets are set
3. **Deployment failures**: Check Netlify secrets and site configuration

### Debug Steps
1. Check GitHub Actions logs
2. Verify secret names and values
3. Test with manual workflow dispatch
4. Review workflow summary for detailed status

## Success Criteria

✅ **GitGuardian scan completes** (with or without API key)  
✅ **Flutter build succeeds** with required secrets  
✅ **Netlify deployment works** (if secrets provided)  
✅ **Build artifacts uploaded** for manual deployment  
✅ **Clear status reporting** in workflow summary  

---

*Test run initiated: 2025-09-05 - Testing test-simple.yml real deployment workflow*  