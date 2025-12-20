# 🚀 GitHub Repository Setup Guide

This document provides step-by-step instructions for setting up the Yume AI Wallpaper project on GitHub for production.

## 📋 Prerequisites

- [x] GitHub account
- [x] Git installed locally
- [x] Repository created on GitHub (or ready to create one)

## 🔧 Step 1: Initialize Git Repository (if not already done)

If you haven't initialized git yet:

```bash
cd yume_app
git init
git branch -M main
```

## 📦 Step 2: Verify .gitignore is Working

Before committing, verify sensitive files are ignored:

```bash
# Check what Git will track
git status

# Ensure these are NOT listed:
# - *.keystore, *.jks files
# - key.properties
# - *.g.dart files
# - build/ directory contents
```

## 📝 Step 3: Make Initial Commit

```bash
# Add all files
git add .

# Create initial commit
git commit -m "chore: initial production-ready setup

- Clean Architecture with Feature-First structure
- Riverpod state management
- Comprehensive documentation (README, CONTRIBUTING, CHANGELOG)
- GitHub Actions CI/CD workflows
- Android production configuration
- ProGuard rules for release builds
"
```

## 🌐 Step 4: Create GitHub Repository

### Option A: Via GitHub Website

1. Go to <https://github.com/new>
2. Name your repository: `yume-wallpaper` (or your preferred name)
3. **Do NOT** initialize with README, .gitignore, or LICENSE (we already have these)
4. Create repository
5. Copy the repository URL

### Option B: Via GitHub CLI

```bash
gh repo create yume-wallpaper --public --source=. --remote=origin
```

## 🔗 Step 5: Link Local Repository to GitHub

```bash
# Add remote (replace with your actual repository URL)
git remote add origin https://github.com/yourusername/yume-wallpaper.git

# Push to GitHub
git push -u origin main
```

## ⚙️ Step 6: Configure GitHub Settings

### Enable GitHub Actions

1. Go to repository → Settings → Actions → General
2. Select "Allow all actions and reusable workflows"
3. Enable "Read and write permissions" for workflows
4. Save changes

### Add Repository Topics (for discoverability)

Go to repository homepage → About → Add topics:

- `flutter`
- `flutter-app`
- `ai-wallpaper`
- `riverpod`
- `clean-architecture`
- `wallpaper-generator`
- `android`

### Setup Branch Protection (Recommended)

1. Go to Settings → Branches
2. Add branch protection rule for `main`:
   - ✅ Require pull request reviews before merging
   - ✅ Require status checks to pass (select flutter-ci workflows)
   - ✅ Require conversation resolution before merging

## 🔑 Step 7: Android Release Signing (For Play Store)

### Generate Keystore

```bash
# Navigate to android directory
cd android

# Generate keystore (will prompt for passwords)
keytool -genkey -v -keystore release-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias yume-release-key

# Answer the prompts (use strong passwords!)
```

### Create key.properties

```bash
# Copy template
cp key.properties.example key.properties

# Edit key.properties with your actual values:
storePassword=your-store-password
keyPassword=your-key-password
keyAlias=yume-release-key
storeFile=../release-keystore.jks
```

### ⚠️ CRITICAL: Secure Your Keystore

**DO NOT commit these files to Git! They are already in .gitignore.**

Store securely:

- Upload `release-keystore.jks` to a secure password manager
- Keep `key.properties` in a secure location
- Share with team members via secure channels only

For GitHub Actions releases (optional):

- Encode keystore: `base64 release-keystore.jks > keystore.base64`
- Add secrets to GitHub: Settings → Secrets and variables → Actions
  - `ANDROID_KEYSTORE_BASE64`: content of keystore.base64
  - `KEYSTORE_PASSWORD`: your store password
  - `KEY_ALIAS`: your key alias
  - `KEY_PASSWORD`: your key password

## 🎯 Step 8: Create First Release

### Update Version

1. Update `pubspec.yaml`:

   ```yaml
   version: 1.0.0+1
   ```

2. Update CHANGELOG.md:
   - Change `[Unreleased]` to `[1.0.0] - 2025-MM-DD`
   - Add release date

3. Commit changes:

   ```bash
   git add pubspec.yaml CHANGELOG.md
   git commit -m "chore: bump version to 1.0.0"
   git push
   ```

### Create Release Tag

```bash
# Create annotated tag
git tag -a v1.0.0 -m "Release v1.0.0 - Initial public release"

# Push tag to trigger release workflow
git push origin v1.0.0
```

GitHub Actions will automatically:

- Build release APK and AAB
- Create GitHub release
- Attach build artifacts

## 📊 Step 9: Verify Everything Works

### Check GitHub Actions

1. Go to repository → Actions
2. Verify "Flutter CI" workflow passes ✅
3. Verify "Release Build" workflow completes (after pushing tag)

### Check Repository Homepage

Verify these show correctly:

- [ ] README renders with proper formatting
- [ ] License badge displays
- [ ] Topics are visible
- [ ] Issue templates work (try creating test issue)

## 🎉 Step 10: Post-Setup Tasks

### Update README

Replace placeholder content:

- Add actual screenshots (take screenshots of the app)
- Update repository URL in clone command
- Add your contact information

### Share Your Project

- Add repository link to your portfolio
- Share on social media/dev communities
- Consider adding to awesome-flutter lists

## 📚 Ongoing Maintenance

### For New Features

```bash
# Create feature branch
git checkout -b feature/your-feature

# Make changes, commit
git add .
git commit -m "feat: add new feature"

# Push and create PR
git push origin feature/your-feature
```

### For Bug Fixes

```bash
git checkout -b fix/bug-description
# Make fixes
git commit -m "fix: resolve issue description"
git push origin fix/bug-description
```

### For New Releases

1. Update version in `pubspec.yaml`
2. Update `CHANGELOG.md`
3. Commit: `git commit -m "chore: bump version to x.y.z"`
4. Tag: `git tag -a vx.y.z -m "Release x.y.z"`
5. Push: `git push && git push origin vx.y.z`

## 🆘 Troubleshooting

### Build Fails in GitHub Actions

- Check that all dependencies are in `pubspec.yaml`
- Verify code generation files (*.g.dart) are not committed
- Check workflow logs for specific errors

### Cannot Push to GitHub

```bash
# Reset remote
git remote remove origin
git remote add origin https://github.com/yourusername/yume-wallpaper.git
git push -u origin main
```

### Release Workflow Doesn't Trigger

- Ensure tag starts with 'v' (e.g., v1.0.0, not 1.0.0)
- Check GitHub Actions permissions
- Verify .github/workflows/release.yml exists

## ✅ Production Readiness Checklist

Final verification before going live:

- [ ] All tests pass (`flutter test`)
- [ ] Code analysis passes (`flutter analyze`)
- [ ] README is comprehensive
- [ ] LICENSE file exists
- [ ] CHANGELOG is up to date
- [ ] .gitignore protects sensitive files
- [ ] GitHub Actions workflows are working
- [ ] Release signing is configured (for Play Store)
- [ ] Repository is public (or properly configured if private)
- [ ] Issues and PR templates work
- [ ] No hardcoded secrets in codebase

---

**You're all set! 🎉** Your Yume app is now production-ready on GitHub!
