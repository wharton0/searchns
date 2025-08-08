#!/bin/bash

# 发布脚本
set -e

echo "🚀 开始发布流程..."

# 检查是否有未提交的更改
if [[ -n $(git status --porcelain) ]]; then
    echo "❌ 有未提交的更改，请先提交所有更改"
    exit 1
fi

# 获取当前版本
CURRENT_VERSION=$(grep '^version = ' Cargo.toml | sed 's/version = "\(.*\)"/\1/')
echo "📋 当前版本: $CURRENT_VERSION"

# 询问新版本
read -p "🔢 请输入新版本号 (当前: $CURRENT_VERSION): " NEW_VERSION

if [[ -z "$NEW_VERSION" ]]; then
    echo "❌ 版本号不能为空"
    exit 1
fi

# 更新版本号
echo "📝 更新版本号到 $NEW_VERSION..."
sed -i.bak "s/^version = \".*\"/version = \"$NEW_VERSION\"/" Cargo.toml
rm Cargo.toml.bak

# 运行测试
echo "🧪 运行测试..."
cargo test

# 构建发布版本
echo "🔨 构建发布版本..."
cargo build --release

# 提交更改
echo "📤 提交版本更新..."
git add Cargo.toml
git commit -m "chore: bump version to $NEW_VERSION"

# 创建标签
echo "🏷️  创建标签..."
git tag -a "v$NEW_VERSION" -m "Release version $NEW_VERSION"

# 推送到远程
echo "⬆️  推送到远程仓库..."
git push origin main
git push origin "v$NEW_VERSION"

echo "✅ 发布完成！"
echo "🌐 GitHub Actions 将自动构建并创建 Release"
echo "📦 Release 页面: https://github.com/your-username/excel-serial-search/releases"