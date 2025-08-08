# Feature Flags 实现总结

## 🎯 实现目标

通过 Rust 的 feature flags 机制，为 Excel 序列号查询工具提供两种搜索模式：
1. **递归搜索模式** (默认): 搜索当前目录及所有子目录
2. **仅当前目录模式**: 只搜索当前目录，提高搜索速度

## ✅ 已实现的功能

### 1. Cargo.toml 配置
```toml
[features]
default = ["recursive-search"]
recursive-search = []
current-dir-only = []
```

### 2. 条件编译实现
- 使用 `#[cfg(feature = "recursive-search")]` 控制递归搜索逻辑
- 使用 `#[cfg(feature = "current-dir-only")]` 控制仅当前目录搜索逻辑
- 在程序启动信息中显示当前搜索模式

### 3. 用户界面差异
- **递归模式**: "📁 自动在当前目录及其子目录中搜索"
- **仅当前目录模式**: "📁 仅在当前目录中搜索（不包括子目录）"

### 4. 错误提示差异
- 根据搜索模式显示不同的"未找到文件"提示信息

## 🔧 使用方法

### 编译不同版本
```bash
# 递归搜索版本（默认）
cargo build --release

# 仅当前目录版本
cargo build --release --no-default-features --features current-dir-only
```

### 运行不同版本
```bash
# 递归搜索版本
cargo run --release

# 仅当前目录版本
cargo run --release --no-default-features --features current-dir-only
```

## 📊 性能对比

| 模式 | 搜索范围 | 速度 | 内存使用 | 适用场景 |
|------|----------|------|----------|----------|
| recursive-search | 当前目录 + 子目录 | 较慢 | 较高 | 全面搜索 |
| current-dir-only | 仅当前目录 | 较快 | 较低 | 快速搜索 |

## 🚀 自动化构建

### GitHub Actions 支持
- 自动构建两个版本的可执行文件
- 在 Release 中提供两种版本的下载

### 发布脚本更新
- `scripts/release.bat` 支持同时构建两个版本
- 自动生成带后缀的可执行文件

## 📝 文档完善

### 新增文档
1. `FEATURE_FLAGS.md` - 详细的使用指南
2. `FEATURE_SUMMARY.md` - 实现总结
3. 更新 `README.md` - 添加 feature flags 说明
4. 更新 `CHANGELOG.md` - 记录新功能

### 更新内容
- 安装说明中包含两种编译方式
- 使用示例展示不同模式的区别
- GitHub Actions 配置支持多版本构建

## 🧪 测试验证

### 编译测试
- ✅ 默认模式编译成功
- ✅ 仅当前目录模式编译成功
- ✅ 两种模式都能正常运行

### 功能测试
- ✅ 递归模式显示正确的搜索范围提示
- ✅ 仅当前目录模式显示正确的搜索范围提示
- ✅ 错误提示根据模式正确显示

## 🎉 实现效果

通过 feature flags 的实现，用户现在可以：

1. **灵活选择搜索模式**: 根据实际需求选择合适的搜索范围
2. **优化性能**: 在明确文件位置时使用仅当前目录模式提高速度
3. **保持兼容性**: 默认行为保持不变，不影响现有用户
4. **清晰的用户反馈**: 程序界面明确显示当前使用的搜索模式

这个实现完美地平衡了功能性、性能和用户体验，为不同使用场景提供了最优的解决方案。