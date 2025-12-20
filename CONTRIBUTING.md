# Contributing to Yume AI Wallpaper

Thank you for considering contributing to Yume! This document provides guidelines and instructions for contributing to the project.

## 🤝 Code of Conduct

By participating in this project, you agree to maintain a respectful and inclusive environment for everyone.

## 🐛 Reporting Bugs

Before creating a bug report:

1. **Check existing issues** to avoid duplicates
2. **Gather information** about the bug (Flutter version, device, OS version)
3. **Reproduce the bug** with minimal steps

When reporting a bug, include:

- Clear, descriptive title
- Steps to reproduce
- Expected behavior vs actual behavior
- Screenshots or videos (if applicable)
- Flutter doctor output
- Device/emulator information

## 💡 Suggesting Features

Feature requests are welcome! When suggesting a feature:

- Use a clear, descriptive title
- Provide detailed explanation of the feature
- Explain why this feature would be useful
- Include mockups or examples if applicable

## 🔧 Development Setup

1. **Fork the repository** and clone your fork
2. **Install dependencies:**

   ```bash
   flutter pub get
   ```

3. **Run code generation:**

   ```bash
   dart run build_runner watch --delete-conflicting-outputs
   ```

4. **Create a feature branch:**

   ```bash
   git checkout -b feature/your-feature-name
   ```

## 📝 Code Style Guidelines

### Flutter & Dart

- **Follow official Dart style guide:** Use `dart format` before committing
- **Run analysis:** Ensure `flutter analyze` passes with no warnings
- **Use strict typing:** Avoid `dynamic`, always specify return types
- **Null safety:** Use sound null safety patterns

### Architecture Patterns

This project follows **Clean Architecture** with **Riverpod**:

1. **Feature-First Structure:**

   ```
   features/[feature_name]/
   ├── data/          # DataSources, Repository Implementation
   ├── domain/        # Models, Repository Interfaces
   └── presentation/  # UI, Riverpod Providers
   ```

2. **Repository Pattern:**
   - Define repository interface in `domain/repositories/`
   - Implement in `data/repositories/`
   - Inject via Riverpod providers

3. **Result Pattern:**
   - Use `Result<T>` for error handling
   - Return `Success(data)` or `Failure(message)`

4. **State Management:**
   - Use Riverpod `@riverpod` annotations for code generation
   - Keep UI logic in `Notifier` or `AsyncNotifier` classes
   - UI widgets should be `ConsumerWidget` or `ConsumerStatefulWidget`

### Code Quality Checklist

Before submitting a PR, ensure:

- [ ] Code is formatted (`dart format .`)
- [ ] Analysis passes (`flutter analyze`)
- [ ] All tests pass (`flutter test`)
- [ ] Code generation is up-to-date (`dart run build_runner build --delete-conflicting-outputs`)
- [ ] No hardcoded strings (use constants or i18n)
- [ ] Comments explain "why", not "what"
- [ ] No `// TODO` comments (create issues instead)

## 🧪 Testing

- Write tests for new features (unit, widget, integration)
- Maintain or improve code coverage
- Test on both physical devices and emulators
- Test dark/light themes
- Test different screen sizes

## 🔀 Pull Request Process

1. **Update documentation** if you're changing functionality
2. **Update CHANGELOG.md** with your changes under `[Unreleased]`
3. **Follow the PR template** when creating your pull request
4. **Ensure CI passes** (all GitHub Actions workflows)
5. **Request review** from maintainers
6. **Address feedback** promptly and respectfully

### PR Title Format

Use conventional commit format:

- `feat: Add new wallpaper style`
- `fix: Resolve timeout error in image generation`
- `docs: Update README installation steps`
- `refactor: Improve repository implementation`
- `test: Add tests for create feature`
- `chore: Update dependencies`

## 🏗️ Project Structure

```
lib/
├── core/              # Shared utilities, services, theme
├── features/
│   ├── create/        # AI generation feature
│   ├── home/          # Gallery feature
│   ├── preview/       # Wallpaper preview
│   └── history/       # History feature
├── app.dart           # App widget
└── main.dart          # Entry point
```

## 🚀 Release Process

(For maintainers)

1. Update version in `pubspec.yaml`
2. Update `CHANGELOG.md` with release date
3. Create git tag: `git tag v1.0.0`
4. Push tag: `git push origin v1.0.0`
5. GitHub Actions will create release automatically

## 📧 Questions?

If you have questions not covered here:

- Open a GitHub Discussion
- Create an issue with the "question" label
- Check existing documentation

## 🙏 Thank You

Your contributions make Yume better for everyone. We appreciate your time and effort!

---

**Happy Coding!** 🌙✨
