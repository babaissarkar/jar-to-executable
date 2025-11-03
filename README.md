# JAR to Executable GitHub Action

This GitHub Action converts Java JAR files into standalone executables for both Linux and Windows platforms.

## Overview

- **Linux**: Creates an AppImage from a JAR file
- **Windows**: Creates a portable EXE from a jpackage-generated app-image folder

## Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `id` | ID of the program (without file extension) | ✅ | - |
| `name` | Name of the program | ❌ | Value of `id` |
| `icon` | Path to the icon file | ✅ | - |
| `desktop-file` | Path to the desktop file (Linux only) | ❌ | - |
| `input` | Path to JAR file (Linux) or jpackage app-image folder (Windows) | ✅ | - |
| `output` | Path to save the output executable | ✅ | - |

## Usage Examples

### Linux Example (JAR to AppImage)

```yaml
- name: Create Linux AppImage
  uses: babaissarkar/jar-to-executable@v1
  with:
    id: myapp
    name: My Application
    icon: assets/icon.png
    desktop-file: assets/myapp.desktop
    input: target/myapp.jar
    output: dist/MyApp.AppImage
```

### Windows Example (JAR to portable EXE)

```yaml
- name: Create Windows Portable EXE
  uses: babaissarkar/jar-to-executable@v1
  with:
    id: myapp
    name: My Application
    icon: assets/icon.ico
    input: target/jpackage/myapp
    output: dist/MyApp.exe
```

A more comprehensive example can be found [here](https://github.com/babaissarkar/wml-parser-lsp/blob/60f49f4a2fa257adc005ebcf36f68cb3352f0040/.github/workflows/maven-publish.yml).
