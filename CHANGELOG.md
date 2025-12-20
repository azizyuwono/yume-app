# Changelog

All notable changes to the Yume AI Wallpaper project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- AI-powered wallpaper generation via Pollinations.ai
- Dynamic wallpaper gallery with featured content
- Local storage using Hive for offline access
- Dark/Light theme support with persistence
- Direct wallpaper application for Android
- Image saving to device gallery
- Shimmer loading states for better UX
- Clean Architecture with Feature-First structure
- Riverpod state management with code generation
- **Production-ready GitHub configuration**
  - Comprehensive README with features and setup instructions
  - MIT License
  - Contributing guidelines
  - GitHub Actions CI/CD workflows (testing, analysis, releases)
  - Issue and PR templates
  - Security-hardened .gitignore
- **Custom cache manager** for optimized wallpaper caching
- ProGuard rules for release builds
- Android release signing configuration

### Changed

- **App name simplified** from "yume_app" / "Yume App" to "Yume" across all platforms
- **Android package name** updated to `id.yumeapp.wallpaper` (production-ready)
- **Reduced featured wallpapers** from 6 to 4 to minimize API load
- **Download logic optimized** to use cache-first strategy with zero redundant API calls
- **Image resolution upgraded** to Full HD 1080x1920 for crisp mobile display
- **Generation timeout** increased to 90s for complex prompts
- **Retry logic enhanced** to 5 retries with exponential backoff for reliability
- **Generation progress UI** now shows stages: Connecting → Weaving → Adding details → Almost ready

### Deprecated

- N/A

### Removed

- Dio dependency from ImageDownloadService (now pure cache-based)
- Unnecessary timestamp cache-busting parameter from grid images

### Fixed

- **429 Too Many Requests error** on wallpaper download - now uses pure cache retrieval
- **524 Timeout errors** on HD preview - graceful fallback to low-res on timeout
- Image generation timeout handling with retry logic
- Download button now properly waits for cache population before saving
- HD preview errors no longer show visual error widgets (uses low-res fallback)
- Optimized API request patterns to prevent rate limiting

### Security

- No hardcoded API keys or secrets
- Enhanced .gitignore protecting keystores, environment files, and generated code
- Android keystore configuration properly excluded from version control
- ProGuard obfuscation rules for release builds

## [1.0.0] - YYYY-MM-DD (Not Released Yet)

### Added

- Initial release of Yume AI Wallpaper app

---

## Version History Format

For contributors: when adding to this changelog, use the following categories:

- **Added** for new features
- **Changed** for changes in existing functionality
- **Deprecated** for soon-to-be removed features
- **Removed** for now removed features
- **Fixed** for any bug fixes
- **Security** in case of vulnerabilities
