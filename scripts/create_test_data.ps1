# 创建测试数据的脚本说明

Write-Host "📊 创建测试数据说明" -ForegroundColor Cyan
Write-Host "=" * 40

Write-Host "为了测试不区分大小写搜索功能，建议创建包含以下数据的 Excel 文件:" -ForegroundColor Yellow

Write-Host "`n📋 测试数据示例:" -ForegroundColor Green
Write-Host "序列号列可以包含:" -ForegroundColor White
Write-Host "• ABC123" -ForegroundColor Cyan
Write-Host "• abc123" -ForegroundColor Cyan
Write-Host "• Abc123" -ForegroundColor Cyan
Write-Host "• aBc123" -ForegroundColor Cyan
Write-Host "• SERIAL001" -ForegroundColor Cyan
Write-Host "• serial001" -ForegroundColor Cyan
Write-Host "• Serial001" -ForegroundColor Cyan
Write-Host "• TEST-456" -ForegroundColor Cyan
Write-Host "• test-456" -ForegroundColor Cyan
Write-Host "• Test-456" -ForegroundColor Cyan

Write-Host "`n🧪 测试方法:" -ForegroundColor Green
Write-Host "1. 创建一个 Excel 文件，包含上述不同大小写的序列号" -ForegroundColor White
Write-Host "2. 运行程序: target\release\searchns.exe" -ForegroundColor White
Write-Host "3. 搜索 'abc123'，应该能找到 ABC123, abc123, Abc123, aBc123" -ForegroundColor White
Write-Host "4. 搜索 'SERIAL'，应该能找到所有包含 serial 的记录" -ForegroundColor White
Write-Host "5. 搜索 'test'，应该能找到所有包含 test 的记录" -ForegroundColor White

Write-Host "`n📝 Excel 文件结构建议:" -ForegroundColor Green
Write-Host "列A: 序列号 (包含不同大小写的测试数据)" -ForegroundColor White
Write-Host "列B: 产品名称" -ForegroundColor White
Write-Host "列C: 数量" -ForegroundColor White
Write-Host "列D: 价格" -ForegroundColor White

Write-Host "`n💡 提示:" -ForegroundColor Yellow
Write-Host "• 可以使用 Excel 或 LibreOffice Calc 创建测试文件" -ForegroundColor White
Write-Host "• 保存为 .xlsx 或 .xls 格式" -ForegroundColor White
Write-Host "• 将文件放在程序运行目录中" -ForegroundColor White

Write-Host "`n🎯 预期结果:" -ForegroundColor Cyan
Write-Host "程序应该能够找到所有匹配的记录，无论输入的大小写如何。" -ForegroundColor White
Write-Host "这大大提高了搜索的灵活性和用户体验。" -ForegroundColor Green