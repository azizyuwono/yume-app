---
description: Run build_runner for Riverpod code generation
---

# Code Generation Workflow

// turbo-all

## One-time Build

1. Run: `dart run build_runner build --delete-conflicting-outputs`

## Watch Mode (for development)

2. Run: `dart run build_runner watch --delete-conflicting-outputs`

## Clean and Rebuild

3. Run: `dart run build_runner clean`
4. Run: `dart run build_runner build --delete-conflicting-outputs`
