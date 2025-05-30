#!/bin/bash

# Create app bundle structure
APP_NAME="Sleeping Cat.app"
CONTENTS_DIR="$APP_NAME/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"

echo "Creating app bundle: $APP_NAME"

# Clean up old bundle if exists
rm -rf "$APP_NAME"

# Create directories
mkdir -p "$MACOS_DIR"
mkdir -p "$RESOURCES_DIR"

# Build the app
echo "Building application..."
swift build -c release

# Copy executable
cp .build/release/SleepingCatApp "$MACOS_DIR/"

# Copy Info.plist
cp Info.plist "$CONTENTS_DIR/"

# Copy icon
cp SleepingCat.icns "$RESOURCES_DIR/"

# Copy video file (using the final version)
echo "Copying video resource..."
cp /Users/KoichiOkawa/Downloads/cat_hybrid_v2_62.mov "$RESOURCES_DIR/cat_video.mov"

# Update the code to use bundled video
echo "Note: The app needs to be updated to use the bundled video from Resources"

# Make executable
chmod +x "$MACOS_DIR/SleepingCatApp"

echo "App bundle created: $APP_NAME"
echo "You can now drag it to Applications folder!"