#!/bin/bash

# Checkout Flow Test Execution Script
# This script runs the comprehensive checkout flow tests for My Demo App iOS

echo "🚀 Starting My Demo App iOS - Checkout Flow Tests"
echo "=================================================="

# Set the project directory
PROJECT_DIR="/Users/vijaypatel/Downloads/my-demo-app-ios-main"
cd "$PROJECT_DIR" || {
    echo "❌ Error: Could not navigate to project directory: $PROJECT_DIR"
    exit 1
}

# Verify workspace exists
if [ ! -f "My Demo App.xcworkspace" ]; then
    echo "❌ Error: My Demo App.xcworkspace not found in $PROJECT_DIR"
    echo "Available files:"
    ls -la | grep -E "\.(xcworkspace|xcodeproj)$"
    exit 1
fi

# Set test configuration
WORKSPACE="My Demo App.xcworkspace"
SCHEME="MyDemoAppUITests"
DESTINATION='platform=iOS Simulator,name=iPhone 14,OS=latest'

echo "📱 Test Configuration:"
echo "   Workspace: $WORKSPACE"
echo "   Scheme: $SCHEME" 
echo "   Destination: $DESTINATION"
echo ""

# Create results directory
RESULTS_DIR="TestResults"
mkdir -p "$RESULTS_DIR"

# Function to check if simulator is available
check_simulator() {
    echo "📱 Checking simulator availability..."
    
    # List available simulators
    xcrun simctl list devices | grep "iPhone 14" | grep "Shutdown\|Booted" || {
        echo "⚠️  iPhone 14 simulator not found. Available simulators:"
        xcrun simctl list devices | grep iPhone
        echo ""
        echo "Using first available iPhone simulator..."
        DESTINATION='platform=iOS Simulator,name=iPhone 15,OS=latest'
    }
}

# Function to clean build
clean_build() {
    echo "🧹 Cleaning build..."
    xcodebuild clean \
        -workspace "$WORKSPACE" \
        -scheme "$SCHEME" >/dev/null 2>&1
}

# Function to build project
build_project() {
    echo "🔨 Building project..."
    xcodebuild build-for-testing \
        -workspace "$WORKSPACE" \
        -scheme "$SCHEME" \
        -destination "$DESTINATION" \
        | grep -E "(error|warning|BUILD)" || echo "Build completed"
}

# Function to run all available tests
run_all_tests() {
    echo "🔄 Running all available UI tests..."
    
    xcodebuild test-without-building \
        -workspace "$WORKSPACE" \
        -scheme "$SCHEME" \
        -destination "$DESTINATION" \
        -resultBundlePath "$RESULTS_DIR/AllUITests_$(date +%Y%m%d_%H%M%S).xcresult" \
        2>&1 | tee "$RESULTS_DIR/all_tests_output.log"
    
    local exit_code=${PIPESTATUS[0]}
    echo "Test execution completed with exit code: $exit_code"
    return $exit_code
}

# Function to run checkout flow tests specifically
run_checkout_tests() {
    echo "🔄 Running checkout flow tests..."
    
    xcodebuild test-without-building \
        -workspace "$WORKSPACE" \
        -scheme "$SCHEME" \
        -destination "$DESTINATION" \
        -only-testing:MyDemoAppUITests/CheckoutFlowTest \
        -resultBundlePath "$RESULTS_DIR/CheckoutFlowTests_$(date +%Y%m%d_%H%M%S).xcresult" \
        2>&1 | tee "$RESULTS_DIR/checkout_tests_output.log"
    
    local exit_code=${PIPESTATUS[0]}
    echo "Checkout tests completed with exit code: $exit_code"
    return $exit_code
}

