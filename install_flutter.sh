#!/bin/bash

# Flutter installation script for Netlify
set -e

echo "🚀 Installing Flutter for Netlify deployment..."

# Set Flutter version
FLUTTER_VERSION=${FLUTTER_VERSION:-"3.24.3"}
FLUTTER_HOME="/opt/flutter"

# Check if Flutter is already installed
if [ -d "$FLUTTER_HOME" ]; then
    echo "✅ Flutter already installed at $FLUTTER_HOME"
    export PATH="$FLUTTER_HOME/bin:$PATH"
    flutter --version
    exit 0
fi

echo "📦 Downloading Flutter $FLUTTER_VERSION..."

# Download and extract Flutter
cd /opt
wget -q https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz
tar xf flutter_linux_${FLUTTER_VERSION}-stable.tar.xz
rm flutter_linux_${FLUTTER_VERSION}-stable.tar.xz

# Add Flutter to PATH
export PATH="$FLUTTER_HOME/bin:$PATH"

echo "🔧 Configuring Flutter..."

# Disable analytics and crash reporting
flutter config --no-analytics
flutter config --no-crash-reporting

# Accept licenses
flutter doctor --android-licenses || true

# Enable web support
flutter config --enable-web

echo "✅ Flutter installation completed!"
flutter --version
flutter doctor -v
