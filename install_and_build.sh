#!/bin/bash
set -e

echo "Installing Flutter and building web app..."

# Download and extract Flutter
cd /opt
curl -fsSL https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.22.2-stable.tar.xz | tar -xJ

# Add Flutter to PATH
export PATH=/opt/flutter/bin:$PATH

# Configure Flutter
flutter config --no-analytics
flutter config --enable-web

# Go back to project directory
cd $OLDPWD

# Build the app
flutter pub get
flutter build web --release

echo "Build completed successfully!"
