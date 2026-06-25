#!/bin/bash
set -e

VERSION_NAME="1.0.0"
VERSION_CODE=1

# ===============================
# Colors
# ===============================
RED='\033[0;31m'
error() {
  echo "${RED} $1"
  exit 1
}

# ===============================
# Select platform
# ===============================
read -p "Platform (android / ios): " PLATFORM

if [[ "$PLATFORM" != "android" && "$PLATFORM" != "ios" ]]; then
  error "Invalid platform"
fi

# ===============================
# Select package type
# ===============================
if [[ "$PLATFORM" == "android" ]]; then
  read -p "Build type (apk / aab): " PACKAGE_TYPE
  if [[ "$PACKAGE_TYPE" != "apk" && "$PACKAGE_TYPE" != "aab" ]]; then
    error "Invalid build type. Must be apk or aab"
  fi
else
  read -p "Build type (device / store): " PACKAGE_TYPE
  if [[ "$PACKAGE_TYPE" != "device" && "$PACKAGE_TYPE" != "store" ]]; then
    error "Invalid build type. Must be device or store"
  fi
  # Map to flutter build ios options
  if [[ "$PACKAGE_TYPE" == "device" ]]; then
    PACKAGE_TYPE="ios"
  else
    PACKAGE_TYPE="ipa"
  fi
fi

# ===============================
# Info
# ===============================
echo "--------------------------------"
echo "Platform     : $PLATFORM"
echo "Package type : $PACKAGE_TYPE"
echo "VersionName  : $VERSION_NAME"
echo "VersionCode  : $VERSION_CODE"
echo "--------------------------------"

# ===============================
# Build
# ===============================
if [[ "$PLATFORM" == "android" ]]; then
  fvm flutter build "$PACKAGE_TYPE" \
    --build-name="$VERSION_NAME" \
    --build-number="$VERSION_CODE"
else
  fvm flutter build "$PACKAGE_TYPE" \
    --build-name="$VERSION_NAME" \
    --build-number="$VERSION_CODE"
fi

