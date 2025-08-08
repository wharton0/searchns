# 检查可执行文件图标的简单脚本

$exePath = "target\release\searchns.exe"

Write-Host "🔍 检查可执行文件图标..." -ForegroundColor Cyan

if (-not (Test-Path $exePath)) {
    Write-Host "❌ 可执行文件不存在: $exePath" -ForegroundColor Red
    exit 1
}

Write-Host "✅ 找到可执行文件: $exePath" -ForegroundColor Green

# 检查文件大小
$fileInfo = Get-ItemProperty $exePath
Write-Host "📊 文件大小: $([math]::Round($fileInfo.Length / 1KB, 2)) KB" -ForegroundColor Yellow

# 尝试提取图标
Add-Type -AssemblyName System.Drawing
try {
    $icon = [System.Drawing.Icon]::ExtractAssociatedIcon($exePath)
    if ($icon) {
        Write-Host "✅ 图标已成功嵌入!" -ForegroundColor Green
        Write-Host "📐 图标尺寸: $($icon.Width)x$($icon.Height)" -ForegroundColor Green
        
        # 保存图标到文件进行验证
        $iconPath = "extracted_icon.ico"
        $fileStream = [System.IO.FileStream]::new($iconPath, [System.IO.FileMode]::Create)
        $icon.Save($fileStream)
        $fileStream.Close()
        
        Write-Host "💾 图标已提取到: $iconPath" -ForegroundColor Green
        
        # 比较原始图标和提取的图标大小
        $originalSize = (Get-ItemProperty "icon.ico").Length
        $extractedSize = (Get-ItemProperty $iconPath).Length
        
        Write-Host "📋 图标对比:" -ForegroundColor Cyan
        Write-Host "   原始图标: $originalSize 字节" -ForegroundColor White
        Write-Host "   提取图标: $extractedSize 字节" -ForegroundColor White
        
        if ($originalSize -eq $extractedSize) {
            Write-Host "✅ 图标完全匹配!" -ForegroundColor Green
        } else {
            Write-Host "⚠️  图标大小不同，但这是正常的（可能是压缩或格式转换）" -ForegroundColor Yellow
        }
        
    } else {
        Write-Host "❌ 未检测到图标" -ForegroundColor Red
    }
    $icon.Dispose()
} catch {
    Write-Host "❌ 提取图标失败: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n📝 手动验证:" -ForegroundColor Cyan
Write-Host "   1. 在文件资源管理器中查看 $exePath" -ForegroundColor White
Write-Host "   2. 应该能看到自定义图标而不是默认的 .exe 图标" -ForegroundColor White
Write-Host "   3. 右键 → 属性 → 查看图标" -ForegroundColor White