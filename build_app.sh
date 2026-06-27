#!/bin/zsh
set -euo pipefail

cd "${0:A:h}"
swift build -c release

APP="RadioControllerLauncher.app"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
cp .build/release/RadioControllerLauncher "$APP/Contents/MacOS/RadioControllerLauncher"
cp Assets/AppIcon.png "$APP/Contents/Resources/AppIcon.png"

cat > "$APP/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "https://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>CFBundleExecutable</key><string>RadioControllerLauncher</string>
<key>CFBundleIdentifier</key><string>jp.shinjo.RadioControllerLauncher</string>
<key>CFBundleName</key><string>Radio Controller Launcher</string>
<key>CFBundleDisplayName</key><string>Radio Controller Launcher</string>
<key>CFBundleIconFile</key><string>AppIcon.png</string>
<key>CFBundlePackageType</key><string>APPL</string>
<key>CFBundleShortVersionString</key><string>1.0</string>
<key>CFBundleVersion</key><string>1</string>
<key>LSMinimumSystemVersion</key><string>14.0</string>
<key>LSUIElement</key><true/>
<key>NSHighResolutionCapable</key><true/>
</dict></plist>
PLIST

codesign --force --deep --sign - "$APP"
echo "$PWD/$APP"
