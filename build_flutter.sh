#!/bin/bash
set -e

echo "🚀 Starting Flutter web build for Netlify..."

# Install Flutter
export FLUTTER_HOME=/opt/flutter
export PATH=$FLUTTER_HOME/bin:$PATH

if [ ! -d "$FLUTTER_HOME" ]; then
  echo "📦 Installing Flutter..."
  cd /opt
  wget -q https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.22.2-stable.tar.xz
  tar xf flutter_linux_3.22.2-stable.tar.xz
  rm flutter_linux_3.22.2-stable.tar.xz
  echo "✅ Flutter installed successfully!"
else
  echo "✅ Flutter already installed"
fi

# Configure Flutter
echo "🔧 Configuring Flutter..."
flutter config --no-analytics
flutter config --enable-web

# Check Flutter installation
echo "🔍 Checking Flutter installation..."
flutter doctor

# Build the app
echo "📱 Building Flutter web app..."
flutter pub get
flutter build web --release

echo "🎉 Build completed successfully!"
echo "📁 Build output is in: build/web/"
