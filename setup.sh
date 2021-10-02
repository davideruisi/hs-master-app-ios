#!/bin/sh
set -e

# Create SwiftGen files if not existing yet.
touch HSMaster/Resources/Color.swift
touch HSMaster/Resources/Localization.swift

# Install XcodeGen if needed.
if ! command -v xcodegen &> /dev/null
then
    echo "XcodeGen could not be found and will be installed."
    brew install xcodegen
fi

# Generate xcodeproj file.
echo "Generating xcodeproj file."
xcodegen generate

# Install Cocoapods if needed.
if ! command -v pod &> /dev/null
then
    echo "Cocoapods could not be found and will be installed."
    sudo gem install cocoapods -v 1.11.2
fi

# Install pods.
echo "Installing pods."
pod install
