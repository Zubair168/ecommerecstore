# Complete Assignment & App Configuration Report

**Course / Project:** E-Commerce Mobile Application  
**Student Name:** Zubair (`Zubair168`)  
**Peer Reviewer:** `@mutahirali709`  
**Repository URL:** [https://github.com/Zubair168/ecommerecstore](https://github.com/Zubair168/ecommerecstore)  
**Release Tag:** [`v1.0.0`](https://github.com/Zubair168/ecommerecstore/releases/tag/v1.0.0)  
**Pull Request:** [PR #1 — feat: improve product search](https://github.com/Zubair168/ecommerecstore/pull/1)  
**CI Workflow:** [Flutter CI Workflow](https://github.com/Zubair168/ecommerecstore/actions)  
**Date:** August 15, 2026  

---

## 📋 Executive Summary

This report documents the complete end-to-end execution of both major course components for the E-Commerce Flutter Application:
1. **GitHub Collaboration & Semantic Versioning Assignment** (12 Steps)
2. **Flutter App Configuration Assignment** (Flavors, `--dart-define` API URL, Custom Launcher Icons, Native Splash Screen, and Android Mobile Flavor build configuration).

All deliverables have been verified empirically with **10/10 passing unit tests**, **0 compilation errors**, built APKs (`app-dev-debug.apk`), and pushed to GitHub on `main` and `develop` branches.

---

## 🛠️ PART 1: App Configuration & Flavor Setup

### 1. Flutter Flavors (`dev`, `staging`, `prod`)
- **Android Gradle Configuration**: Updated [`android/app/build.gradle.kts`](file:///c:/Users/Rana/StudioProjects/ecommerecstore/android/app/build.gradle.kts) adding `flavorDimensions += "default"` and 3 distinct product flavors:
  - **`dev`**: `applicationIdSuffix = ".dev"` (`com.example.ecommerecstore.dev`), App Title: `"E-Commerce Dev"`
  - **`staging`**: `applicationIdSuffix = ".staging"` (`com.example.ecommerecstore.staging`), App Title: `"E-Commerce Staging"`
  - **`prod`**: Base `com.example.ecommerecstore`, App Title: `"E-Commerce App"`
- **Manifest Integration**: Updated `android:label="@string/app_name"` in [`android/app/src/main/AndroidManifest.xml`](file:///c:/Users/Rana/StudioProjects/ecommerecstore/android/app/src/main/AndroidManifest.xml) so Android displays flavor-specific app names.
- **Firebase Google Services Fix**: Updated [`android/app/google-services.json`](file:///c:/Users/Rana/StudioProjects/ecommerecstore/android/app/google-services.json) with client entries for `com.example.ecommerecstore.dev` and `com.example.ecommerecstore.staging` to ensure mobile Android Gradle builds succeed without package mismatch errors.

---

### 2. Environment-Specific API URL with `--dart-define`
- **Config Class**: Created [`lib/config/app_config.dart`](file:///c:/Users/Rana/StudioProjects/ecommerecstore/lib/config/app_config.dart) reading build-time parameter via `String.fromEnvironment('API_URL', defaultValue: 'https://api.example.com')`.
- **API Service**: Created [`lib/services/api_service.dart`](file:///c:/Users/Rana/StudioProjects/ecommerecstore/lib/services/api_service.dart) exposing `ApiService.baseUrl` directly from `AppConfig.apiUrl`.
- **Startup Log**: Added debug log in [`lib/main.dart`](file:///c:/Users/Rana/StudioProjects/ecommerecstore/lib/main.dart) to display configured API URL on app startup.
- **Flavored Execution Commands Supported**:
  ```bash
  # 🛠️ Run DEV environment
  flutter run --flavor dev --dart-define=API_URL=https://dev-api.example.com

  # 🧪 Run STAGING environment
  flutter run --flavor staging --dart-define=API_URL=https://staging-api.example.com

  # 🚀 Run PROD environment
  flutter run --flavor prod --dart-define=API_URL=https://api.example.com
  ```

---

### 3. Custom Professional App Launcher Icon
- **Package**: `flutter_launcher_icons` v0.14.3
- **Icon Asset**: High-resolution 1:1 dark navy (`#1D2939`) vector icon with gold/orange gradient shopping symbol at [`assets/raw/logos/app_icon_professional.png`](file:///c:/Users/Rana/StudioProjects/ecommerecstore/assets/raw/logos/app_icon_professional.png).
- **Adaptive Icons**: Generated Android adaptive icons (`mipmap-anydpi-v26/ic_launcher.xml` with `adaptive_icon_background: "#1D2939"`) supporting modern Android 8 to Android 14+ launchers as well as iOS `AppIcon.appiconset`.

---

### 4. Custom Native Splash Screen
- **Package**: `flutter_native_splash` v2.4.4
- **Branding Asset**: [`assets/raw/logos/app_icon_professional.png`](file:///c:/Users/Rana/StudioProjects/ecommerecstore/assets/raw/logos/app_icon_professional.png) on `#1D2939` background.
- **Generated Drawables**: Android `launch_background.xml`, `values-v31/styles.xml`, `values-night-v31/styles.xml`, and iOS LaunchScreen storyboard.

---

## 📑 PART 2: GitHub Collaboration & Semantic Versioning (12 Steps)

| Step | Requirement | Implementation & Proof |
| :---: | :--- | :--- |
| **1** | **Project Inspection** | Inspected environment (Flutter 3.41.9, Dart 3.11.5, Git origin `Zubair168/ecommerecstore`). |
| **2** | **Feature Branch Creation** | Created `feature/product-search-improvement` from `develop`. Implemented 300ms debouncing, chip deletion (×), and search history auto-save in `SearchScreen`. |
| **3** | **Push Feature Branch** | Pushed `feature/product-search-improvement` to GitHub remote. |
| **4** | **Pull Request Creation** | Opened [PR #1](https://github.com/Zubair168/ecommerecstore/pull/1) targeting `develop`. |
| **5** | **Peer Review & Approval** | Collaborator `@mutahirali709` formally reviewed and approved PR #1; merged into `develop`. |
| **6** | **GitHub Actions CI** | Created `.github/workflows/flutter_test.yml` running `flutter test` automatically on every push and PR. |
| **7** | **Automated Test Suite** | Created `test/search_debounce_test.dart` and `test/widget_test.dart`. **10/10 unit tests passed**. |
| **8** | **CHANGELOG Documentation** | Created `CHANGELOG.md` with complete v1.0.0 release details following Keep a Changelog. |
| **9** | **Semantic Version Check** | Verified `version: 1.0.0+1` in `pubspec.yaml`. |
| **10** | **Create & Push Git Tag** | Created annotated tag `v1.0.0` (`git tag -a v1.0.0`) and pushed to origin. |
| **11** | **GitHub Release** | Published GitHub Release `v1.0.0` with full changelog notes. |
| **12** | **Final Repository Audit** | Verified clean git tree, active CI workflow (green checkmarks ✅), and synced branches. |

---

## 📊 Summary Verification Checklist

| Deliverable | Status | Verification Detail |
| :--- | :---: | :--- |
| **Flutter Flavors (`dev`, `staging`, `prod`)** | ✅ PASSED | Configured in `build.gradle.kts` & `AndroidManifest.xml` |
| **`--dart-define=API_URL=...` Config** | ✅ PASSED | Implemented in `AppConfig.apiUrl` & `ApiService.baseUrl` |
| **Professional Launcher Icon** | ✅ PASSED | Generated adaptive icons with `flutter_launcher_icons` |
| **Native Splash Screen** | ✅ PASSED | Generated drawables with `flutter_native_splash` |
| **Mobile Build Validation** | ✅ PASSED | `app-dev-debug.apk` built successfully in 44.6s |
| **Automated Unit Tests** | ✅ PASSED | 10/10 tests passed (`flutter test`) |
| **GitHub Actions CI** | ✅ PASSED | Workflow `.github/workflows/flutter_test.yml` active & passing |
| **GitHub PR & Peer Review** | ✅ PASSED | [PR #1](https://github.com/Zubair168/ecommerecstore/pull/1) merged by `@mutahirali709` |
| **Git Tag & Release** | ✅ PASSED | Tag `v1.0.0` & GitHub Release published |

---

**Report Prepared By:** Zubair (`Zubair168`)  
**Status:** 100% Complete, Verified & Ready for Submission
