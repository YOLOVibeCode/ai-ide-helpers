@echo off
setlocal enabledelayedexpansion

rem Windsurf CLI Tool for Windows (Batch version)
rem Version: 2.0

rem Theme configuration file name
set THEME_CONFIG_FILE=.windsurf-theme.json

rem Available themes
set THEME_DEFAULT=#2C2C2C
set THEME_DARK=#1E1E1E
set THEME_LIGHT=#F5F5F5
set THEME_BLUE=#193549
set THEME_RED=#4B1818
set THEME_GREEN=#0D3D0D
set THEME_PURPLE=#2D2140
set THEME_ORANGE=#4D3800
set THEME_PINK=#4D2142
set THEME_GRAY=#333333

REM Parse command line arguments
set "HELP="
set "VERSION="
set "DRY_RUN="
set "THEME="
set "SET_THEME="
set "SET_COLOR="
set "LIST_THEMES="
set "SHOW_THEME="
set "RESET_THEME="

:parse
if "%~1"=="" goto :main
if /i "%~1"=="-h" set "HELP=1" & goto :nextArg
if /i "%~1"=="--help" set "HELP=1" & goto :nextArg
if /i "%~1"=="-v" set "VERSION=1" & goto :nextArg
if /i "%~1"=="--version" set "VERSION=1" & goto :nextArg
if /i "%~1"=="-d" set "DRY_RUN=1" & goto :nextArg
if /i "%~1"=="--dry-run" set "DRY_RUN=1" & goto :nextArg
if /i "%~1"=="-t" set "THEME=%~2" & shift & goto :nextArg
if /i "%~1"=="--theme" set "THEME=%~2" & shift & goto :nextArg
if /i "%~1"=="-set-theme" set "SET_THEME=%~2" & shift & goto :nextArg
if /i "%~1"=="--set-theme" set "SET_THEME=%~2" & shift & goto :nextArg
if /i "%~1"=="-set-color" set "SET_COLOR=%~2" & shift & goto :nextArg
if /i "%~1"=="--set-color" set "SET_COLOR=%~2" & shift & goto :nextArg
if /i "%~1"=="-list-themes" set "LIST_THEMES=1" & goto :nextArg
if /i "%~1"=="--list-themes" set "LIST_THEMES=1" & goto :nextArg
if /i "%~1"=="-show-theme" set "SHOW_THEME=1" & goto :nextArg
if /i "%~1"=="--show-theme" set "SHOW_THEME=1" & goto :nextArg
if /i "%~1"=="-reset-theme" set "RESET_THEME=1" & goto :nextArg
if /i "%~1"=="--reset-theme" set "RESET_THEME=1" & goto :nextArg

if "!TARGET_PATH!"=="" (
    set "TARGET_PATH=%~1"
) else (
    echo Warning: Extra arguments ignored: %*
    goto :main
)

:nextArg
shift
goto :parse

:main
REM Display help if requested
if defined HELP (
    call :show_help
    exit /b 0
)

REM Display version if requested
if defined VERSION (
    call :showVersion
    exit /b 0
)

REM Determine target path
if not defined TARGET_PATH (
    set "TARGET_PATH=%CD%"
) else (
    REM If path is not absolute, make it so
    if not "!TARGET_PATH:~1,1!"==":" (
        set "TARGET_PATH=%CD%\!TARGET_PATH!"
    )
)

REM Clean up the path (remove trailing slashes)
if "!TARGET_PATH:~-1!"=="\" (
    set "TARGET_PATH=!TARGET_PATH:~0,-1!"
)

REM Verify path exists
if not exist "!TARGET_PATH!" (
    echo Error: Path does not exist: !TARGET_PATH!
    exit /b 1
)

REM Show dry run output if specified
if defined DRY_RUN (
    echo [DRY RUN] Would open Windsurf IDE at: !TARGET_PATH!
    echo Command that would be executed: start "" "Windsurf" "!TARGET_PATH!"
    exit /b 0
)

REM Set theme if specified
if defined THEME (
    echo Setting theme to: !THEME!
    REM Add code to set theme here
)

REM Set theme permanently if specified
if defined SET_THEME (
    echo Setting theme to: !SET_THEME!
    REM Add code to set theme permanently here
)

REM Set custom color if specified
if defined SET_COLOR (
    echo Setting custom color to: !SET_COLOR!
    REM Add code to set custom color here
)

REM List available themes if specified
if defined LIST_THEMES (
    echo Available themes:
    echo !THEME_DEFAULT!
    echo !THEME_DARK!
    echo !THEME_LIGHT!
    echo !THEME_BLUE!
    echo !THEME_RED!
    echo !THEME_GREEN!
    echo !THEME_PURPLE!
    echo !THEME_ORANGE!
    echo !THEME_PINK!
    echo !THEME_GRAY!
    exit /b 0
)

REM Show current theme if specified
if defined SHOW_THEME (
    echo Current theme: !THEME_DEFAULT!
    REM Add code to show current theme here
)

REM Reset to default theme if specified
if defined RESET_THEME (
    echo Resetting to default theme
    REM Add code to reset to default theme here
)

REM Try to launch Windsurf with the target path
echo Opening Windsurf IDE at: !TARGET_PATH!
start "" "Windsurf" "!TARGET_PATH!"
if %ERRORLEVEL% neq 0 (
    echo Error: Failed to open Windsurf IDE at: !TARGET_PATH!
    echo Please ensure Windsurf is installed correctly.
    exit /b 1
)

exit /b 0

:show_help
echo Usage: windsurf [OPTIONS] [PATH]
echo.
echo Opens Windsurf IDE at the specified path or current directory.
echo.
echo Options:
echo   /h, /help              Show this help message and exit
echo   /v, /version           Display version information
echo   /d, /dry-run           Show what would happen without actually launching Windsurf
echo   /t, /theme THEME       Set workspace theme (for current session only)
echo   /set-theme THEME       Set workspace theme permanently
echo   /set-color HEX         Set workspace custom color (hex format: #RRGGBB)
echo   /list-themes           List all available themes
echo   /show-theme            Show current workspace theme
echo   /reset-theme           Reset to default theme
echo.
echo Examples:
echo   windsurf                         # Open Windsurf at current directory
echo   windsurf C:\projects\app          # Open Windsurf at specified directory
echo   windsurf /t blue                 # Open with blue theme (temporary)
echo   windsurf /set-theme dark         # Set dark theme for this workspace
echo   windsurf /set-color "#FF5500"    # Set custom color for this workspace
echo   windsurf /list-themes            # Show available themes
echo.
goto :eof/b

:showVersion
echo windsurf v2.0
echo A utility to open Windsurf IDE at specified locations
exit /b
