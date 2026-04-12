#!/bin/bash

# 自动化发布流程
set -e

VERSION=$(cat VERSION)
BRANCH=$(git rev-parse --abbrev-ref HEAD)

echo "发布版本: ${VERSION}"
echo "当前分支: ${BRANCH}"

# 检查分支
if [ "$BRANCH" != "main" ]; then
    echo "错误：必须从main分支发布"
    exit 1
fi

# 检查是否有未提交的更改
if [ -n "$(git status --porcelain)" ]; then
    echo "错误：存在未提交的更改"
    exit 1
fi

# 拉取最新代码
echo "拉取最新代码..."
git pull origin main

# 更新版本
echo "更新版本号..."
./scripts/version.sh patch

# 推送到GitHub
echo "推送代码..."
git push origin main
git push origin --tags

# 触发GitHub Actions
echo "触发构建和发布..."

# 等待CI完成（简化版）
echo "请等待GitHub Actions完成构建"
echo "访问: https://github.com/yourusername/smart-translator/actions"

echo "发布流程完成！"
