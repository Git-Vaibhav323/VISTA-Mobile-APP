#!/bin/bash
set -e

echo "🚀 Simple Flutter Web Build"

# Use snap to install Flutter (available on Netlify)
echo "📦 Installing Flutter via snap..."
sudo snap install flutter --classic

# Add Flutter to PATH
export PATH="/snap/bin:$PATH"

# Verify Flutter
echo "🔍 Verifying Flutter..."
flutter --version

# Configure Flutter
echo "🔧 Configuring Flutter..."
flutter config --no-analytics
flutter config --enable-web

# Use web-compatible dependencies
if [ -f "pubspec_web.yaml" ]; then
    echo "📦 Using web-compatible dependencies..."
    cp pubspec_web.yaml pubspec.yaml
fi

# Get dependencies and build
echo "📦 Getting dependencies..."
flutter pub get

echo "🏗️ Building for web..."
flutter build web --release

echo "✅ Build completed!"
ls -la build/web/
