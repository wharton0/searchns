# 使用 Windows API 直接检查资源

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class ResourceChecker {
    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern IntPtr LoadLibraryEx(string lpFileName, IntPtr hReservedNull, uint dwFlags);
    
    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern bool FreeLibrary(IntPtr hModule);
    
    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern IntPtr FindResource(IntPtr hModule, IntPtr lpName, IntPtr lpType);
    
    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern uint SizeofResource(IntPtr hModule, IntPtr hResInfo);
    
    public const uint LOAD_LIBRARY_AS_DATAFILE = 0x00000002;
    public const int RT_ICON = 3;
    public const int RT_GROUP_ICON = 14;
    public const int RT_VERSION = 16;
}
"@

$exePath = "target\release\searchns.exe"

Write-Host "🔍 深度资源检查: $exePath" -ForegroundColor Cyan

if (-not (Test-Path $exePath)) {
    Write-Host "❌ 文件不存在" -ForegroundColor Red
    exit 1
}

try {
    # 加载可执行文件作为数据文件
    $hModule = [ResourceChecker]::LoadLibraryEx($exePath, [IntPtr]::Zero, [ResourceChecker]::LOAD_LIBRARY_AS_DATAFILE)
    
    if ($hModule -eq [IntPtr]::Zero) {
        Write-Host "❌ 无法加载文件" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "✅ 文件加载成功" -ForegroundColor Green
    
    # 检查图标资源
    $iconResource = [ResourceChecker]::FindResource($hModule, [IntPtr]1, [IntPtr][ResourceChecker]::RT_GROUP_ICON)
    if ($iconResource -ne [IntPtr]::Zero) {
        $iconSize = [ResourceChecker]::SizeofResource($hModule, $iconResource)
        Write-Host "✅ 找到图标资源 (大小: $iconSize 字节)" -ForegroundColor Green
    } else {
        Write-Host "❌ 未找到图标资源" -ForegroundColor Red
    }
    
    # 检查版本资源
    $versionResource = [ResourceChecker]::FindResource($hModule, [IntPtr]1, [IntPtr][ResourceChecker]::RT_VERSION)
    if ($versionResource -ne [IntPtr]::Zero) {
        $versionSize = [ResourceChecker]::SizeofResource($hModule, $versionResource)
        Write-Host "✅ 找到版本资源 (大小: $versionSize 字节)" -ForegroundColor Green
    } else {
        Write-Host "❌ 未找到版本资源" -ForegroundColor Red
    }
    
    # 释放模块
    [ResourceChecker]::FreeLibrary($hModule) | Out-Null
    
} catch {
    Write-Host "❌ 检查过程出错: $($_.Exception.Message)" -ForegroundColor Red
}

# 使用 PowerShell 的图标提取
Write-Host "`n🎨 图标提取测试:" -ForegroundColor Cyan
try {
    Add-Type -AssemblyName System.Drawing
    $icon = [System.Drawing.Icon]::ExtractAssociatedIcon($exePath)
    if ($icon) {
        Write-Host "✅ 成功提取图标 ($($icon.Width)x$($icon.Height))" -ForegroundColor Green
        
        # 保存图标进行比较
        $extractedPath = "test_extracted.ico"
        $fileStream = [System.IO.FileStream]::new($extractedPath, [System.IO.FileMode]::Create)
        $icon.Save($fileStream)
        $fileStream.Close()
        $icon.Dispose()
        
        Write-Host "💾 图标已保存到: $extractedPath" -ForegroundColor Green
        
        # 比较文件大小
        $originalSize = (Get-ItemProperty "icon.ico").Length
        $extractedSize = (Get-ItemProperty $extractedPath).Length
        
        Write-Host "📊 大小对比:" -ForegroundColor Yellow
        Write-Host "   原始: $originalSize 字节" -ForegroundColor White
        Write-Host "   提取: $extractedSize 字节" -ForegroundColor White
        
    } else {
        Write-Host "❌ 无法提取图标" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ 图标提取失败: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n📋 总结:" -ForegroundColor Cyan
Write-Host "如果看到 '✅ 找到图标资源' 和 '✅ 成功提取图标'，" -ForegroundColor White
Write-Host "那么图标确实已经嵌入到可执行文件中。" -ForegroundColor White
Write-Host "如果在文件资源管理器中看不到图标，可能是缓存问题。" -ForegroundColor Yellow