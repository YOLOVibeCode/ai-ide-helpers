#!/bin/zsh

# Test script for Windsurf CLI theming functionality
# This script tests the JSON handling and theme customization features

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test directory
TEST_DIR="/tmp/windsurf-test-$(date +%s)"
VSCODE_SETTINGS_DIR=".vscode"
VSCODE_SETTINGS_FILE="$VSCODE_SETTINGS_DIR/settings.json"
THEME_CONFIG_FILE=".windsurf-theme.json"

# Ensure the windsurf script is in PATH
ORIGINAL_WINDSURF_PATH="$(pwd)/windsurf"
if [ ! -f "$ORIGINAL_WINDSURF_PATH" ]; then
    echo "${RED}Error: windsurf script not found at $ORIGINAL_WINDSURF_PATH${NC}"
    exit 1
fi

# Create a temporary copy of the windsurf script for testing
WINDSURF_PATH="/tmp/windsurf-test-script"
cp "$ORIGINAL_WINDSURF_PATH" "$WINDSURF_PATH"
chmod +x "$WINDSURF_PATH"

# Create a clean test directory
setup() {
    echo "${BLUE}Setting up test environment...${NC}"
    mkdir -p "$TEST_DIR"
    cd "$TEST_DIR" || exit 1
    echo "${GREEN}Test directory created: $TEST_DIR${NC}"
}

# Clean up after tests
cleanup() {
    echo "${BLUE}Cleaning up test environment...${NC}"
    cd /tmp || exit 1
    rm -rf "$TEST_DIR"
    echo "${GREEN}Test directory removed${NC}"
}

# Test dependency check
test_dependencies() {
    echo "${YELLOW}Testing dependency check...${NC}"
    if command -v jq &> /dev/null; then
        echo "${GREEN}✓ jq is installed${NC}"
    else
        echo "${RED}✗ jq is not installed${NC}"
        return 1
    fi
    return 0
}

# Test setting a theme
test_set_theme() {
    local theme="$1"
    echo "${YELLOW}Testing set theme: $theme...${NC}"
    
    # Run the command
    "$WINDSURF_PATH" --set-theme "$theme" --no-launch
    
    # Check if theme file was created
    if [ -f "$THEME_CONFIG_FILE" ]; then
        echo "${GREEN}✓ Theme file created${NC}"
    else
        echo "${RED}✗ Theme file not created${NC}"
        return 1
    fi
    
    # Check if VS Code settings file was created
    if [ -f "$VSCODE_SETTINGS_FILE" ]; then
        echo "${GREEN}✓ VS Code settings file created${NC}"
    else
        echo "${RED}✗ VS Code settings file not created${NC}"
        return 1
    fi
    
    # Check if the theme setting is correct
    if jq -e ".\"workbench.colorTheme\" == \"$theme\"" "$VSCODE_SETTINGS_FILE" > /dev/null; then
        echo "${GREEN}✓ Theme setting is correct${NC}"
    else
        echo "${RED}✗ Theme setting is incorrect${NC}"
        echo "Expected: $theme"
        echo "Actual: $(jq '.\"workbench.colorTheme\"' "$VSCODE_SETTINGS_FILE")"
        return 1
    fi
    
    return 0
}

# Test setting a custom color
test_set_color() {
    local color="$1"
    echo "${YELLOW}Testing set color: $color...${NC}"
    
    # Run the command
    "$WINDSURF_PATH" --set-color "$color" --no-launch
    
    # Check if theme file was created
    if [ -f "$THEME_CONFIG_FILE" ]; then
        echo "${GREEN}✓ Theme file created${NC}"
    else
        echo "${RED}✗ Theme file not created${NC}"
        return 1
    fi
    
    # Check if VS Code settings file was created
    if [ -f "$VSCODE_SETTINGS_FILE" ]; then
        echo "${GREEN}✓ VS Code settings file created${NC}"
    else
        echo "${RED}✗ VS Code settings file not created${NC}"
        return 1
    fi
    
    # Check if the color setting is correct
    if jq -e ".\"workbench.colorCustomizations\".\"titleBar.activeBackground\" == \"$color\"" "$VSCODE_SETTINGS_FILE" > /dev/null; then
        echo "${GREEN}✓ Title bar color setting is correct${NC}"
    else
        echo "${RED}✗ Title bar color setting is incorrect${NC}"
        echo "Expected: $color"
        echo "Actual: $(jq '.\"workbench.colorCustomizations\".\"titleBar.activeBackground\"' "$VSCODE_SETTINGS_FILE")"
        return 1
    fi
    
    # Check if the editor background is set
    if jq -e ".\"workbench.colorCustomizations\".\"editor.background\"" "$VSCODE_SETTINGS_FILE" > /dev/null; then
        echo "${GREEN}✓ Editor background color is set${NC}"
    else
        echo "${RED}✗ Editor background color is not set${NC}"
        return 1
    fi
    
    return 0
}

