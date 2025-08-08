# Excel 序列号查询工具 - 构建验证脚本
# 验证可执行文件的图标和应用信息

Write-Host "🔍 Excel 序列号查询工具 - 构建验证" -ForegroundColor Cyan
Write-Host "=" * 50

$exePath = "target\release\excel-serial-search.exe"

# 检查可执行文件是否存在
if (-not (Test-Path $exePath)) {
    Write-Host "❌ 可执行文件不存在: $exePath" -ForegroundColor Red
    Write-Host "💡 请先运行: cargo build --release" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ 找到可执行文件: $exePath" -ForegroundColor Green

# 获取文件信息
try {
    $fileInfo = Get-ItemProperty $exePath
    $versionInfo = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($exePath)
    
    Write-Host "`n📊 文件基本信息:" -ForegroundColor Cyan
    Write-Host "   文件大小: $([math]::Round($fileInfo.Length / 1KB, 2)) KB"
    Write-Host "   创建时间: $($fileInfo.CreationTime)"
    Write-Host "   修改时间: $($fileInfo.LastWriteTime)"
    
    Write-Host "`n📋 版本信息:" -ForegroundColor Cyan
    Write-Host "   产品名称: $($versionInfo.ProductName)"
    Write-Host "   文件描述: $($versionInfo.FileDescription)"
    Write-Host "   公司名称: $($versionInfo.CompanyName)"
    Write-Host "   版权信息: $($versionInfo.LegalCopyright)"
    Write-Host "   产品版本: $($versionInfo.ProductVersion)"
    Write-Host "   文件版本: $($versionInfo.FileVersion)"
    Write-Host "   内部名称: $($versionInfo.InternalName)"
    Write-Host "   原始文件名: $($versionInfo.OriginalFilename)"
    Write-Host "   备注: $($versionInfo.Comments)"
    
    Write-Host "`n🎨 图标验证:" -ForegroundColor Cyan
    
    # 尝试提取图标信息
    Add-Type -AssemblyName System.Drawing
    try {
        $icon = [System.Drawing.Icon]::ExtractAssociatedIcon($exePath)
        if ($icon) {
            Write-Host "   ✅ 图标已嵌入" -ForegroundColor Green
            Write-Host "   📐 图标尺寸: $($icon.Width)x$($icon.Height)"
        } else {
            Write-Host "   ⚠️  未检测到自定义图标" -ForegroundColor Yellow
        }
        $icon.Dispose()
    } catch {
        Write-Host "   ⚠️  无法验证图标: $($_.Exception.Message)" -ForegroundColor Yellow
    }
    
    Write-Host "`n✅ 验证完成!" -ForegroundColor Green
    
    # 验证结果总结
    $issues = @()
    
    if (-not $versionInfo.ProductName) { $issues += "产品名称缺失" }
    if (-not $versionInfo.FileDescription) { $issues += "文件描述缺失" }
    if (-not $versionInfo.CompanyName) { $issues += "公司名称缺失" }
    if (-not $versionInfo.ProductVersion) { $issues += "产品版本缺失" }
    
    if ($issues.Count -eq 0) {
        Write-Host "`n🎉 所有应用信息都已正确嵌入!" -ForegroundColor Green
    } else {
        Write-Host "`n⚠️  发现以下问题:" -ForegroundColor Yellow
        foreach ($issue in $issues) {
            Write-Host "   - $issue" -ForegroundColor Yellow
        }
    }
    
} catch {
    Write-Host "❌ 获取文件信息失败: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "`n📝 手动验证步骤:" -ForegroundColor Cyan
Write-Host "   1. 在文件资源管理器中找到: $exePath"
Write-Host "   2. 右键点击 → 属性"
Write-Host "   3. 查看图标和'详细信息'标签页"

Write-Host "`n🚀 快速测试运行:" -ForegroundColor Cyan
$runTest = Read-Host "是否运行程序进行快速测试? (y/N)"
if ($runTest -eq 'y' -or $runTest -eq 'Y') {
    Write-Host "`n🏃 启动程序..." -ForegroundColor Green
    Write-Host "💡 提示: 输入 'quit' 退出程序`n" -ForegroundColor Yellow
    & $exePath
}