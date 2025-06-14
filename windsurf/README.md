# Windsurf CLI Tool

A cross-platform command-line tool to open the Windsurf IDE at specified directories with workspace-specific theme support.

## Features

- Open Windsurf IDE at the current directory or a specified path
- Set workspace-specific color themes
- Apply temporary themes for individual sessions
- Cross-platform support (macOS, Linux, Windows)
- Simple and intuitive command-line interfaces
- Open Windsurf IDE at your current working directory
- Open Windsurf IDE at a specified path
- Dry-run mode to see what would happen without launching Windsurf
- Comprehensive error handling and path validation

## Installation

### macOS and Linux

#### Option 1: Quick Install (Recommended)

Run the installer script which will:
- Copy the windsurf script to `~/bin/` (creating it if needed)
- Make the script executable
- Add `~/bin` to your PATH if it's not already there

```bash
# From this directory
chmod +x install.sh
./install.sh
```

#### Option 2: Manual Installation

1. Make sure you have a `~/bin` directory (create it if it doesn't exist):
   ```bash
   mkdir -p ~/bin
   ```

2. Copy the windsurf script to your bin directory:
   ```bash
   cp windsurf ~/bin/
   ```

3. Make the script executable:
   ```bash
   chmod +x ~/bin/windsurf
   ```

4. Add `~/bin` to your PATH if it's not already there:
   ```bash
   echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
   source ~/.zshrc
   ```

### Windows

#### Option 1: PowerShell Script (Recommended)

1. Create a folder for scripts in your user profile (if it doesn't exist):
   ```powershell
   # Run in PowerShell
   if (-not (Test-Path -Path "$HOME\Documents\WindowsPowerShell\Scripts")) {
       New-Item -Path "$HOME\Documents\WindowsPowerShell\Scripts" -ItemType Directory -Force
   }
   ```

2. Copy the `windsurf.ps1` script to your scripts folder:
   ```powershell
   Copy-Item -Path "windsurf.ps1" -Destination "$HOME\Documents\WindowsPowerShell\Scripts"
   ```

3. Add the scripts folder to your PowerShell profile (creates the profile if it doesn't exist):
   ```powershell
   if (-not (Test-Path -Path $PROFILE)) {
       New-Item -Path $PROFILE -ItemType File -Force
   }
   Add-Content -Path $PROFILE -Value "`$env:PATH += ';$HOME\Documents\WindowsPowerShell\Scripts'"
   ```

4. Create a function in your profile to make it easier to call:
   ```powershell
   Add-Content -Path $PROFILE -Value "function windsurf { & '$HOME\Documents\WindowsPowerShell\Scripts\windsurf.ps1' @args }"
   ```

5. Reload your profile:
   ```powershell
   . $PROFILE
   ```

#### Option 2: Batch File

1. Create a folder for scripts in a location on your PATH, for example:
   ```cmd
   md "%USERPROFILE%\bin"
   ```

2. Copy the `windsurf.bat` file to this folder:
   ```cmd
   copy windsurf.bat "%USERPROFILE%\bin"
   ```

3. Add this folder to your PATH if not already there:
   ```cmd
   setx PATH "%PATH%;%USERPROFILE%\bin"
   ```

4. Open a new Command Prompt window to use the command.

## Usage

```bash
windsurf [OPTIONS] [PATH]
```

### Options

- `-h, --help`: Show help message and exit
- `-v, --version`: Display version information
- `-d, --dry-run`: Show what would happen without actually launching Windsurf
- `-t, --theme THEME`: Set workspace theme (for current session only)
- `--set-theme THEME`: Set workspace theme permanently
- `--set-color HEX`: Set workspace custom color (hex format: #RRGGBB)
- `--list-themes`: List all available themes
- `--show-theme`: Show current workspace theme
- `--reset-theme`: Reset to default theme

### Examples

```bash
windsurf                         # Open Windsurf at current directory
windsurf ~/projects/app          # Open Windsurf at specified directory
windsurf -t blue                 # Open with blue theme (temporary)
windsurf --set-theme dark        # Set dark theme for this workspace
windsurf --set-color "#FF5500"   # Set custom color for this workspace
windsurf --list-themes           # Show available themes
windsurf --show-theme            # Show current workspace theme
windsurf --reset-theme           # Reset to default theme

## Workspace Theming

The Windsurf CLI tool now supports workspace-specific color theming, using VS Code's native theme settings. This allows you to set different themes for different projects, making it easier to visually distinguish between workspaces.

### How Theming Works

- Theme settings are stored in `.vscode/settings.json` in each workspace directory (using VS Code's standard format)
- The CLI tool manages VS Code's `workbench.colorTheme` and `workbench.colorCustomizations` settings
- You can set a permanent theme for a workspace or use a temporary theme for a single session
- Custom colors can be specified using hex color codes (#RRGGBB format)

### VS Code Integration

When you set a theme or color using the Windsurf CLI:

1. For named themes: The tool sets the `workbench.colorTheme` property in `.vscode/settings.json`
2. For custom colors: The tool sets the `workbench.colorCustomizations` property to change the title bar color

This means your theme settings will work immediately when opening the workspace in VS Code!

### Future Windsurf IDE Support

These same settings will be used by Windsurf IDE when theme support is added in the future.

### Available Themes

The following themes are available by default:

- `default`: Standard Windsurf theme (#2C2C2C)
- `dark`: Dark theme (#1E1E1E)
- `light`: Light theme (#F5F5F5)
- `blue`: Blue theme (#193549)
- `red`: Red theme (#4B1818)
- `green`: Green theme (#0D3D0D)
- `purple`: Purple theme (#2D2140)
- `orange`: Orange theme (#4D3800)
- `pink`: Pink theme (#4D2142)
- `gray`: Gray theme (#333333)

### Theme Configuration File

The `.windsurf-theme.json` file has a simple structure:

```json
{
  "theme": "blue",
  "color": "#193549"
}
```

You can manually edit this file or use the CLI commands to manage themes.

## Troubleshooting

If you encounter any issues with the Windsurf CLI tool, please check the following:

1. Ensure Windsurf IDE is properly installed on your system
2. Verify that the script has executable permissions (for macOS/Linux)
3. Make sure the script is in your system PATH
4. Check that the path you're trying to open exists and is accessible
5. For theme-related issues, verify that the `.windsurf-theme.json` file is properly formatted
   ```

## License

Open source for personal and commercial use.
