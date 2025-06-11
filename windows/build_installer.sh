#!/bin/bash

echo "Building Windows installer..."

# Navigate to windows directory
cd windows

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo "Installing dependencies..."
    npm install
fi

# Build Windows installer
echo "Creating Windows installer..."
npm run build-win

echo "Windows installer created in dist/"
ls -la dist/

# Move installer to parent directory
if [ -f "dist/Sleeping Cat Setup 1.1.0.exe" ]; then
    cp "dist/Sleeping Cat Setup 1.1.0.exe" "../SleepingCat-Windows-v1.1-Setup.exe"
    echo "Installer copied to: SleepingCat-Windows-v1.1-Setup.exe"
fi