#!/bin/bash

# 语义化版本管理
VERSION_FILE="VERSION"
CHANGELOG_FILE="CHANGELOG.md"

# 获取当前版本
get_current_version() {
    if [ -f "$VERSION_FILE" ]; then
        cat "$VERSION_FILE"
    else
        echo "0.1.0"
    fi
}

# 版本号增加
bump_version() {
    local version=$1
    local part=$2

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
    esac

    echo "${major}.${minor}.${patch}"
}

# 创建版本标签
create_tag() {
    local version=$1

    echo "创建标签: v${version}"
    git tag -a "v${version}" -m "Release ${version}"
    git push origin "v${version}"
}

# 生成CHANGELOG
generate_changelog() {
    local new_version=$1

    echo "# 更新日志

## [${new_version}] - $(date +%Y-%m-%d)

### 新增
- 功能描述

### 修复
- 修复描述

### 变更
- 变更描述

$(cat "${CHANGELOG_FILE}")" > "${CHANGELOG_FILE}.new"

    mv "${CHANGELOG_FILE}.new" "${CHANGELOG_FILE}"

    echo "CHANGELOG已更新"
}

# 主函数
main() {
    local part=${1:-patch}

    echo "当前版本: $(get_current_version)"

    local new_version=$(bump_version "$(get_current_version)" "$part")
    echo "新版本: ${new_version}"

    echo -n "确认发布 ${new_version}? (y/n) "
    read confirm

    if [ "$confirm" = "y" ]; then
        # 更新版本文件
        echo "${new_version}" > "$VERSION_FILE"

        # 生成CHANGELOG
        generate_changelog "${new_version}"

        # 提交更改
        git add "$VERSION_FILE" "$CHANGELOG_FILE"
        git commit -m "chore: release ${new_version}"

        # 创建标签
        create_tag "${new_version}"

        echo "版本 ${new_version} 发布成功！"
    else
        echo "取消发布"
        exit 1
    fi
}

main "$@"
