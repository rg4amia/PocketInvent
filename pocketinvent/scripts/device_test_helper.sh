#!/bin/bash

# Device Testing Helper Script
# This script helps automate device testing for PocketInvent

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}PocketInvent Device Testing Helper${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Function to list available devices
list_devices() {
    echo -e "${YELLOW}Available Devices:${NC}"
    flutter devices
    echo ""
}

# Function to run on specific device
run_on_device() {
    local device_id=$1
    echo -e "${GREEN}Running on device: ${device_id}${NC}"
    cd "$(dirname "$0")/.." || exit
    flutter run -d "$device_id"
}

# Function to run tests
run_tests() {
    echo -e "${GREEN}Running device validation tests...${NC}"
    cd "$(dirname "$0")/.." || exit
    flutter test test/device_validation_test.dart
}

# Function to build for iOS
build_ios() {
    echo -e "${GREEN}Building iOS release...${NC}"
    cd "$(dirname "$0")/.." || exit
    flutter build ios --release
}

# Function to build for Android
build_android() {
    echo -e "${GREEN}Building Android APK...${NC}"
    cd "$(dirname "$0")/.." || exit
    flutter build apk --release
}

# Function to analyze app size
analyze_size() {
    echo -e "${GREEN}Analyzing app size...${NC}"
    cd "$(dirname "$0")/.." || exit
    echo -e "${YELLOW}iOS:${NC}"
    flutter build ios --analyze-size
    echo ""
    echo -e "${YELLOW}Android:${NC}"
    flutter build apk --analyze-size
}

# Function to run performance profiling
run_profile() {
    local device_id=$1
    echo -e "${GREEN}Running performance profile on: ${device_id}${NC}"
    cd "$(dirname "$0")/.." || exit
    flutter run --profile -d "$device_id"
}

# Function to check Flutter doctor
check_flutter() {
    echo -e "${GREEN}Checking Flutter setup...${NC}"
    flutter doctor -v
}

# Function to clean build
clean_build() {
    echo -e "${GREEN}Cleaning build artifacts...${NC}"
    cd "$(dirname "$0")/.." || exit
    flutter clean
    flutter pub get
}

# Main menu
show_menu() {
    echo -e "${BLUE}What would you like to do?${NC}"
    echo "1) List available devices"
    echo "2) Run on specific device"
    echo "3) Run device validation tests"
    echo "4) Build iOS release"
    echo "5) Build Android APK"
    echo "6) Analyze app size"
    echo "7) Run performance profile"
    echo "8) Check Flutter setup"
    echo "9) Clean build"
    echo "0) Exit"
    echo ""
    read -p "Enter your choice: " choice
    
    case $choice in
        1)
            list_devices
            show_menu
            ;;
        2)
            list_devices
            read -p "Enter device ID: " device_id
            run_on_device "$device_id"
            ;;
        3)
            run_tests
            show_menu
            ;;
        4)
            build_ios
            show_menu
            ;;
        5)
            build_android
            show_menu
            ;;
        6)
            analyze_size
            show_menu
            ;;
        7)
            list_devices
            read -p "Enter device ID: " device_id
            run_profile "$device_id"
            ;;
        8)
            check_flutter
            show_menu
            ;;
        9)
            clean_build
            show_menu
            ;;
        0)
            echo -e "${GREEN}Goodbye!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid choice. Please try again.${NC}"
            show_menu
            ;;
    esac
}

# Quick test shortcuts
if [ "$1" == "list" ]; then
    list_devices
elif [ "$1" == "test" ]; then
    run_tests
elif [ "$1" == "ios" ]; then
    build_ios
elif [ "$1" == "android" ]; then
    build_android
elif [ "$1" == "clean" ]; then
    clean_build
elif [ "$1" == "doctor" ]; then
    check_flutter
else
    show_menu
fi
