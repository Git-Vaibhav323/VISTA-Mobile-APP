#!/bin/bash
set -e

echo "🚀 Starting Flutter web build process..."

# Check if Flutter is already installed
if [ -d "/opt/flutter" ]; then
    echo "✅ Flutter already exists, using cached version"
    export PATH=/opt/flutter/bin:$PATH
else
    echo "📦 Installing Flutter..."
    
    # Create directory and download Flutter
    mkdir -p /opt
    cd /opt
    
    # Try different Flutter download methods
    echo "📥 Trying direct download with curl..."
    if curl -fsSL https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.22.2-stable.tar.xz -o flutter.tar.xz; then
        echo "✅ Curl download successful"
    else
        echo "📥 Trying alternative download..."
        # Try a different version that's known to work
        if curl -fsSL https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.19.6-stable.tar.xz -o flutter.tar.xz; then
            echo "✅ Alternative version download successful"
        else
            echo "📥 Trying git clone method..."
            git clone https://github.com/flutter/flutter.git -b stable --depth 1
            if [ -d "flutter" ]; then
                echo "✅ Git clone successful"
                mv flutter /opt/
                export PATH=/opt/flutter/bin:$PATH
                flutter --version
                cd $BUILD_DIR || cd /opt/build/repo
                echo "🔧 Configuring Flutter..."
                flutter config --no-analytics || echo "Warning: Could not disable analytics"
                flutter config --enable-web || echo "Warning: Could not enable web"
                # Skip to dependencies section
                echo "📦 Preparing for web build..."
                if [ -f "pubspec_web.yaml" ]; then
                    echo "Using web-compatible dependencies..."
                    cp pubspec_web.yaml pubspec.yaml
                fi
                flutter clean || echo "Warning: Flutter clean failed"
                echo "📦 Getting dependencies..."
                flutter pub get
                echo "🏗️ Building web application..."
                flutter build web --release --web-renderer html
                if [ -d "build/web" ]; then
                    echo "✅ Build completed successfully!"
                    ls -la build/web/
                    exit 0
                else
                    echo "❌ Build failed"
                    exit 1
                fi
            else
                echo "❌ All download methods failed"
                exit 1
            fi
        fi
    fi
    
    # Extract Flutter if we have the tar file
    if [ -f "flutter.tar.xz" ]; then
        echo "📂 Extracting Flutter..."
        tar -xf flutter.tar.xz
        rm flutter.tar.xz
    fi
    
    echo "✅ Flutter installation completed"
fi

# Add Flutter to PATH
export PATH=/opt/flutter/bin:$PATH

# Go back to project directory
cd $BUILD_DIR || cd /opt/build/repo

echo "🔧 Configuring Flutter..."
# Configure Flutter with error handling
flutter config --no-analytics || echo "Warning: Could not disable analytics"
flutter config --enable-web || echo "Warning: Could not enable web"

# Verify Flutter installation
echo "🔍 Verifying Flutter installation..."
flutter --version
flutter doctor || echo "Warning: Flutter doctor found issues, continuing anyway"

echo "📦 Preparing for web build..."
# Use web-compatible pubspec if it exists
if [ -f "pubspec_web.yaml" ]; then
    echo "Using web-compatible dependencies..."
    cp pubspec_web.yaml pubspec.yaml
fi

# Clean and get dependencies
flutter clean || echo "Warning: Flutter clean failed"

echo "📦 Getting dependencies..."
flutter pub get || {
    echo "❌ pub get failed, trying to fix..."
    flutter pub deps
    flutter pub get
}

# Check for common web build issues
echo "🔍 Checking for web compatibility..."
flutter pub deps | grep -E "(camera|image_picker|permission_handler|mobile_scanner|speech_to_text)" || echo "Web-incompatible packages detected, continuing anyway..."

echo "🏗️ Building web application..."
# Build with web-specific optimizations
flutter build web --release --web-renderer html --dart-define=FLUTTER_WEB_USE_SKIA=false

# Verify build output
if [ -d "build/web" ]; then
    echo "✅ Build completed successfully!"
    echo "📁 Build output directory contents:"
    ls -la build/web/
else
    echo "❌ Build failed - no output directory found"
    exit 1
fi
