#!/bin/sh

# Fail this script if any subcommand fails.
set -e

# The default execution directory of this script is the ci_script directory
cd $CI_PRIMARY_REPOSITORY_PATH

# Install flutter using git.
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
export PATH="$PATH:$HOME/flutter/bin"

# Install flutter artifacts for iOS (--ios)
flutter precache --ios

# Install flutter dependencies
flutter pub get

# Install Cocoapods using homebrew
HOMEBREW_NO_AUTO_UPDATE=1 # disable homebrew's automatic update
brew install cocoapods

# Install cocoapods dependencies
cd ios && pod install

exit 0
