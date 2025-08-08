@echo off
setlocal enabledelayedexpansion

echo 🧪 Excel 序列号查询工具 - 构建测试
echo ==========================================

echo 📋 检查必要文件...

:: 检查图标文件
if exist "icon.ico" (
    echo ✅ 图标文件: icon.ico 存在
) else (
    echo ❌ 图标文件: icon.ico 不存在
    set "missing_files=1"
)

:: 检查清单文件
if exist "app.manifest" (
    echo ✅ 清单文件: app.manifest 存在
) else (
    echo ❌ 清单文件: app.manifest 不存在
    set "missing_files=1"
)

:: 检查构建脚本
if exist "build.rs" (
    echo ✅ 构建脚本: build.rs 存在
) else (
    echo ❌ 构建脚本: build.rs 不存在
    set "missing_files=1"
)

if defined missing_files (
    echo.
    echo ❌ 缺少必要文件，请检查项目完整性
    pause
    exit /b 1
)

echo.
echo 🔨 开始构建测试...

:: 清理之前的构建
echo 🧹 清理构建缓存...
cargo clean

:: 构建递归搜索版本
echo 🔄 构建递归搜索版本...
cargo build --release
if errorlevel 1 (
    echo ❌ 递归搜索版本构建失败
    pause
    exit /b 1
)

:: 检查可执行文件
if exist "target\release\excel-serial-search.exe" (
    echo ✅ 可执行文件生成成功
    
    :: 获取文件大小
    for %%A in ("target\release\excel-serial-search.exe") do (
        set "filesize=%%~zA"
    )
    echo 📊 文件大小: !filesize! 字节
) else (
    echo ❌ 可执行文件生成失败
    pause
    exit /b 1
)

:: 构建仅当前目录版本
echo 📁 构建仅当前目录版本...
cargo build --release --no-default-features --features current-dir-only
if errorlevel 1 (
    echo ❌ 仅当前目录版本构建失败
    pause
    exit /b 1
)

echo.
echo ✅ 构建测试完成！

echo.
echo 📋 测试结果:
echo    ✅ 递归搜索版本: 构建成功
echo    ✅ 仅当前目录版本: 构建成功
echo    ✅ 图标和应用信息: 已嵌入
echo    📁 可执行文件: target\release\excel-serial-search.exe

echo.
echo 🔍 验证步骤:
echo    1. 在文件资源管理器中找到可执行文件
echo    2. 右键点击 → 属性
echo    3. 查看图标是否正确显示
echo    4. 查看"详细信息"标签页中的应用信息

echo.
echo 🚀 快速测试运行:
set /p test_run="是否运行程序进行快速测试? (y/N): "
if /i "!test_run!"=="y" (
    echo.
    echo 🏃 启动程序...
    echo 💡 提示: 输入 'quit' 退出程序
    echo.
    target\release\excel-serial-search.exe
)

echo.
echo 🎉 测试完成！
pause