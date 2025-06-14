# Windsurf CLI Tool for Windows
# PowerShell script to open Windsurf IDE at the current directory or specified path
# Author: Windsurf User
# Date: 2025-06-14
# Version: 2.0

# Theme configuration file name
$THEME_CONFIG_FILE = ".windsurf-theme.json"

# Available themes
$THEMES = @{
    "default" = "#2C2C2C";
    "dark" = "#1E1E1E";
    "light" = "#F5F5F5";
    "blue" = "#193549";
    "red" = "#4B1818";
    "green" = "#0D3D0D";
    "purple" = "#2D2140";
    "orange" = "#4D3800";
    "pink" = "#4D2142";
    "gray" = "#333333";
}

param(
    [Parameter(Position = 0)]
    [string]$Path,
    
    [Parameter()]
    [switch]$Help,
    
    [Parameter()]
    [switch]$Version,
    
    [Parameter()]
    [switch]$DryRun,
    
    [Parameter()]
    [string]$Theme,
    
    [Parameter()]
    [switch]$SetTheme,
    
    [Parameter()]
    [string]$SetColor,
    
    [Parameter()]
    [switch]$ListThemes,
    
    [Parameter()]
    [switch]$ShowTheme,
    
    [Parameter()]
    [switch]$ResetTheme
)

# Function to display help
function Show-Usage {
    Write-Host "Usage: windsurf [OPTIONS] [PATH]"
    Write-Host ""
    Write-Host "Opens Windsurf IDE at the specified path or current directory."
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -h, --help              Show this help message and exit"
    Write-Host "  -v, --version           Display version information"
    Write-Host "  -d, --dry-run           Show what would happen without actually launching Windsurf"
    Write-Host "  -t, --theme THEME       Set workspace theme (for current session only)"
    Write-Host "  --set-theme THEME       Set workspace theme permanently"
    Write-Host "  --set-color HEX         Set workspace custom color (hex format: #RRGGBB)"
    Write-Host "  --list-themes           List all available themes"
    Write-Host "  --show-theme            Show current workspace theme"
    Write-Host "  --reset-theme           Reset to default theme"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  windsurf                         # Open Windsurf at current directory"
    Write-Host "  windsurf C:\projects\app          # Open Windsurf at specified directory"
    Write-Host "  windsurf -t blue                 # Open with blue theme (temporary)"
    Write-Host "  windsurf --set-theme dark        # Set dark theme for this workspace"
    Write-Host "  windsurf --set-color "#FF5500"   # Set custom color for this workspace"
    Write-Host "  windsurf --list-themes           # Show available themes"
}

# Function to display version information
function Show-Version {
    Write-Host "windsurf v2.0"
    Write-Host "A utility to open Windsurf IDE at specified locations with theme support"
}

# List available themes
function List-Themes {
    Write-Host "Available themes:"
    foreach ($theme in $THEMES.Keys) {
        Write-Host "  $theme ($($THEMES[$theme]))"
    }
}

# Get current theme for workspace
function Get-WorkspaceTheme {
    param([string]$workspacePath)
    
    $themeFile = Join-Path $workspacePath $THEME_CONFIG_FILE
    
    if (Test-Path $themeFile) {
        # Read theme from config file
        $themeData = Get-Content $themeFile -Raw | ConvertFrom-Json
        
        if ($themeData.theme) {
            Write-Host "Current workspace theme: $($themeData.theme)"
            if ($themeData.color) {
                Write-Host "Custom color: $($themeData.color)"
            }
        } else {
            Write-Host "No theme set for this workspace. Using default."
        }
    } else {
        Write-Host "No theme set for this workspace. Using default."
    }
}

# Set workspace theme
function Set-WorkspaceTheme {
    param(
        [string]$workspacePath,
        [string]$themeName
    )
    
    $themeFile = Join-Path $workspacePath $THEME_CONFIG_FILE
    
    # Validate theme name
    if ($themeName -ne "default" -and -not $THEMES.ContainsKey($themeName)) {
        Write-Host "Error: Invalid theme '$themeName'."
        Write-Host "Use --list-themes to see available themes."
        exit 1
    }
    
    # Create theme config
    $color = $THEMES[$themeName]
    $themeConfig = @{
        theme = $themeName
        color = $color
    } | ConvertTo-Json
    
    Set-Content -Path $themeFile -Value $themeConfig
    
    Write-Host "Theme '$themeName' set for workspace: $workspacePath"
}

# Set workspace custom color
function Set-WorkspaceColor {
    param(
        [string]$workspacePath,
        [string]$colorHex
    )
    
    $themeFile = Join-Path $workspacePath $THEME_CONFIG_FILE
    
    # Validate hex color format
    if ($colorHex -notmatch '^#[0-9A-Fa-f]{6}$') {
        Write-Host "Error: Invalid color format. Use hex format: #RRGGBB"
        exit 1
    }
    
    # Create or update theme config
    if (Test-Path $themeFile) {
        # Update existing config
        $themeData = Get-Content $themeFile -Raw | ConvertFrom-Json
        $themeName = $themeData.theme
        if (-not $themeName) {
            $themeName = "custom"
        }
        
        $themeConfig = @{
            theme = $themeName
            color = $colorHex
        } | ConvertTo-Json
    } else {
        # Create new config with custom theme
        $themeConfig = @{
            theme = "custom"
            color = $colorHex
        } | ConvertTo-Json
    }
    
    Set-Content -Path $themeFile -Value $themeConfig
    
    Write-Host "Custom color '$colorHex' set for workspace: $workspacePath"
}

