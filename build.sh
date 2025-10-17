#!/bin/bash

# Install Flutter if not available
if ! command -v flutter &> /dev/null; then
    echo "Flutter not found. Please install Flutter first."
    exit 1
fi

# Get Flutter dependencies
echo "Getting Flutter dependencies..."
flutter pub get

# Build for web
echo "Building Flutter web app..."
flutter build web --release

# Copy _redirects file to build directory
echo "Copying _redirects file..."
cp _redirects build/web/

echo "Build completed successfully!"
echo "Deploy the 'build/web' directory to Netlify"
