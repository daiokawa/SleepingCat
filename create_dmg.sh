#!/bin/bash

echo "Creating DMG installer..."

# Variables
APP_NAME="Sleeping Cat"
DMG_NAME="SleepingCat-v1.0.dmg"
VOLUME_NAME="Sleeping Cat"
DMG_DIR="dmg_temp"

# Clean up any existing DMG or temp directory
rm -rf "$DMG_DIR"
rm -f "$DMG_NAME"

# Create temporary directory
mkdir -p "$DMG_DIR"

# Copy app to temp directory
cp -R "$APP_NAME.app" "$DMG_DIR/"

# Create Applications symlink
ln -s /Applications "$DMG_DIR/Applications"

# Create DMG background instructions
cat > "$DMG_DIR/.background/README.txt" << EOF
Drag Sleeping Cat to Applications folder
EOF

# Create DMG
hdiutil create -volname "$VOLUME_NAME" \
               -srcfolder "$DMG_DIR" \
               -ov \
               -format UDZO \
               "$DMG_NAME"

# Clean up
rm -rf "$DMG_DIR"

echo "DMG created: $DMG_NAME"
echo "Size: $(du -h "$DMG_NAME" | cut -f1)"