# 验证两个版本的差异

Write-Host "🔍 验证两个版本的差异" -ForegroundColor Cyan
Write-Host "=" * 40

$recursiveExe = "searchns-recursive.exe"
$currentDirExe = "searchns-current-dir.exe"

# 检查文件是否存在
if (-not (Test-Path $recursiveExe)) {
    Write-Host "❌ 递归版本不存在: $recursiveExe" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $currentDirExe)) {
    Write-Host "❌ 仅当前目录版本不存在: $currentDirExe" -ForegroundColor Red
    exit 1
}

Write-Host "✅ 两个版本都存在" -ForegroundColor Green

# 获取文件信息
$recursiveInfo = Get-ItemProperty $recursiveExe
$currentDirInfo = Get-ItemProperty $currentDirExe

Write-Host "`n📊 文件信息对比:" -ForegroundColor Yellow
Write-Host "递归版本:"
Write-Host "   文件: $recursiveExe"
Write-Host "   大小: $([math]::Round($recursiveInfo.Length / 1KB, 2)) KB"
Write-Host "   修改时间: $($recursiveInfo.LastWriteTime)"

Write-Host "仅当前目录版本:"
Write-Host "   文件: $currentDirExe"
Write-Host "   大小: $([math]::Round($currentDirInfo.Length / 1KB, 2)) KB"
Write-Host "   修改时间: $($currentDirInfo.LastWriteTime)"

# 检查版本信息
Write-Host "`n📋 版本信息验证:" -ForegroundColor Yellow
$recursiveVersion = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($recursiveExe)
$currentDirVersion = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($currentDirExe)

Write-Host "递归版本:"
Write-Host "   产品名称: $($recursiveVersion.ProductName)"
Write-Host "   版本: $($recursiveVersion.ProductVersion)"
Write-Host "   描述: $($recursiveVersion.FileDescription)"

Write-Host "仅当前目录版本:"
Write-Host "   产品名称: $($currentDirVersion.ProductName)"
Write-Host "   版本: $($currentDirVersion.ProductVersion)"
Write-Host "   描述: $($currentDirVersion.FileDescription)"

# 功能差异说明
Write-Host "`n🔧 功能差异:" -ForegroundColor Cyan
Write-Host "📁 递归版本 ($recursiveExe):" -ForegroundColor Green
Write-Host "   • 搜索当前目录及所有子目录"
Write-Host "   • 适合在包含多层目录结构的环境中使用"
Write-Host "   • 搜索范围更广，但可能速度较慢"

Write-Host "📁 仅当前目录版本 ($currentDirExe):" -ForegroundColor Green
Write-Host "   • 仅搜索当前目录，不包括子目录"
Write-Host "   • 适合明确知道文件在当前目录的情况"
Write-Host "   • 搜索速度更快，范围有限"

Write-Host "`n🚀 使用建议:" -ForegroundColor Yellow
Write-Host "• 如果不确定文件位置，使用递归版本"
Write-Host "• 如果确定文件在当前目录，使用仅当前目录版本"
Write-Host "• 两个版本都支持不区分大小写搜索"
Write-Host "• 两个版本都支持 .xlsx 和 .xls 格式"

Write-Host "`n🧪 快速测试:" -ForegroundColor Cyan
$testChoice = Read-Host "选择要测试的版本 (1=递归, 2=仅当前目录, N=跳过)"

switch ($testChoice) {
    "1" {
        Write-Host "🏃 启动递归搜索版本..." -ForegroundColor Green
        & $recursiveExe
    }
    "2" {
        Write-Host "🏃 启动仅当前目录版本..." -ForegroundColor Green
        & $currentDirExe
    }
    default {
        Write-Host "跳过测试" -ForegroundColor Yellow
    }
}

Write-Host "`n✅ 验证完成!" -ForegroundColor Green