# Test resetting theme
test_reset_theme() {
    echo "${YELLOW}Testing reset theme...${NC}"
    
    # Run the command
    "$WINDSURF_PATH" --reset-theme --no-launch
    
    # Check if theme file was removed
    if [ ! -f "$THEME_CONFIG_FILE" ]; then
        echo "${GREEN}✓ Theme file removed${NC}"
    else
        echo "${RED}✗ Theme file not removed${NC}"
        return 1
    fi
    
    # Check if VS Code settings file exists and is empty JSON
    if [ -f "$VSCODE_SETTINGS_FILE" ]; then
        # Check if the theme setting is removed
        if ! jq -e 'has("workbench.colorTheme")' "$VSCODE_SETTINGS_FILE" > /dev/null; then
            echo "${GREEN}✓ Theme setting removed${NC}"
        else
            echo "${RED}✗ Theme setting not removed${NC}"
            return 1
        fi
        
        # Check if the color customization is removed
        if ! jq -e 'has("workbench.colorCustomizations")' "$VSCODE_SETTINGS_FILE" > /dev/null; then
            echo "${GREEN}✓ Color customization removed${NC}"
        else
            echo "${RED}✗ Color customization not removed${NC}"
            return 1
        fi
    else
        echo "${YELLOW}! VS Code settings file not found, but this is acceptable${NC}"
    fi
    
    return 0
}

# Test JSON handling with existing settings
test_json_handling() {
    echo "${YELLOW}Testing JSON handling with existing settings...${NC}"
    
    # Create a settings file with other settings
    mkdir -p "$VSCODE_SETTINGS_DIR"
    echo '{
        "editor.fontSize": 14,
        "files.autoSave": "afterDelay",
        "terminal.integrated.fontFamily": "Menlo"
    }' > "$VSCODE_SETTINGS_FILE"
    
    # Set a theme
    "$WINDSURF_PATH" --set-theme "dark+" --no-launch
    
    # Check if the original settings are preserved
    if jq -e '.["editor.fontSize"] == 14' "$VSCODE_SETTINGS_FILE" > /dev/null; then
        echo "${GREEN}✓ Original settings preserved${NC}"
    else
        echo "${RED}✗ Original settings lost${NC}"
        return 1
    fi
    
    # Check if the theme setting was added
    if jq -e '.["workbench.colorTheme"] == "dark+"' "$VSCODE_SETTINGS_FILE" > /dev/null; then
        echo "${GREEN}✓ Theme setting added correctly${NC}"
    else
        echo "${RED}✗ Theme setting not added correctly${NC}"
        return 1
    fi
    
    # Reset theme
    "$WINDSURF_PATH" --reset-theme --no-launch
    
    # Check if the original settings are still preserved after reset
    if jq -e '.["editor.fontSize"] == 14' "$VSCODE_SETTINGS_FILE" > /dev/null; then
        echo "${GREEN}✓ Original settings preserved after reset${NC}"
    else
        echo "${RED}✗ Original settings lost after reset${NC}"
        return 1
    fi
    
    return 0
}

# Run all tests
run_tests() {
    local failed=0
    
    setup
    
    # Run tests
    test_dependencies || ((failed++))
    test_set_theme "dark+" || ((failed++))
    test_set_color "#2D4263" || ((failed++))
    test_reset_theme || ((failed++))
    test_json_handling || ((failed++))
    
    # Print summary
    echo ""
    echo "${BLUE}===== Test Summary =====${NC}"
    if [ $failed -eq 0 ]; then
        echo "${GREEN}All tests passed!${NC}"
    else
        echo "${RED}$failed test(s) failed!${NC}"
    fi
    
    cleanup
    
    return $failed
}

# Add --no-launch option to windsurf script if not already present
add_no_launch_option() {
    echo "${YELLOW}Adding --no-launch option to windsurf script...${NC}"
    
    # Create a temporary file
    TMP_FILE="${WINDSURF_PATH}.tmp"
    
    # Add the no-launch option by modifying the launch section
    cat "$WINDSURF_PATH" | awk '{
        print $0;
        if ($0 ~ /# Launch Windsurf IDE/) {
            print "    # Skip launch for testing";
            print "    if [ "\$1" = "--no-launch" ]; then";
            print "        echo "Launch skipped \(--no-launch option\)"";
            print "        exit 0";
            print "    fi";
        }
    }' > "$TMP_FILE"
    
    # Replace the original with the modified version
    mv "$TMP_FILE" "$WINDSURF_PATH"
    chmod +x "$WINDSURF_PATH"
    
    echo "${GREEN}✓ --no-launch option added${NC}"
}

# Main function
main() {
    echo "${BLUE}===== Windsurf CLI Test Suite =====${NC}"
    
    # Add --no-launch option for testing
    add_no_launch_option
    
    # Run tests
    run_tests
    exit $?
}

# Run the main function
main
