@echo off
setlocal enabledelayedexpansion

echo 🚀 开始发布流程...

:: 检查是否有未提交的更改
git status --porcelain > temp.txt
set /p STATUS=<temp.txt
del temp.txt

if not "!STATUS!"=="" (
    echo ❌ 有未提交的更改，请先提交所有更改
    exit /b 1
)

:: 获取当前版本
for /f "tokens=3 delims= " %%a in ('findstr "^version = " Cargo.toml') do set CURRENT_VERSION=%%a
set CURRENT_VERSION=%CURRENT_VERSION:"=%

echo 📋 当前版本: %CURRENT_VERSION%

:: 询问新版本
set /p NEW_VERSION="🔢 请输入新版本号 (当前: %CURRENT_VERSION%): "

if "%NEW_VERSION%"=="" (
    echo ❌ 版本号不能为空
    exit /b 1
)

:: 更新版本号
echo 📝 更新版本号到 %NEW_VERSION%...
powershell -Command "(Get-Content Cargo.toml) -replace '^version = \".*\"', 'version = \"%NEW_VERSION%\"' | Set-Content Cargo.toml"

:: 运行测试
echo 🧪 运行测试...
cargo test
if errorlevel 1 (
    echo ❌ 测试失败
    exit /b 1
)

:: 构建发布版本
echo 🔨 构建发布版本...
cargo build --release
if errorlevel 1 (
    echo ❌ 构建失败
    exit /b 1
)

:: 提交更改
echo 📤 提交版本更新...
git add Cargo.toml
git commit -m "chore: bump version to %NEW_VERSION%"

:: 创建标签
echo 🏷️  创建标签...
git tag -a "v%NEW_VERSION%" -m "Release version %NEW_VERSION%"

:: 推送到远程
echo ⬆️  推送到远程仓库...
git push origin main
git push origin "v%NEW_VERSION%"

echo ✅ 发布完成！
echo 🌐 GitHub Actions 将自动构建并创建 Release
echo 📦 Release 页面: https://github.com/your-username/excel-serial-search/releases

pause