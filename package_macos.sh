#!/bin/bash
# 严格模式：出错立即退出，未定义变量报错
set -euo pipefail

# ==================== 配置项 ====================
APP_NAME="SmartTranslator"
VERSION="1.0.0"
BUNDLE_ID="com.smarttranslator.app"
APP_PATH="${APP_NAME}.app"
BUILD_DIR="build"
EXECUTABLE_NAME="smart-translator"
DMG_NAME="${APP_NAME}-${VERSION}.dmg"
DMG_TEMP_DIR="dmg_temp"

# 颜色输出（美化日志）
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}=============================================${NC}"
echo -e "${GREEN}  开始构建 ${APP_NAME} v${VERSION} 安装包 ${NC}"
echo -e "${GREEN}=============================================${NC}"

# ==================== 前置检查 ====================
echo "🔍 检查构建产物是否存在..."
if [ ! -f "${BUILD_DIR}/bin/${EXECUTABLE_NAME}" ]; then
    echo -e "${RED}错误：未找到可执行文件 ${BUILD_DIR}/bin/${EXECUTABLE_NAME}${NC}"
    echo "请先完成编译！"
    exit 1
fi

if [ ! -f "config/config.yaml" ]; then
    echo -e "${RED}错误：未找到配置文件 config/config.yaml${NC}"
    exit 1
fi

# 检查 hdiutil 工具（macOS 自带）
if ! command -v hdiutil &> /dev/null; then
    echo -e "${RED}错误：未找到 hdiutil 工具，仅支持在 macOS 上运行${NC}"
    exit 1
fi

# ==================== 清理旧文件 ====================
echo "🧹 清理旧版本文件..."
rm -rf "${APP_PATH}" "${DMG_TEMP_DIR}" "${DMG_NAME}"

# ==================== 创建 .app 目录结构 ====================
echo "📦 创建 .app 应用包结构..."
mkdir -p "${APP_PATH}/Contents/MacOS"
mkdir -p "${APP_PATH}/Contents/Resources"

# ==================== 复制可执行文件 + 赋权 ====================
cp "${BUILD_DIR}/bin/${EXECUTABLE_NAME}" "${APP_PATH}/Contents/MacOS/"
chmod +x "${APP_PATH}/Contents/MacOS/${EXECUTABLE_NAME}"

# ==================== 复制配置文件 ====================
cp config/config.yaml "${APP_PATH}/Contents/Resources/"

# ==================== 生成完整的 Info.plist (macOS 官方规范) ====================
echo "📝 生成 Info.plist 配置文件..."
cat > "${APP_PATH}/Contents/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key>
    <string>${APP_NAME}</string>
    <key>CFBundleDisplayName</key>
    <string>${APP_NAME}</string>
    <key>CFBundleExecutable</key>
    <string>${EXECUTABLE_NAME}</string>
    <key>CFBundleIdentifier</key>
    <string>${BUNDLE_ID}</string>
    <key>CFBundleVersion</key>
    <string>${VERSION}</string>
    <key>CFBundleShortVersionString</key>
    <string>${VERSION}</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleSignature</key>
    <string>????</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon.icns</string>
    <key>LSUIElement</key>
    <false/>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>LSMinimumSystemVersion</key>
    <string>10.15</string>
</dict>
</plist>
EOF

# ==================== 复制应用图标 ====================
if [ -f "installer/AppIcon.icns" ]; then
    echo "🖼️ 安装应用图标..."
    cp installer/AppIcon.icns "${APP_PATH}/Contents/Resources/"
else
    echo "⚠️  未找到 AppIcon.icns，使用默认图标"
fi

# ==================== 创建 DMG 安装包 ====================
echo "💿 生成 DMG 磁盘镜像..."
mkdir -p "${DMG_TEMP_DIR}"
cp -R "${APP_PATH}" "${DMG_TEMP_DIR}/"

# 创建 DMG（压缩格式，macOS 通用）
hdiutil create \
    -volname "${APP_NAME}" \
    -srcfolder "${DMG_TEMP_DIR}" \
    -ov \
    -format UDZO \
    "${DMG_NAME}"

# ==================== 清理临时文件 ====================
echo "🧹 清理临时文件..."
rm -rf "${DMG_TEMP_DIR}" "${APP_PATH}"

# ==================== 完成 ====================
echo -e "${GREEN}=============================================${NC}"
echo -e "${GREEN}✅ DMG 打包完成！${NC}"
echo -e "📦 输出文件：${GREEN}${DMG_NAME}${NC}"
echo -e "${GREEN}=============================================${NC}"
