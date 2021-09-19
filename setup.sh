#!/bin/bash

# Install XcodeGen if needed.
if ! command -v xcodegen &> /dev/null
then
    echo "XcodeGen could not be found and will be installed."
    brew install xcodegen
fi

# Generate xcodeproj file.
echo "Generating xcodeproj file."
xcodegen generate

# Install pods.
echo "Installing pods."
pod install
