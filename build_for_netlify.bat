@echo off
echo 🚀 Building Flutter Web App for Netlify Deployment

REM Use web-compatible dependencies
if exist pubspec_web.yaml (
    echo 📦 Using web-compatible dependencies...
    copy pubspec_web.yaml pubspec.yaml
)

REM Clean and get dependencies
echo 🧹 Cleaning project...
flutter clean

echo 📦 Getting dependencies...
flutter pub get

echo 🏗️ Building for web...
flutter build web --release --web-renderer html

echo ✅ Build completed!
echo 📁 Your deployable files are in: build\web\
echo 🌐 Upload the build\web folder to Netlify manually

pause