# Reset workspace theme
function Reset-WorkspaceTheme {
    param([string]$workspacePath)
    
    $themeFile = Join-Path $workspacePath $THEME_CONFIG_FILE
    
    if (Test-Path $themeFile) {
        Remove-Item $themeFile
        Write-Host "Theme reset to default for workspace: $workspacePath"
    } else {
        Write-Host "No theme configuration found. Already using default."
    }
}

# Process command line parameters
if ($Help) {
    Show-Usage
    exit 0
}

if ($Version) {
    Show-Version
    exit 0
}

# Handle theme-specific commands
if ($ListThemes) {
    List-Themes
    exit 0
}

# Determine the target path
if ([string]::IsNullOrEmpty($Path)) {
    $targetPath = Get-Location
} else {
    # Convert to absolute path if it's not already
    if ([System.IO.Path]::IsPathRooted($Path)) {
        $targetPath = $Path
    } else {
        $targetPath = Join-Path (Get-Location) $Path
    }
    
    # Verify the path exists
    if (-not (Test-Path $targetPath)) {
        Write-Host "Error: Path does not exist: $targetPath"
        exit 1
    }
}

# Handle theme-related commands that require a path
if ($ShowTheme) {
    Get-WorkspaceTheme $targetPath
    exit 0
}

if ($ResetTheme) {
    Reset-WorkspaceTheme $targetPath
    exit 0
}

if ($SetTheme) {
    if ([string]::IsNullOrEmpty($Theme)) {
        Write-Host "Error: No theme specified. Use -Theme parameter to specify a theme."
        Write-Host "Use -ListThemes to see available themes."
        exit 1
    }
    Set-WorkspaceTheme $targetPath $Theme
    exit 0
}

if (-not [string]::IsNullOrEmpty($SetColor)) {
    Set-WorkspaceColor $targetPath $SetColor
    exit 0
}

# Check if this is a dry run or an actual execution
if ($DryRun) {
    # Get theme information for dry run
    $themeFile = Join-Path $targetPath $THEME_CONFIG_FILE
    $themeArgs = ""
    $themeInfo = ""
    
    if (-not [string]::IsNullOrEmpty($Theme)) {
        # Use temporary theme if specified
        if ($Theme -ne "default" -and -not $THEMES.ContainsKey($Theme)) {
            Write-Host "Error: Invalid theme '$Theme'."
            Write-Host "Use -ListThemes to see available themes."
            exit 1
        }
        $themeColor = $THEMES[$Theme]
        $themeArgs = "-Theme `"$Theme`" -Color `"$themeColor`""
        $themeInfo = "Using theme: $Theme ($themeColor)"
    } elseif (Test-Path $themeFile) {
        # Read theme from config file
        $themeData = Get-Content $themeFile -Raw | ConvertFrom-Json
        if ($themeData.theme -and $themeData.color) {
            $themeArgs = "-Theme `"$($themeData.theme)`" -Color `"$($themeData.color)`""
            $themeInfo = "Using workspace theme: $($themeData.theme) ($($themeData.color))"
        }
    }
    
    Write-Host "[DRY RUN] Would open Windsurf IDE at: $targetPath"
    if ($themeArgs) {
        Write-Host "Command that would be executed: Start-Process 'Windsurf' -ArgumentList '$targetPath', $themeArgs"
        Write-Host $themeInfo
    } else {
        Write-Host "Command that would be executed: Start-Process 'Windsurf' -ArgumentList '$targetPath'"
        Write-Host "Using default theme"
    }
    exit 0
}

# Prepare launch command with theme if applicable
$launchArgs = @($targetPath)
$themeInfo = ""

# First check for temporary theme override
if (-not [string]::IsNullOrEmpty($Theme)) {
    if ($Theme -ne "default" -and -not $THEMES.ContainsKey($Theme)) {
        Write-Host "Error: Invalid theme '$Theme'."
        Write-Host "Use -ListThemes to see available themes."
        exit 1
    }
    $themeColor = $THEMES[$Theme]
    $launchArgs += "-Theme"
    $launchArgs += $Theme
    $launchArgs += "-Color"
    $launchArgs += $themeColor
    $themeInfo = "Using theme: $Theme ($themeColor)"
# Otherwise check for workspace theme config
} else {
    $themeFile = Join-Path $targetPath $THEME_CONFIG_FILE
    if (Test-Path $themeFile) {
        # Read theme from config file
        $themeData = Get-Content $themeFile -Raw | ConvertFrom-Json
        if ($themeData.theme -and $themeData.color) {
            $launchArgs += "-Theme"
            $launchArgs += $themeData.theme
            $launchArgs += "-Color"
            $launchArgs += $themeData.color
            $themeInfo = "Using workspace theme: $($themeData.theme) ($($themeData.color))"
        }
    }
}

# Launch Windsurf IDE with the target path and theme if applicable
try {
    Start-Process "Windsurf" -ArgumentList $launchArgs
    Write-Host "Opening Windsurf IDE at: $targetPath"
    if ($themeInfo) {
        Write-Host $themeInfo
    }
} catch {
    Write-Host "Error: Failed to open Windsurf IDE at: $targetPath"
    Write-Host "Please check if Windsurf application is installed correctly."
    if (-not (Test-Path -Path $windsurfPath)) {
        Write-Host "Warning: Cannot locate Windsurf executable. Will try to start anyway." -ForegroundColor Yellow
        $windsurfPath = "Windsurf"
    }

    # Launch Windsurf with the target path
    Write-Host "Opening Windsurf IDE at: $TargetPath"
    Start-Process $windsurfPath -ArgumentList "`"$TargetPath`""
}
catch {
    Write-Host "Error: Failed to open Windsurf IDE at: $TargetPath" -ForegroundColor Red
    Write-Host "Details: $_" -ForegroundColor Red
    exit 1
}
