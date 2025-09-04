# CI/CD Documentation

This document provides comprehensive information about the NutriPlan CI/CD pipeline implementation, workflows, and best practices.

## Pipeline Overview

The NutriPlan CI/CD pipeline consists of 8 specialized GitHub Actions workflows:

1. **Main CI/CD Pipeline** (`ci-main.yml`) - Core workflow for code quality, testing, and deployment
2. **Security Scanning** (`security-scan.yml`) - SAST, dependency scanning, and secret detection
3. **Dependency Management** (`dependency-management.yml`) - Automated dependency updates
4. **Platform-Specific Deployments**:
   - Web deployment (`deploy-web.yml`)
   - Android deployment (`deploy-android.yml`) 
   - iOS deployment (`deploy-ios.yml`)
   - Desktop deployment (`deploy-desktop.yml`)
5. **Monitoring & Health Checks** (`monitoring.yml`) - Application monitoring and alerting

## Workflow Architecture

### Main CI/CD Pipeline

**Triggers**:
- Push to `main` or `develop` branches
- Pull requests to `main` branch
- Manual dispatch with environment selection

**Jobs**:
1. **Code Quality Analysis**
   - Dart formatting verification
   - Static analysis with Flutter analyzer
   - Unused dependency detection
   - Code generation verification

2. **Security Scanning**
   - Vulnerability scanning with Trivy
   - Secret detection with TruffleHog
   - Custom security pattern matching

3. **Multi-Platform Testing**
   - Unit tests across Flutter versions
   - Widget and integration tests
   - Coverage reporting to Codecov
   - Cross-platform compatibility testing

4. **Build Artifacts**
   - Android (APK + AAB)
   - iOS (IPA)
   - Web (optimized build)
   - Desktop (Windows, macOS, Linux)

5. **Performance Analysis**
   - Bundle size analysis
   - Build time optimization
   - Memory usage profiling

6. **Environment-Specific Deployment**
   - Staging: Auto-deploy from `develop`
   - Production: Auto-deploy from `main`

### Security Scanning Workflow

**Comprehensive Security Coverage**:
- **SAST Analysis**: CodeQL and Semgrep for static security analysis
- **Dependency Scanning**: Trivy and OSV Scanner for vulnerability detection
- **Secret Detection**: TruffleHog and GitLeaks for credential exposure
- **License Compliance**: FOSSA integration for license verification

**Scheduled Execution**: Daily at 2 AM UTC for continuous monitoring

### Dependency Management

**Automated Maintenance**:
- Weekly dependency updates
- Security patch prioritization
- Compatibility testing
- Automated PR creation with changelogs

**Update Strategy**:
- Patch versions: Auto-merge after testing
- Minor versions: Require review
- Major versions: Manual review required

## Build Strategy

### Multi-Platform Build Matrix

```yaml
strategy:
  matrix:
    include:
      - target: android (Ubuntu)
      - target: ios (macOS)
      - target: web (Ubuntu)
      - target: windows (Windows)
      - target: macos (macOS)
      - target: linux (Ubuntu)
```

### Flutter Version Strategy

Testing across multiple Flutter versions:
- Stable (3.22.x)
- Previous stable (3.19.x)
- Beta channel (for early compatibility testing)

### Code Generation

Automated code generation for:
- JSON serialization (build_runner)
- Route generation
- Asset generation
- Localization files

## Testing Strategy

### Test Pyramid

1. **Unit Tests** (70%)
   - Service layer logic
   - Provider state management
   - Utility functions
   - Data model validation

2. **Widget Tests** (20%)
   - Component behavior
   - User interaction flows
   - State changes
   - UI responsiveness

3. **Integration Tests** (10%)
   - End-to-end user journeys
   - Cross-platform functionality
   - Performance benchmarks
   - API integration

### Coverage Requirements

- **Minimum**: 80% line coverage
- **Target**: 90% line coverage
- **Critical paths**: 100% coverage required

### Test Execution

```bash
# Unit tests
flutter test --coverage

# Widget tests  
flutter test test/widget_test/

# Integration tests
flutter test integration_test/

# Performance tests
flutter drive --target=test_driver/performance_test.dart
```

## Deployment Strategy

### Environment Progression

```
Feature Branch → Develop → Staging → Main → Production
     ↓              ↓         ↓        ↓         ↓
   PR Tests     Auto Deploy  QA    Manual    Auto Deploy
                           Testing  Review   
```

### Blue-Green Deployment

**Production Deployment Process**:
1. Deploy to green environment
2. Run smoke tests
3. Switch traffic gradually (10% → 50% → 100%)
4. Monitor health metrics
5. Rollback capability within 5 minutes

### Rollback Strategy

**Automatic Rollback Triggers**:
- Health check failures (>5 minutes)
- Error rate >5%
- Performance degradation >50%
- User-reported critical issues