# Function to run cart management tests
run_cart_tests() {
    echo "🔄 Running cart management tests..."
    
    xcodebuild test-without-building \
        -workspace "$WORKSPACE" \
        -scheme "$SCHEME" \
        -destination "$DESTINATION" \
        -only-testing:MyDemoAppUITests/CartManagementTests \
        -resultBundlePath "$RESULTS_DIR/CartTests_$(date +%Y%m%d_%H%M%S).xcresult" \
        2>&1 | tee "$RESULTS_DIR/cart_tests_output.log"
        
    local exit_code=${PIPESTATUS[0]}
    echo "Cart tests completed with exit code: $exit_code"
    return $exit_code
}

# Function to run basic navigation tests
run_navigation_tests() {
    echo "🔄 Running navigation tests..."
    
    xcodebuild test-without-building \
        -workspace "$WORKSPACE" \
        -scheme "$SCHEME" \
        -destination "$DESTINATION" \
        -only-testing:MyDemoAppUITests/NavigationTest \
        -resultBundlePath "$RESULTS_DIR/NavigationTests_$(date +%Y%m%d_%H%M%S).xcresult" \
        2>&1 | tee "$RESULTS_DIR/navigation_tests_output.log"
        
    local exit_code=${PIPESTATUS[0]}
    echo "Navigation tests completed with exit code: $exit_code"
    return $exit_code
}

# Function to run specific test
run_specific_test() {
    local test_class=$1
    local test_method=$2
    
    echo "🔄 Running specific test: $test_class/$test_method"
    
    if [ -n "$test_method" ]; then
        local test_target="MyDemoAppUITests/$test_class/$test_method"
    else
        local test_target="MyDemoAppUITests/$test_class"
    fi
    
    xcodebuild test-without-building \
        -workspace "$WORKSPACE" \
        -scheme "$SCHEME" \
        -destination "$DESTINATION" \
        -only-testing:"$test_target" \
        -resultBundlePath "$RESULTS_DIR/SpecificTest_${test_class}_$(date +%Y%m%d_%H%M%S).xcresult" \
        2>&1 | tee "$RESULTS_DIR/test_${test_class}_output.log"
        
    local exit_code=${PIPESTATUS[0]}
    echo "Specific test completed with exit code: $exit_code"
    return $exit_code
}

# Function to generate test report
generate_report() {
    echo "📊 Generating test report..."
    
    # Find the most recent xcresult bundle
    LATEST_RESULT=$(find "$RESULTS_DIR" -name "*.xcresult" -type d | head -1)
    
    if [ -n "$LATEST_RESULT" ]; then
        echo "📋 Test results available in: $LATEST_RESULT"
        echo "   To view detailed results, use:"
        echo "   open '$LATEST_RESULT'"
        echo ""
        
        # Extract test summary if available
        if command -v xcrun >/dev/null 2>&1; then
            echo "📈 Quick Test Summary:"
            xcrun xcresulttool get --format json --path "$LATEST_RESULT" | \
                python3 -m json.tool 2>/dev/null | \
                grep -E "(testsCount|failuresCount|errorsCount)" 2>/dev/null || \
                echo "   (Summary requires additional tools)"
        fi
    else
        echo "❌ No test results found in $RESULTS_DIR"
    fi
    
    # Show recent log files
    echo ""
    echo "📄 Available log files:"
    ls -la "$RESULTS_DIR"/*.log 2>/dev/null | tail -5 || echo "   No log files found"
}

# Function to clean test results
clean_results() {
    echo "🧹 Cleaning test results..."
    rm -rf "$RESULTS_DIR"
    mkdir -p "$RESULTS_DIR"
    echo "✅ Test results directory cleaned"
}

# Function to setup simulator
setup_simulator() {
    echo "📱 Setting up iOS Simulator..."
    
    # Check available simulators
    check_simulator
    
    # Extract device name from destination
    DEVICE_NAME=$(echo "$DESTINATION" | sed -n 's/.*name=\([^,]*\).*/\1/p')
    
    # Boot simulator if not already running
    xcrun simctl boot "$DEVICE_NAME" 2>/dev/null && echo "   Simulator booted successfully" || echo "   Simulator already running or boot failed"
    
    # Wait for simulator to be ready
    echo "   Waiting for simulator to be ready..."
    sleep 3
    
    echo "✅ Simulator setup complete"
}

