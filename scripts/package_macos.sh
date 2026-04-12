#!/bin/bash

# 配置
APP_NAME="SmartTranslator"
VERSION="1.0.0"
APP_PATH="${APP_NAME}.app"
BUILD_DIR="build"
DMG_NAME="${APP_NAME}-${VERSION}.dmg"

# 创建.app包
echo "创建.app包..."

# 目录结构
mkdir -p "${APP_PATH}/Contents/MacOS"
mkdir -p "${APP_PATH}/Contents/Resources"

# 可执行文件
cp "${BUILD_DIR}/bin/smart-translator" "${APP_PATH}/Contents/MacOS/"

# 配置文件
cp config/config.yaml "${APP_PATH}/Contents/Resources/"

# Info.plist
cat > "${APP_PATH}/Contents/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>smart-translator</string>
    <key>CFBundleIdentifier</key>
    <string>com.smarttranslator.app</string>
    <key>CFBundleName</key>
    <string>${APP_NAME}</string>
    <key>CFBundleVersion</key>
    <string>${VERSION}</string>
    <key>CFBundleShortVersionString</key>
    <string>${VERSION}</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon.icns</string>
    <key>LSUIElement</key>
    <false/>
</dict>
</plist>
EOF

# 应用图标（如果存在）
if [ -f "installer/AppIcon.icns" ]; then
    cp installer/AppIcon.icns "${APP_PATH}/Contents/Resources/"
fi

# 创建DMG
echo "创建DMG..."

DMG_TEMP_DIR="dmg_temp"
mkdir -p "${DMG_TEMP_DIR}"
cp -R "${APP_PATH}" "${DMG_TEMP_DIR}/"

# 创建DMG
hdiutil create -volname "${APP_NAME}" \
    -srcfolder "${DMG_TEMP_DIR}" \
    -ov \
    -format UDZO \
    "${DMG_NAME}"

# 清理
rm -rf "${DMG_TEMP_DIR}"

echo "DMG创建完成: ${DMG_NAME}"