**Manual Rollback**:
- One-click rollback via GitHub Actions
- Database migration rollback scripts
- Asset version management

## Performance Monitoring

### Metrics Collection

**Application Performance**:
- Page load times
- Time to interactive (TTI)
- First contentful paint (FCP)
- Core Web Vitals

**Infrastructure Monitoring**:
- API response times
- Database query performance
- Memory usage patterns
- Error rates and exceptions

**Build Performance**:
- Compilation time tracking
- Bundle size optimization
- Asset compression rates
- Cache hit ratios

### Alerting Thresholds

**Critical Alerts** (Immediate notification):
- API response time >2 seconds
- Error rate >1%
- Build failures
- Security vulnerabilities

**Warning Alerts** (Daily digest):
- Performance degradation >20%
- Dependency updates available
- Test flakiness detected
- Coverage drops below threshold

## Security Implementation

### Security-First Approach

**Code Scanning**:
- Every commit scanned for vulnerabilities
- Dependency updates prioritize security patches
- Secret detection prevents credential leaks
- License compliance ensures legal safety

**Deployment Security**:
- Signed builds for all platforms
- Encrypted secret management
- Environment isolation
- Access control and audit logs

### Compliance

**Security Standards**:
- OWASP Top 10 protection
- GDPR compliance for user data
- SOC 2 Type II requirements
- Mobile security best practices

## Environment Configuration

### Environment Variables

**Development**:
```env
ENVIRONMENT=development
DEBUG_MODE=true
API_BASE_URL=http://localhost:3000
LOG_LEVEL=debug
```

**Staging**:
```env
ENVIRONMENT=staging  
DEBUG_MODE=false
API_BASE_URL=https://staging-api.nutriplan.app
LOG_LEVEL=info
```

**Production**:
```env
ENVIRONMENT=production
DEBUG_MODE=false
API_BASE_URL=https://api.nutriplan.app
LOG_LEVEL=error
```

### Secret Management

**GitHub Secrets Organization**:
- Repository-level: Shared across environments
- Environment-specific: Staging vs Production
- Organization-level: Shared across repositories

## Troubleshooting Guide

### Common Issues

**Build Failures**:
```bash
# Clear Flutter cache
flutter clean
flutter pub get

# Regenerate code
flutter packages pub run build_runner build --delete-conflicting-outputs

# Check dependencies
flutter doctor -v
```

**Test Failures**:
```bash
# Run specific test file
flutter test test/specific_test.dart

# Run with verbose output
flutter test --verbose

# Update golden files
flutter test --update-goldens
```

**Deployment Issues**:
- Verify environment variables
- Check secret availability
- Validate network connectivity
- Review platform-specific requirements

### Debug Commands

**Local Development**:
```bash
# Check environment setup
flutter doctor

# Analyze code quality
flutter analyze

# Check for outdated dependencies
flutter pub outdated

# Profile app performance
flutter run --profile
```

**CI/CD Debugging**:
```bash
# Download build artifacts
gh run download [run-id]

# Check workflow logs
gh run view [run-id] --log

# Re-run failed jobs
gh run rerun [run-id] --failed
```

## Best Practices

### Code Quality

1. **Consistent Formatting**: Automated with `dart format`
2. **Static Analysis**: Zero warnings policy
3. **Test Coverage**: Comprehensive test suite
4. **Documentation**: Inline docs for public APIs

### CI/CD Optimization

1. **Caching Strategy**: Aggressive caching for dependencies
2. **Parallel Execution**: Matrix builds for efficiency
3. **Fail Fast**: Early termination on critical failures
4. **Resource Management**: Optimal runner allocation

### Security

1. **Least Privilege**: Minimal required permissions
2. **Secret Rotation**: Regular credential updates
3. **Audit Logging**: Comprehensive activity tracking
4. **Vulnerability Response**: 24-hour patch cycle

## Maintenance

### Regular Tasks

**Weekly**:
- Dependency update review
- Performance metric analysis
- Security scan review
- Test reliability assessment

**Monthly**:
- Workflow optimization review
- Documentation updates
- Secret rotation planning
- Capacity planning

**Quarterly**:
- Security audit
- Performance benchmarking
- Tool evaluation
- Process improvement review

### Upgrade Path

**Flutter Version Updates**:
1. Test in development environment
2. Update CI/CD workflow versions
3. Validate all platform builds
4. Update documentation
5. Deploy to staging for validation
6. Production deployment

## Support and Resources

### Documentation
- GitHub Actions documentation
- Flutter deployment guides
- Platform-specific requirements
- Security best practices

### Community
- Flutter community forums
- GitHub Discussions
- Stack Overflow tags
- DevOps communities

### Tools and Services
- GitHub Actions marketplace
- Flutter dev tools
- Security scanning services
- Performance monitoring tools