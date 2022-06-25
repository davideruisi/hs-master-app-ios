#!/bin/sh
set -e

# Install Tuist if needed.
if ! command -v tuist &> /dev/null
then
    echo "Tuist could not be found and will be installed."
    curl -Ls https://install.tuist.io | bash
fi

# Generate xcodeproj file.
echo "Generating xcodeproj file."
tuist generate --no-open

# Install Cocoapods if needed.
if ! command -v pod &> /dev/null
then
    echo "Cocoapods could not be found and will be installed."
    sudo gem install cocoapods -v 1.11.2
fi

# Install pods.
echo "Installing pods."
pod install

# Open workspace
echo "Opening HSMaster.xcworkspace"
open HSMaster.xcworkspace