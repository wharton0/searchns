# Excel 序列号查询工具

🔎 一个高效的 Excel 文件序列号搜索工具，支持在目录及其子目录中批量搜索 Excel 文件中的特定序列号。

## ✨ 功能特性

- 🚀 **多格式支持**: 支持 `.xlsx` 和 `.xls` 格式文件
- 📁 **递归搜索**: 自动搜索当前目录及所有子目录
- 📊 **智能显示**: 显示表头列名而非列号，提供更直观的结果
- ⚡ **高性能**: 优化的搜索算法，快速处理大量文件
- 🎯 **部分匹配**: 支持序列号的部分匹配搜索
- 💻 **用户友好**: 清晰的界面和详细的搜索结果展示

## 🛠️ 安装要求

- Rust 1.70+ 
- Windows/Linux/macOS

## 📦 安装方式

### 从源码编译

```bash
# 克隆仓库
git clone https://github.com/wharton0/excel-serial-search.git
cd excel-serial-search

# 编译项目
cargo build --release

# 运行程序
cargo run
```

### 直接下载可执行文件

从 [Releases](https://github.com/wharton0/excel-serial-search/releases) 页面下载对应平台的可执行文件。

## 🚀 使用方法

1. 将程序放在包含 Excel 文件的目录中
2. 运行程序
3. 输入要搜索的序列号
4. 查看搜索结果

```bash
# 运行程序
./searchns

# 或者使用 cargo
cargo run
```

## 📋 使用示例

```
🔎 Excel 序列号查询工具 v1.3
🚀 支持 .xlsx 和 .xls 格式文件
📁 自动在当前目录及其子目录中搜索
📊 显示表头列名而非列号
============================================================
📁 搜索目录: C:\your\directory

----------------------------------------
🔍 请输入要查询的序列号 (输入 'quit' 退出): ABC123

🔍 正在搜索 5 个Excel文件...

✅ 搜索完成!

🎯 找到 2 个匹配结果:
================================================================================

📋 结果 1 :
📁 文件: data\inventory.xlsx
📊 工作表: Sheet1
📍 行号: 15
📄 行内容:
   产品编号: ABC123456
   产品名称: 测试产品
   数量: 100
   价格: 299.99
```

## 🏗️ 项目结构

```
excel-serial-search/
├── src/
│   └── main.rs          # 主程序文件
├── Cargo.toml           # 项目配置
├── README.md            # 项目说明
├── LICENSE              # 许可证
└── .gitignore           # Git 忽略文件
```

## 🔧 技术栈

- **语言**: Rust
- **Excel 处理**: [calamine](https://crates.io/crates/calamine) - 高性能 Excel 文件读取库
- **时间处理**: [chrono](https://crates.io/crates/chrono) - 日期时间处理

## 📈 性能特点

- **内存优化**: 流式处理大文件，避免内存溢出
- **搜索优化**: 使用高效的字符串匹配算法
- **并发处理**: 支持多文件并行处理（未来版本）

## 🤝 贡献指南

欢迎提交 Issue 和 Pull Request！

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 📝 更新日志

### v1.3 (当前版本)
- ✅ 优化代码结构，提高可维护性
- ✅ 修复编译错误和警告
- ✅ 改进搜索性能
- ✅ 增强错误处理

### v1.2
- ✅ 添加表头显示功能
- ✅ 支持相对路径显示
- ✅ 优化用户界面

### v1.1
- ✅ 添加 XLS 格式支持
- ✅ 递归目录搜索

### v1.0
- ✅ 基础 XLSX 文件搜索功能

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 👨‍💻 作者

**Wharton Wang**

## 🙏 致谢

- [calamine](https://github.com/tafia/calamine) - 优秀的 Excel 处理库
- Rust 社区的支持和贡献

---

如果这个工具对你有帮助，请给个 ⭐ Star！