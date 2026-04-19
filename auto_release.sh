#!/bin/bash
# 严格执行模式：出错立即退出，未定义变量报错
set -euo pipefail

# ==================== 配置项 ====================
# 版本文件路径
VERSION_FILE="VERSION"
# 允许发布的分支
ALLOWED_BRANCH="main"
# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# ==================== 工具函数 ====================
# 错误退出函数
error_exit() {
    echo -e "${RED}❌ $1${NC}"
    exit 1
}

# 检查文件存在
check_file() {
    [ -f "$1" ] || error_exit "缺少文件：$1"
}

# ==================== 主流程 ====================
clear
echo -e "${GREEN}=============================================${NC}"
echo -e "${GREEN}        Smart Translator 自动化发布流程        ${NC}"
echo -e "${GREEN}=============================================${NC}"

# 1. 读取基础信息
check_file "$VERSION_FILE"
VERSION=$(cat "$VERSION_FILE")
BRANCH=$(git rev-parse --abbrev-ref HEAD)

echo -e "📦 当前版本：${YELLOW}${VERSION}${NC}"
echo -e "🌱 当前分支：${YELLOW}${BRANCH}${NC}"
echo

# 2. 校验发布分支
if [ "$BRANCH" != "$ALLOWED_BRANCH" ]; then
    error_exit "只能从【${ALLOWED_BRANCH}】分支发布版本！"
fi

# 3. 检查工作区是否干净
if [ -n "$(git status --porcelain)" ]; then
    error_exit "Git 工作区存在未提交更改，请先提交/暂存！"
fi

# 4. 检查标签是否已存在（防止重复发布）
if git rev-parse "v${VERSION}" >/dev/null 2>&1; then
    error_exit "标签 v${VERSION} 已存在，请勿重复发布！"
fi

# 5. 用户确认发布
read -p "🔔 确认开始发布 v${VERSION} 版本？(y/n) " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo -e "${YELLOW}🚫 已取消发布流程${NC}"
    exit 0
fi
echo

# 6. 拉取远程最新代码（避免冲突）
echo -e "${YELLOW}🔄 拉取远程最新代码...${NC}"
git pull origin "$ALLOWED_BRANCH" --rebase
echo -e "${GREEN}✅ 代码已同步最新${NC}\n"

# 7. 执行版本升级（调用你之前的版本管理脚本）
echo -e "${YELLOW}🔧 升级版本号...${NC}"
# 执行根目录的版本发布脚本（patch 补丁升级）
./release.sh patch
echo -e "${GREEN}✅ 版本升级完成${NC}\n"

# 8. 推送代码 + 标签到 GitHub
echo -e "${YELLOW}🚀 推送代码和标签到远程仓库...${NC}"
git push origin "$ALLOWED_BRANCH"
git push origin --tags
echo -e "${GREEN}✅ 代码推送完成${NC}\n"

# 9. 完成提示（自动触发 CI/CD）
echo -e "${GREEN}=============================================${NC}"
echo -e "${GREEN}🎉 自动化发布流程已启动成功！${NC}"
echo -e "📌 发布版本：v${VERSION}"
echo -e "🔗 查看构建进度：https://github.com/你的用户名/smart-translator/actions"
echo -e "${GREEN}=============================================${NC}"
