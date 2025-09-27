#!/bin/bash

# Taskify Build Script
echo "Building Taskify macOS App..."

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "Error: Xcode command line tools not found. Please install Xcode."
    exit 1
fi

# Build the project
echo "Compiling Swift files..."
xcodebuild -project Taskify.xcodeproj -scheme Taskify -configuration Debug build

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo "You can now run the app from Xcode or find it in the build directory."
else
    echo "❌ Build failed. Please check the errors above."
    exit 1
fi
