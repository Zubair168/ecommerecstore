# GitHub Collaboration & Semantic Versioning Assignment Report

**Course / Project:** E-Commerce Mobile Application  
**Student Name:** Zubair (`Zubair168`)  
**Peer Reviewer:** `@mutahirali709`  
**Repository URL:** [https://github.com/Zubair168/ecommerecstore](https://github.com/Zubair168/ecommerecstore)  
**Release Tag:** [`v1.0.0`](https://github.com/Zubair168/ecommerecstore/releases/tag/v1.0.0)  
**Pull Request:** [PR #1 — feat: improve product search](https://github.com/Zubair168/ecommerecstore/pull/1)  
**CI Workflow:** [Flutter CI Workflow](https://github.com/Zubair168/ecommerecstore/actions)  
**Date:** August 13, 2026  

---

## 📋 Executive Summary

This report documents the complete implementation of the **GitHub Collaboration & Semantic Versioning** workflow for the E-Commerce Flutter Application. All required 12 assignment steps have been performed, verified locally, and published to GitHub.

Key deliverables completed:
1. **Feature Development**: Implemented 300ms search debouncing, recent-search chip dismissal, and query auto-saving on a dedicated feature branch (`feature/product-search-improvement`).
2. **Git Branching Strategy**: Utilized `main`, `develop`, and feature branch structure.
3. **Pull Request & Peer Review**: Opened PR #1 targeting `develop`, assigned peer reviewer `@mutahirali709`, obtained formal code review approval, and merged.
4. **CI/CD Pipeline**: Configured GitHub Actions workflow (`.github/workflows/flutter_test.yml`) running automated `flutter test` on every push and PR.
5. **Testing Suite**: Created 10 automated unit and widget tests (`test/search_debounce_test.dart` and `test/widget_test.dart`), all passing.
6. **Semantic Versioning & Documentation**: Created `CHANGELOG.md` with full v1.0.0 release notes, verified `pubspec.yaml` version (`1.0.0+1`), pushed annotated Git tag `v1.0.0`, and published GitHub Release `v1.0.0`.

---

## 📑 12-Step Implementation Breakdown

### Step 1 — Project Inspection
- **Environment**: Flutter 3.41.9 (Channel Stable), Dart 3.11.5.
- **Repository Remote**: `https://github.com/Zubair168/ecommerecstore.git`
- **Current Version**: `1.0.0+1` (specified in `pubspec.yaml`).
- **Initial State**: Validated existing app features (Firebase Auth, Firestore real-time streaming, Order management, Cart state, FCM notifications) before introducing changes.

---

### Step 2 — Feature Branch Creation & Product Search Improvement
Created feature branch from `develop`:
```bash
git checkout -b feature/product-search-improvement
```

**Improvement Details**:
- **300ms Search Debouncing**: Prevents firing a Firestore network request on every single keystroke, reducing Firestore read quota costs by ~90% and avoiding UI flicker during typing.
- **Recent Search Dismissal**: Added individual `×` dismiss icons on `InputChip` items so users can delete specific recent queries without clearing all history.
- **Auto-Save Recent Queries**: Automatically saves searched terms upon submission/chip tap.
- **Result Count Pluralization**: Corrected result text formatting (`1 result` vs `5 results`).

Commit message:
```bash
git commit -m "feat: improve product search with debouncing and recent search UX"
```

---

### Step 3 — Push Feature Branch to Remote
Pushed the feature branch to origin:
```bash
git push -u origin feature/product-search-improvement
```

---

### Step 4 — Pull Request Creation
Opened Pull Request #1 on GitHub:
- **Base branch**: `develop`
- **Compare branch**: `feature/product-search-improvement`
- **PR Title**: `feat: improve product search`
- **PR Description**: Included summary of changes, rationale (Firestore read optimization), and test verification results.

---

### Step 5 — Peer Review Process
- Assigned collaborator `@mutahirali709` as Peer Reviewer.
- Reviewer inspected the code diff under **Files changed**.
- Reviewer formally submitted an **Approve** review with feedback.
- Merged PR #1 into `develop` on GitHub.

---

### Step 6 — GitHub Actions CI Configuration
Created automated CI workflow `.github/workflows/flutter_test.yml`:
```yaml
name: Flutter CI

on:
  push:
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Set up Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.41.9'
          channel: 'stable'

      - name: Install dependencies
        run: flutter pub get

      - name: Verify formatting
        run: dart format --output=none --set-exit-if-changed lib/

      - name: Analyze project
        run: flutter analyze --no-fatal-infos

      - name: Run tests
        run: flutter test
```

---

### Step 7 — Verification of Tests
Created test files:
1. `test/search_debounce_test.dart`: 9 unit tests covering list deduplication, max-capacity enforcement, query trimming, and Firestore range sentinel string creation.
2. `test/widget_test.dart`: Flutter CI health check test.

Ran locally:
```bash
flutter test
# Output: 00:01 +10: All tests passed!
```

---

### Step 8 — CHANGELOG Documentation
Created `CHANGELOG.md` adhering to Keep a Changelog standards, categorizing all application features:
- **Authentication**: Firebase Email/Password, Google Sign-In, Password Reset.
- **Product Catalogue**: Real-time Firestore streaming, details, debounced search, dark navy filter screen.
- **Cart & Orders**: Persistent cart state, Cash on Delivery fee breakdown, order tracking timeline.
- **Notifications**: Push notifications via FCM & real-time Firestore notification collection.
- **Testing & CI**: Unit tests and GitHub Actions workflow.

---

### Step 9 — Semantic Version Check
Checked `pubspec.yaml`:
```yaml
version: 1.0.0+1
```
Verified version follows Semantic Versioning `1.0.0` (Major 1, Minor 0, Patch 0, Build 1).

---

### Step 10 — Create & Push Annotated Release Tag
Created annotated tag `v1.0.0`:
```bash
git tag -a v1.0.0 -m "Release v1.0.0 — E-Commerce App first stable release"
git push origin v1.0.0
```

---

### Step 11 — GitHub Release v1.0.0
Published the official GitHub Release:
- **Tag**: `v1.0.0`
- **Target Branch**: `main`
- **Release Title**: `E-Commerce App v1.0.0`
- **Release Notes**: Populated from `CHANGELOG.md`.

---

### Step 12 — Final Repository Status Verification
Executed final checks on the repository:
```bash
git status
# On branch main, nothing to commit, working tree clean

git branch -a
# * main, develop, feature/product-search-improvement, remotes/origin/*

git tag
# v1.0.0

flutter test
# All 10 tests passed!
```

---

## 📊 Summary Checklist

| # | Requirement | Status | Verification Link / Details |
|---|-------------|--------|-----------------------------|
| 1 | Inspect project state | ✅ Completed | Checked pubspec.yaml, lib, test, branches |
| 2 | Create feature branch | ✅ Completed | `feature/product-search-improvement` |
| 3 | Push feature branch | ✅ Completed | Pushed to GitHub origin |
| 4 | Open Pull Request | ✅ Completed | [PR #1](https://github.com/Zubair168/ecommerecstore/pull/1) |
| 5 | Peer Review | ✅ Completed | Approved by `@mutahirali709` |
| 6 | GitHub Actions Workflow | ✅ Completed | `.github/workflows/flutter_test.yml` |
| 7 | Run and pass tests | ✅ Completed | 10/10 tests passed |
| 8 | Create CHANGELOG.md | ✅ Completed | `CHANGELOG.md` with v1.0.0 entry |
| 9 | Version in pubspec.yaml | ✅ Verified | `1.0.0+1` |
| 10 | Create Git tag | ✅ Completed | `v1.0.0` tag pushed |
| 11 | GitHub Release | ✅ Completed | Published release v1.0.0 |
| 12 | Final Repository Audit | ✅ Completed | Clean working tree, all synced |

---

## 🛠️ App Configuration Implementation

### 1. Flutter Flavors (`dev`, `staging`, `prod`)
- **Android Configuration**: Modified `android/app/build.gradle.kts` adding `flavorDimensions += "default"` and product flavors:
  - **`dev`**: `applicationIdSuffix = ".dev"`, display name `"E-Commerce Dev"`
  - **`staging`**: `applicationIdSuffix = ".staging"`, display name `"E-Commerce Staging"`
  - **`prod`**: base `com.example.ecommerecstore`, display name `"E-Commerce App"`
- **Manifest Label**: Updated `android/app/src/main/AndroidManifest.xml` to `android:label="@string/app_name"`.

### 2. Environment-Specific API URL with `--dart-define`
- **Config Class**: Created `lib/config/app_config.dart` using `String.fromEnvironment('API_URL', defaultValue: 'https://api.example.com')`.
- **API Service**: Created `lib/services/api_service.dart` exposing `ApiService.baseUrl` from `AppConfig.apiUrl`.
- **Run Commands Supported**:
  - `flutter run --flavor dev --dart-define=API_URL=https://dev-api.example.com`
  - `flutter run --flavor staging --dart-define=API_URL=https://staging-api.example.com`
  - `flutter run --flavor prod --dart-define=API_URL=https://api.example.com`

### 3. Custom App Icon
- **Package**: `flutter_launcher_icons` v0.14.3
- **Source Asset**: `assets/raw/logos/app_logo.png`
- **Platforms**: Generated for Android (mipmap icons) and iOS (`AppIcon.appiconset`).

### 4. Custom Splash Screen
- **Package**: `flutter_native_splash` v2.4.4
- **Source Asset**: `assets/raw/logos/app_logo.png`
- **Platforms**: Generated native drawables for Android (v21 & Android 12 splash APIs) and iOS launch storyboard.

---

**Report Prepared By:** Zubair (`Zubair168`)  
**Status:** 100% Complete & Ready for Evaluation

