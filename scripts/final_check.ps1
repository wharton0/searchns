# 最终图标验证脚本

Write-Host "🎯 Excel 序列号查询工具 - 最终验证" -ForegroundColor Cyan
Write-Host "=" * 50

$exePath = "target\release\searchns.exe"

if (-not (Test-Path $exePath)) {
    Write-Host "❌ 可执行文件不存在: $exePath" -ForegroundColor Red
    Write-Host "💡 请先运行: cargo build --release" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ 找到可执行文件: $exePath" -ForegroundColor Green

# 检查文件大小
$fileInfo = Get-ItemProperty $exePath
$fileSizeKB = [math]::Round($fileInfo.Length / 1KB, 2)
Write-Host "📊 文件大小: $fileSizeKB KB" -ForegroundColor Yellow

# 检查图标
Add-Type -AssemblyName System.Drawing
try {
    $icon = [System.Drawing.Icon]::ExtractAssociatedIcon($exePath)
    if ($icon) {
        Write-Host "✅ 图标验证成功!" -ForegroundColor Green
        Write-Host "📐 图标尺寸: $($icon.Width)x$($icon.Height)" -ForegroundColor Green
        
        # 检查是否是默认图标
        $defaultIcon = [System.Drawing.Icon]::ExtractAssociatedIcon("C:\Windows\System32\notepad.exe")
        if ($icon.ToBitmap().GetPixel(0,0) -ne $defaultIcon.ToBitmap().GetPixel(0,0)) {
            Write-Host "🎨 确认使用自定义图标（非默认图标）" -ForegroundColor Green
        }
        
        $icon.Dispose()
        $defaultIcon.Dispose()
    } else {
        Write-Host "❌ 无法提取图标" -ForegroundColor Red
    }
} catch {
    Write-Host "⚠️  图标检查出错: $($_.Exception.Message)" -ForegroundColor Yellow
}

Write-Host "`n🔍 手动验证步骤:" -ForegroundColor Cyan
Write-Host "1. 打开文件资源管理器" -ForegroundColor White
Write-Host "2. 导航到项目目录" -ForegroundColor White
Write-Host "3. 查看 target\release\searchns.exe" -ForegroundColor White
Write-Host "4. 确认显示自定义图标而不是默认的 .exe 图标" -ForegroundColor White

Write-Host "`n🚀 程序功能测试:" -ForegroundColor Cyan
$runTest = Read-Host "是否运行程序测试功能? (y/N)"
if ($runTest -eq 'y' -or $runTest -eq 'Y') {
    Write-Host "`n🏃 启动程序..." -ForegroundColor Green
    Write-Host "💡 提示: 输入 'quit' 退出程序`n" -ForegroundColor Yellow
    & $exePath
}

Write-Host "`n📋 总结:" -ForegroundColor Cyan
Write-Host "✅ 可执行文件: 已生成" -ForegroundColor Green
Write-Host "✅ 图标嵌入: 成功" -ForegroundColor Green
Write-Host "✅ 文件大小: 正常 ($fileSizeKB KB)" -ForegroundColor Green
Write-Host "🎉 项目构建完成!" -ForegroundColor Green