# Deployment Guide

This guide provides step-by-step instructions for deploying the NutriPlan application across all supported platforms using the automated CI/CD pipeline.

## Overview

The NutriPlan deployment strategy includes:
- **Staging Environment**: Automatic deployment from `develop` branch
- **Production Environment**: Automatic deployment from `main` branch  
- **Multi-Platform Support**: Android, iOS, Web, Windows, macOS, Linux
- **Blue-Green Deployments**: Zero-downtime production updates

## Prerequisites

Before deploying, ensure you have:

1. **GitHub Secrets Configured** (see GITHUB_SECRETS_SETUP.md)
2. **Environment Variables Set** (see .env.example)
3. **Platform-Specific Accounts**:
   - Vercel/Netlify for web deployment
   - Google Play Console for Android
   - Apple Developer Account for iOS
   - Microsoft Store for Windows (optional)

## Deployment Environments

### Staging Environment

**Trigger**: Push to `develop` branch
**URL**: https://staging.nutriplan.app (configured in workflows)

```bash
# Deploy to staging
git checkout develop
git add .
git commit -m "feat: your changes"
git push origin develop
```

**What happens**:
1. Code quality analysis and security scanning
2. Automated testing across multiple platforms
3. Build artifacts for all target platforms
4. Deployment to staging environment
5. Smoke tests and health checks
6. Slack notifications

### Production Environment

**Trigger**: Push to `main` branch
**URL**: https://nutriplan.app (configured in workflows)

```bash
# Deploy to production (after PR approval)
git checkout main
git merge develop
git push origin main
```

**What happens**:
1. Full CI/CD pipeline execution
2. Enhanced security checks
3. Performance analysis and bundle optimization
4. Blue-green deployment strategy
5. Post-deployment verification
6. Monitoring and alerting setup

## Platform-Specific Deployments

### Web Application

**Deployment Targets**:
- Primary: Vercel
- Fallback: Netlify
- CDN: Cloudflare

**Build Configuration**:
```yaml
flutter build web \
  --release \
  --web-renderer canvaskit \
  --dart-define=SUPABASE_URL=${{ secrets.SUPABASE_URL }} \
  --dart-define=SUPABASE_ANON_KEY=${{ secrets.SUPABASE_ANON_KEY }}
```

**Monitoring**: 
- Lighthouse performance audits
- Core Web Vitals tracking
- SSL certificate monitoring

### Android Application

**Deployment Target**: Google Play Store

**Requirements**:
- Google Play Service Account JSON
- Android signing keystore
- Store listing and metadata

**Build Process**:
1. Build signed APK and AAB
2. Automated testing on Firebase Test Lab
3. Upload to Google Play Console
4. Staged rollout (5% → 20% → 50% → 100%)

### iOS Application

**Deployment Target**: Apple App Store

**Requirements**:
- iOS Distribution Certificate
- App Store Connect API keys
- Provisioning profiles

**Build Process**:
1. Code signing with certificates
2. Build and archive iOS app
3. Upload to App Store Connect
4. Submit for App Store review

### Desktop Applications

**Supported Platforms**:
- Windows (Microsoft Store / Direct download)
- macOS (App Store / Direct download)
- Linux (Snap Store / AppImage)

**Build Process**:
1. Platform-specific compilation
2. Code signing (Windows/macOS)
3. Package creation
4. Store submission or direct release

## Manual Deployment

For emergency deployments or testing:

### Manual Trigger via GitHub Actions

1. Go to GitHub → Actions
2. Select "CI/CD Pipeline" workflow
3. Click "Run workflow"
4. Choose environment and options
5. Click "Run workflow"

### Local Development Deployment

```bash
# Build for local testing
cd nutriplan_app

# Web
flutter build web --release
# Serve locally: python -m http.server 8000 -d build/web

# Android
flutter build apk --release
# Install: flutter install

# iOS (macOS only)
flutter build ios --release
# Deploy via Xcode

# Desktop
flutter build windows --release  # Windows
flutter build macos --release    # macOS  
flutter build linux --release    # Linux
```

## Deployment Monitoring

### Health Checks

Automated monitoring includes:
- Application responsiveness (every 15 minutes)
- API endpoint availability
- Database connectivity
- SSL certificate validity
- Performance metrics

### Alerting

**Slack Notifications**:
- Deployment status updates
- Critical health check failures
- Performance degradation alerts

**GitHub Issues**:
- Automatic issue creation for critical failures
- Deployment rollback recommendations

## Rollback Procedures

### Automatic Rollback

Triggers automatically if:
- Health checks fail for >5 minutes
- Error rate exceeds 5%
- Performance degrades >50%

### Manual Rollback

```bash
# Revert to previous version
git checkout main
git revert HEAD
git push origin main
```

Or use GitHub Actions manual trigger with previous deployment tag.

## Performance Optimization

### Build Optimization

- Tree-shaking enabled
- Code splitting for web builds
- Asset compression and optimization
- Bundle size analysis and tracking

### Caching Strategy

- Static asset caching (1 year)
- API response caching (5 minutes)
- Database query optimization
- CDN edge caching

## Security Considerations

### Deployment Security

- Secrets rotation every 90 days
- Environment isolation
- Code signing verification
- Dependency vulnerability scanning

### Production Hardening

- Content Security Policy (CSP)
- HTTPS enforcement
- API rate limiting
- Input validation and sanitization

## Troubleshooting

### Common Deployment Issues

1. **Build Failures**:
   - Check dependency versions
   - Verify environment variables
   - Review build logs

2. **Secret Access Issues**:
   - Verify secret names match exactly
   - Check environment-specific secrets
   - Validate token permissions

3. **Platform-Specific Issues**:
   - Certificate expiration
   - Store policy violations
   - API rate limits

### Support Channels

- GitHub Issues for bugs
- Slack #deployments for immediate help
- Documentation updates in this repository

## Deployment Checklist

### Pre-Deployment

- [ ] All tests passing
- [ ] Security scan clean
- [ ] Performance benchmarks acceptable
- [ ] Environment variables configured
- [ ] Secrets properly set

### Post-Deployment

- [ ] Health checks passing
- [ ] Smoke tests completed
- [ ] Performance metrics stable
- [ ] Error rates normal
- [ ] User feedback monitored

## Maintenance Windows

### Scheduled Maintenance

- **Staging**: Anytime (no user impact)
- **Production**: Sundays 2-4 AM UTC (lowest traffic)

### Emergency Maintenance

- Immediate rollback capability
- Status page updates
- User communication via in-app notifications