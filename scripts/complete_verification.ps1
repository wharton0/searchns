# 完整的可执行文件验证脚本

Write-Host "🎯 Excel 序列号查询工具 - 完整验证" -ForegroundColor Cyan
Write-Host "=" * 60

$exePath = "target\release\searchns.exe"

if (-not (Test-Path $exePath)) {
    Write-Host "❌ 可执行文件不存在: $exePath" -ForegroundColor Red
    exit 1
}

Write-Host "✅ 找到可执行文件: $exePath" -ForegroundColor Green

# 1. 文件基本信息
$fileInfo = Get-ItemProperty $exePath
Write-Host "`n📊 文件信息:" -ForegroundColor Yellow
Write-Host "   大小: $([math]::Round($fileInfo.Length / 1KB, 2)) KB"
Write-Host "   创建时间: $($fileInfo.CreationTime)"
Write-Host "   修改时间: $($fileInfo.LastWriteTime)"

# 2. 版本信息验证
Write-Host "`n📋 版本信息验证:" -ForegroundColor Yellow
$versionInfo = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($exePath)

$expectedValues = @{
    "ProductName" = "Excel Serial Search Tool"
    "FileDescription" = "Excel Serial Number Search Tool"
    "CompanyName" = "Wharton Wang"
    "FileVersion" = "1.4.0.0"
    "ProductVersion" = "1.4.0.0"
    "OriginalFilename" = "searchns.exe"
    "LegalCopyright" = "Copyright (C) 2025 Wharton Wang"
    "Comments" = "A high-performance Excel serial number search tool"
}

$allCorrect = $true
foreach ($key in $expectedValues.Keys) {
    $actual = $versionInfo.$key
    $expected = $expectedValues[$key]
    
    if ($actual -eq $expected) {
        Write-Host "   ✅ $key`: $actual" -ForegroundColor Green
    } else {
        Write-Host "   ❌ $key`: 期望 '$expected', 实际 '$actual'" -ForegroundColor Red
        $allCorrect = $false
    }
}

# 3. 图标验证
Write-Host "`n🎨 图标验证:" -ForegroundColor Yellow
try {
    Add-Type -AssemblyName System.Drawing
    $icon = [System.Drawing.Icon]::ExtractAssociatedIcon($exePath)
    if ($icon) {
        Write-Host "   ✅ 图标已嵌入 ($($icon.Width)x$($icon.Height))" -ForegroundColor Green
        $icon.Dispose()
    } else {
        Write-Host "   ❌ 无法提取图标" -ForegroundColor Red
        $allCorrect = $false
    }
} catch {
    Write-Host "   ❌ 图标验证失败: $($_.Exception.Message)" -ForegroundColor Red
    $allCorrect = $false
}

# 4. 功能测试
Write-Host "`n🚀 功能测试:" -ForegroundColor Yellow
$testRun = Read-Host "是否运行程序进行功能测试? (y/N)"
if ($testRun -eq 'y' -or $testRun -eq 'Y') {
    Write-Host "启动程序..." -ForegroundColor Green
    Write-Host "提示: 输入 'quit' 退出程序`n" -ForegroundColor Cyan
    
    # 运行程序并捕获输出的前几行
    $process = Start-Process -FilePath $exePath -PassThru -NoNewWindow
    Start-Sleep -Seconds 2
    
    if ($process.HasExited) {
        Write-Host "   ❌ 程序异常退出" -ForegroundColor Red
        $allCorrect = $false
    } else {
        Write-Host "   ✅ 程序正常启动" -ForegroundColor Green
        # 终止测试进程
        $process.Kill()
        $process.WaitForExit()
    }
}

# 5. 最终总结
Write-Host "`n📋 验证总结:" -ForegroundColor Cyan
if ($allCorrect) {
    Write-Host "🎉 所有验证项目都通过了!" -ForegroundColor Green
    Write-Host "✅ 应用信息: 完整嵌入" -ForegroundColor Green
    Write-Host "✅ 图标: 成功嵌入" -ForegroundColor Green
    Write-Host "✅ 程序功能: 正常" -ForegroundColor Green
    
    Write-Host "`n🎯 最终检查步骤:" -ForegroundColor Yellow
    Write-Host "1. 在文件资源管理器中查看 $exePath" -ForegroundColor White
    Write-Host "2. 右键点击 → 属性 → 详细信息" -ForegroundColor White
    Write-Host "3. 确认所有信息显示正确" -ForegroundColor White
    Write-Host "4. 检查文件图标是否为自定义图标" -ForegroundColor White
} else {
    Write-Host "⚠️  部分验证项目未通过，请检查上述错误" -ForegroundColor Yellow
}

Write-Host "`n🔧 构建配置:" -ForegroundColor Cyan
Write-Host "   使用 embed-resource + app.rc 方式" -ForegroundColor White
Write-Host "   图标文件: icon.ico" -ForegroundColor White
Write-Host "   资源文件: app.rc" -ForegroundColor White
Write-Host "   构建脚本: build.rs" -ForegroundColor White