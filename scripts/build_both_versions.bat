@echo off
setlocal enabledelayedexpansion

echo 🔨 Excel 序列号查询工具 - 双版本构建
echo ==========================================

echo 🧹 清理之前的构建...
cargo clean

echo.
echo 🔄 构建递归搜索版本（默认）...
cargo build --release
if errorlevel 1 (
    echo ❌ 递归搜索版本构建失败
    pause
    exit /b 1
)

echo ✅ 递归搜索版本构建成功
echo 📦 复制可执行文件...
copy target\release\searchns.exe searchns-recursive.exe
if errorlevel 1 (
    echo ❌ 复制递归版本失败
    pause
    exit /b 1
)

echo.
echo 📁 构建仅当前目录版本...
cargo build --release --no-default-features --features current-dir-only
if errorlevel 1 (
    echo ❌ 仅当前目录版本构建失败
    pause
    exit /b 1
)

echo ✅ 仅当前目录版本构建成功
echo 📦 复制可执行文件...
copy target\release\searchns.exe searchns-current-dir.exe
if errorlevel 1 (
    echo ❌ 复制当前目录版本失败
    pause
    exit /b 1
)

echo.
echo 🎉 构建完成！
echo ==========================================
echo 📋 生成的文件:
echo    📁 searchns-recursive.exe    - 递归搜索版本（搜索子目录）
echo    📁 searchns-current-dir.exe  - 仅当前目录版本（不搜索子目录）
echo.

echo 📊 文件信息:
for %%f in (searchns-recursive.exe searchns-current-dir.exe) do (
    if exist "%%f" (
        for %%s in ("%%f") do (
            echo    %%f: %%~zs 字节
        )
    )
)

echo.
echo 🧪 测试建议:
echo    1. 运行 searchns-recursive.exe 测试递归搜索功能
echo    2. 运行 searchns-current-dir.exe 测试仅当前目录搜索功能
echo    3. 比较两个版本的搜索结果差异

echo.
set /p test_run="是否测试仅当前目录版本? (y/N): "
if /i "!test_run!"=="y" (
    echo.
    echo 🏃 启动仅当前目录版本...
    echo 💡 提示: 这个版本只会搜索当前目录，不会搜索子目录
    echo 💡 输入 'quit' 退出程序
    echo.
    searchns-current-dir.exe
)

echo.
echo 📝 使用说明:
echo    • searchns-recursive.exe: 搜索当前目录及所有子目录
echo    • searchns-current-dir.exe: 仅搜索当前目录
echo    • 两个版本都支持不区分大小写搜索
echo    • 根据你的需要选择合适的版本使用

pause