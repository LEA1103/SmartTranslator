#!/bin/bash
# 严格模式：出错立即退出，未定义变量报错
set -euo pipefail

# ==================== 配置项 ====================
VERSION_FILE="VERSION"
CHANGELOG_FILE="CHANGELOG.md"
SCRIPT_NAME="Smart Translator 版本发布工具"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # 清除颜色

# ==================== 工具函数 ====================
# 检查Git工作区是否干净
check_git_clean() {
    if [[ -n $(git status --porcelain) ]]; then
        echo -e "${RED}错误：Git工作区存在未提交的更改！${NC}"
        echo "请先提交或暂存所有修改后再发布版本"
        exit 1
    fi
}

# 获取当前版本
get_current_version() {
    if [ -f "$VERSION_FILE" ]; then
        cat "$VERSION_FILE"
    else
        echo "0.1.0"
    fi
}

# 版本号递增（语义化：主版本.次版本.补丁号）
bump_version() {
    local version=$1
    local part=$2

    # 分割版本号
    IFS='.' read -r major minor patch <<< "$version"

    case $part in
        major)
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        minor)
            minor=$((minor + 1))
            patch=0
            ;;
        patch)
            patch=$((patch + 1))
            ;;
        *)
            echo -e "${RED}错误：无效的版本类型！可用：major/minor/patch${NC}"
            exit 1
            ;;
    esac

    echo "${major}.${minor}.${patch}"
}

# 创建Git标签并推送
create_tag() {
    local version=$1
    echo -e "${YELLOW}📌 创建Git标签: v${version}${NC}"
    git tag -a "v${version}" -m "Release v${version}"
    git push origin "v${version}"
}

# 生成/更新CHANGELOG
generate_changelog() {
    local new_version=$1
    local date=$(date +%Y-%m-%d)

    # 如果文件不存在，创建新文件
    if [ ! -f "$CHANGELOG_FILE" ]; then
        touch "$CHANGELOG_FILE"
    fi

    # 写入新的版本日志（头部插入）
    echo -e "# 更新日志\n
## [${new_version}] - ${date}
### ✨ 新增
- 待补充：新增功能
### 🐛 修复
- 待补充：问题修复
### 🔄 变更
- 待补充：功能调整\n
$(cat "${CHANGELOG_FILE}")" > "${CHANGELOG_FILE}.tmp"

    mv "${CHANGELOG_FILE}.tmp" "${CHANGELOG_FILE}"
    echo -e "${GREEN}✅ CHANGELOG 已更新${NC}"
}

# ==================== 主函数 ====================
main() {
    clear
    echo -e "${GREEN}=============================================${NC}"
    echo -e "${GREEN}  ${SCRIPT_NAME}${NC}"
    echo -e "${GREEN}=============================================${NC}"

    # 检查Git环境
    check_git_clean

    # 获取参数（默认patch版本）
    local part=${1:-patch}
    local current_version=$(get_current_version)
    local new_version=$(bump_version "$current_version" "$part")

    # 展示版本信息
    echo -e "📦 当前版本: ${YELLOW}${current_version}${NC}"
    echo -e "🚀 新版本: ${GREEN}${new_version}${NC}"
    echo

    # 确认发布
    read -p "确认发布 ${new_version} 版本？(y/n) " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo -e "${YELLOW}🚫 已取消版本发布${NC}"
        exit 0
    fi

    echo -e "\n${YELLOW}🔧 开始发布流程...${NC}"

    # 1. 更新版本文件
    echo "${new_version}" > "$VERSION_FILE"
    echo -e "${GREEN}✅ 版本文件已更新${NC}"

    # 2. 生成CHANGELOG
    generate_changelog "${new_version}"

    # 3. 提交更改
    git add "$VERSION_FILE" "$CHANGELOG_FILE"
    git commit -m "chore(release): v${new_version}"
    echo -e "${GREEN}✅ 版本文件已提交${NC}"

    # 4. 创建并推送标签
    create_tag "${new_version}"

    # 完成
    echo -e "\n${GREEN}=============================================${NC}"
    echo -e "${GREEN}🎉 版本 v${new_version} 发布成功！${NC}"
    echo -e "${GREEN}=============================================${NC}"
}

# 执行主函数
main "$@"