# Function to list available tests
list_tests() {
    echo "📋 Available Test Classes:"
    echo "   • CheckoutFlowTest - Comprehensive checkout flow testing"
    echo "   • CartManagementTests - Cart add/delete functionality"
    echo "   • NavigationTest - App navigation testing"
    echo "   • ProductDetailsTest - Product details functionality"
    echo "   • ProductListingPageTest - Product listing functionality"
    echo "   • LocalizationTest - Localization testing"
    echo ""
}

# Main menu
show_menu() {
    echo ""
    echo "Please select an option:"
    echo "1) Build and Run All Tests"
    echo "2) Run Checkout Flow Tests"
    echo "3) Run Cart Management Tests" 
    echo "4) Run Navigation Tests"
    echo "5) Run Specific Test Class"
    echo "6) Setup iOS Simulator"
    echo "7) Build Project Only"
    echo "8) Generate Test Report"
    echo "9) Clean Test Results"
    echo "10) List Available Tests"
    echo "0) Exit"
    echo ""
    read -p "Enter your choice [0-10]: " choice
}

# Process menu choice
process_choice() {
    case $choice in
        1)
            check_simulator
            clean_build
            build_project
            run_all_tests
            generate_report
            ;;
        2)
            check_simulator
            build_project
            run_checkout_tests
            generate_report
            ;;
        3)
            check_simulator
            build_project
            run_cart_tests
            generate_report
            ;;
        4)
            check_simulator
            build_project
            run_navigation_tests
            generate_report
            ;;
        5)
            list_tests
            echo ""
            read -p "Enter test class name (e.g., CheckoutFlowTest): " test_class
            if [ -n "$test_class" ]; then
                echo ""
                read -p "Enter test method name (optional): " test_method
                check_simulator
                build_project
                run_specific_test "$test_class" "$test_method"
                generate_report
            else
                echo "❌ No test class provided"
            fi
            ;;
        6)
            setup_simulator
            ;;
        7)
            clean_build
            build_project
            ;;
        8)
            generate_report
            ;;
        9)
            clean_results
            ;;
        10)
            list_tests
            ;;
        0)
            echo "👋 Goodbye!"
            exit 0
            ;;
        *)
            echo "❌ Invalid option. Please try again."
            ;;
    esac
}

# Main execution
if [ $# -eq 0 ]; then
    # Interactive mode
    while true; do
        show_menu
        process_choice
        echo ""
        read -p "Press Enter to continue..."
    done
else
    # Command line mode
    case $1 in
        "all")
            check_simulator
            clean_build
            build_project
            run_all_tests
            generate_report
            ;;
        "checkout")
            check_simulator
            build_project
            run_checkout_tests
            generate_report
            ;;
        "cart")
            check_simulator
            build_project
            run_cart_tests
            generate_report
            ;;
        "navigation")
            check_simulator
            build_project
            run_navigation_tests
            generate_report
            ;;
        "build")
            clean_build
            build_project
            ;;
        "clean")
            clean_results
            ;;
        "setup")
            setup_simulator
            ;;
        "report")
            generate_report
            ;;
        *)
            echo "Usage: $0 [all|checkout|cart|navigation|build|clean|setup|report]"
            echo ""
            echo "Commands:"
            echo "  all        - Build and run all tests"
            echo "  checkout   - Run checkout flow tests"
            echo "  cart       - Run cart management tests"
            echo "  navigation - Run navigation tests"
            echo "  build      - Build project only"
            echo "  clean      - Clean test results"
            echo "  setup      - Setup iOS simulator"
            echo "  report     - Generate test report"
            echo ""
            echo "Run without arguments for interactive mode."
            exit 1
            ;;
    esac
fi
