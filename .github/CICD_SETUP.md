# GitHub Actions CI/CD Setup Guide

## 📋 Overview
This workflow automatically builds your Flutter app for multiple platforms and creates downloadable artifacts on every push to main/master/develop branches.

## 🚀 What Gets Built

The workflow builds your app for:
- **Android**: APK and AAB (App Bundle) files
- **iOS**: Unsigned iOS build (requires macOS runner)

## ⚙️ GitHub Settings Configuration

### 1. Enable GitHub Actions
1. Go to your repository on GitHub
2. Click on **Settings** tab
3. Navigate to **Actions** → **General**
4. Under "Actions permissions", select:
   - ✅ **Allow all actions and reusable workflows**
5. Under "Workflow permissions", select:
   - ✅ **Read and write permissions**
   - ✅ **Allow GitHub Actions to create and approve pull requests**
6. Click **Save**

### 2. Set Up Secrets (Optional - for Advanced Features)

If you want to deploy to stores or sign your apps, navigate to **Settings** → **Secrets and variables** → **Actions**:

#### For Android Signing:
- `ANDROID_KEYSTORE_BASE64`: Base64 encoded keystore file
- `ANDROID_KEYSTORE_PASSWORD`: Keystore password
- `ANDROID_KEY_ALIAS`: Key alias
- `ANDROID_KEY_PASSWORD`: Key password

#### For iOS Signing:
- `IOS_CERTIFICATE_BASE64`: Base64 encoded certificate
- `IOS_PROVISIONING_PROFILE_BASE64`: Base64 encoded provisioning profile
- `IOS_CERTIFICATE_PASSWORD`: Certificate password

#### For Firebase/Play Store Deployment:
- `FIREBASE_TOKEN`: Firebase CLI token
- `PLAY_STORE_SERVICE_ACCOUNT_JSON`: Google Play service account JSON

### 3. Branch Protection (Recommended)
1. Go to **Settings** → **Branches**
2. Click **Add branch protection rule**
3. For branch name pattern, enter: `main` (or `master`)
4. Enable:
   - ✅ **Require status checks to pass before merging**
   - ✅ **Require branches to be up to date before merging**
   - Select the test job as required
5. Click **Create**

## 📦 How to Access Artifacts

### Method 1: From Workflow Runs
1. Go to your repository on GitHub
2. Click on **Actions** tab
3. Click on any completed workflow run
4. Scroll down to **Artifacts** section
5. Download any of:
   - `android-apk-release` - APK file
   - `android-aab-release` - App Bundle for Play Store
   - `ios-release-unsigned` - iOS build (needs signing)

Artifacts are retained for 30 days.

### Method 2: GitHub Releases (when you create tags)
When you push a git tag starting with 'v' (e.g., v1.0.0):
```bash
git tag v1.0.0
git push origin v1.0.0
```

The workflow will automatically create a GitHub Release with all build artifacts attached.

## 🔧 Workflow Triggers

The workflow runs automatically on:
- **Push** to `main`, `master`, or `develop` branches
- **Pull requests** to `main`, `master`, or `develop` branches
- **Manual trigger** via GitHub Actions UI
- **Tags** starting with `v` (creates releases)

## 📝 Customization Options

### Change Flutter Version
Edit `.github/workflows/flutter-ci-cd.yml`:
```yaml
flutter-version: '3.38.9'  # Change to your desired version
```

### Add More Platforms
You can add Web or Linux builds by adding additional jobs:
```yaml
build-web:
  name: Build Web
  needs: test
  runs-on: ubuntu-latest
  steps:
    # Add steps for: flutter build web --release
```

### Modify Retention Period
Change `retention-days: 30` to your preferred number (max 90 days).

### Skip Specific Platforms
Comment out or remove the entire job section you don't need.

## 🧪 Testing Locally

Before pushing, test your build commands locally:
```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS (on macOS machine)
flutter build ios --release --no-codesign
```

## 📊 Status Badge

Add this to your README.md to show build status:
```markdown
![Flutter CI/CD](https://github.com/YOUR_USERNAME/YOUR_REPO_NAME/workflows/Flutter%20CI/CD/badge.svg)
```

Replace `YOUR_USERNAME` and `YOUR_REPO_NAME` with your actual values.

## 🐛 Troubleshooting

### Build Fails
- Check the **Actions** tab for detailed logs
- Ensure all dependencies in `pubspec.yaml` are compatible
- Verify Flutter version matches your local development

### Artifacts Not Created
- Ensure workflow completes successfully
- Check that build outputs exist in expected paths
- Verify Actions permissions are set correctly

### iOS Build Fails
- iOS builds require a macOS runner (costs apply for private repos)
- Consider disabling iOS builds if not needed
- For signed builds, you need proper certificates and provisioning profiles

## 💡 Tips

1. **Free Minutes**: GitHub provides free Action minutes:
   - Public repos: Unlimited
   - Private repos: 2,000 minutes/month (Free plan)

2. **Speed Up Builds**: The workflow uses caching for Flutter SDK and dependencies

3. **Parallel Builds**: All platform builds run in parallel after tests pass

4. **Manual Runs**: Use "workflow_dispatch" trigger to manually run from Actions tab

## 🔐 Security Best Practices

- Never commit secrets or API keys
- Use GitHub Secrets for sensitive data
- Review third-party actions before using
- Keep dependencies updated
- Enable Dependabot alerts

## 📚 Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Flutter CI/CD Best Practices](https://docs.flutter.dev/deployment/cd)
- [Subosito Flutter Action](https://github.com/subosito/flutter-action)

---

**Need Help?** Check the Actions tab for detailed logs or create an issue in the repository.
