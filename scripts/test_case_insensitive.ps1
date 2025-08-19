# 测试不区分大小写搜索功能

Write-Host "🧪 测试不区分大小写搜索功能" -ForegroundColor Cyan
Write-Host "=" * 50

$exePath = "target\release\searchns.exe"

if (-not (Test-Path $exePath)) {
    Write-Host "❌ 可执行文件不存在: $exePath" -ForegroundColor Red
    Write-Host "💡 请先运行: cargo build --release" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ 找到可执行文件: $exePath" -ForegroundColor Green

# 检查版本信息
$versionInfo = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($exePath)
Write-Host "📋 程序版本: $($versionInfo.ProductVersion)" -ForegroundColor Yellow
Write-Host "📝 程序描述: $($versionInfo.Comments)" -ForegroundColor Yellow

Write-Host "`n🔤 不区分大小写搜索测试说明:" -ForegroundColor Cyan
Write-Host "现在程序支持不区分大小写的搜索功能，这意味着:" -ForegroundColor White
Write-Host "• 搜索 'abc123' 可以找到 'ABC123', 'Abc123', 'aBc123' 等" -ForegroundColor Green
Write-Host "• 搜索 'SERIAL' 可以找到 'serial', 'Serial', 'SeRiAl' 等" -ForegroundColor Green
Write-Host "• 搜索 'Test' 可以找到 'test', 'TEST', 'TeSt' 等" -ForegroundColor Green

Write-Host "`n📊 功能改进:" -ForegroundColor Cyan
Write-Host "✅ 不区分大小写搜索" -ForegroundColor Green
Write-Host "✅ 支持 .xlsx 和 .xls 文件" -ForegroundColor Green
Write-Host "✅ 递归目录搜索" -ForegroundColor Green
Write-Host "✅ 表头列名显示" -ForegroundColor Green
Write-Host "✅ 完整的应用信息和图标" -ForegroundColor Green

Write-Host "`n🚀 测试建议:" -ForegroundColor Yellow
Write-Host "1. 准备一些包含不同大小写序列号的 Excel 文件" -ForegroundColor White
Write-Host "2. 尝试用不同大小写输入相同的序列号" -ForegroundColor White
Write-Host "3. 验证程序能找到所有匹配的记录" -ForegroundColor White

Write-Host "`n🏃 启动程序进行测试:" -ForegroundColor Cyan
$runTest = Read-Host "是否启动程序进行测试? (y/N)"
if ($runTest -eq 'y' -or $runTest -eq 'Y') {
    Write-Host "`n🎯 启动程序..." -ForegroundColor Green
    Write-Host "💡 提示: 尝试输入不同大小写的序列号进行测试" -ForegroundColor Yellow
    Write-Host "💡 输入 'quit' 退出程序`n" -ForegroundColor Yellow
    & $exePath
}

Write-Host "`n📋 测试完成!" -ForegroundColor Green
Write-Host "如果程序能够找到不同大小写的匹配项，说明功能正常工作。" -ForegroundColor White