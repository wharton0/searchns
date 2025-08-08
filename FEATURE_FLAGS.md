# Feature Flags 使用指南

本项目使用 Rust 的 feature flags 来控制搜索行为，提供两种不同的搜索模式。

## 🔧 可用的 Feature Flags

### 1. `recursive-search` (默认启用)

**功能描述**: 递归搜索当前目录及所有子目录中的 Excel 文件

**适用场景**:
- 需要在整个目录树中查找文件
- 文件可能分布在多个子目录中
- 希望进行全面的搜索

**编译命令**:
```bash
# 默认编译（自动启用 recursive-search）
cargo build --release

# 显式启用 recursive-search
cargo build --release --features recursive-search
```

**运行命令**:
```bash
# 默认运行
cargo run --release

# 显式运行递归搜索版本
cargo run --release --features recursive-search
```

### 2. `current-dir-only`

**功能描述**: 仅搜索当前目录中的 Excel 文件，不包括子目录

**适用场景**:
- 只需要在当前目录中查找文件
- 提高搜索速度，避免扫描大量子目录
- 明确知道文件就在当前目录中

**编译命令**:
```bash
# 编译仅当前目录版本
cargo build --release --no-default-features --features current-dir-only
```

**运行命令**:
```bash
# 运行仅当前目录版本
cargo run --release --no-default-features --features current-dir-only
```

## 📊 功能对比

| 特性 | recursive-search | current-dir-only |
|------|------------------|------------------|
| 搜索范围 | 当前目录 + 所有子目录 | 仅当前目录 |
| 搜索速度 | 较慢（取决于目录结构） | 较快 |
| 内存使用 | 较高（需要遍历目录树） | 较低 |
| 适用场景 | 全面搜索 | 快速搜索 |
| 默认启用 | ✅ | ❌ |

## 🚀 实际使用示例

### 场景 1: 全面搜索（推荐）

当你不确定 Excel 文件在哪个子目录中时：

```bash
# 使用默认的递归搜索
cargo run --release
```

程序会显示：
```
📁 自动在当前目录及其子目录中搜索
```

### 场景 2: 快速搜索

当你确定 Excel 文件就在当前目录中时：

```bash
# 使用仅当前目录搜索
cargo run --release --no-default-features --features current-dir-only
```

程序会显示：
```
📁 仅在当前目录中搜索（不包括子目录）
```

## 🔨 构建不同版本

### 构建递归搜索版本
```bash
cargo build --release
# 生成: target/release/excel-serial-search.exe
```

### 构建仅当前目录版本
```bash
cargo build --release --no-default-features --features current-dir-only
# 生成: target/release/excel-serial-search.exe (覆盖上一个版本)
```

### 同时构建两个版本
```bash
# 构建递归版本
cargo build --release
cp target/release/excel-serial-search.exe excel-serial-search-recursive.exe

# 构建当前目录版本
cargo build --release --no-default-features --features current-dir-only
cp target/release/excel-serial-search.exe excel-serial-search-current-dir.exe
```

## ⚠️ 注意事项

1. **互斥性**: `recursive-search` 和 `current-dir-only` 是互斥的，不能同时启用
2. **默认行为**: 如果不指定任何 feature，默认启用 `recursive-search`
3. **性能考虑**: 在包含大量子目录的环境中，`current-dir-only` 模式会显著提高搜索速度
4. **兼容性**: 两种模式的搜索结果格式完全相同，只是搜索范围不同

## 🧪 测试不同模式

你可以通过以下方式快速测试两种模式的区别：

```bash
# 创建测试目录结构
mkdir test-dir
mkdir test-dir/subdir
echo "test" > test-dir/test.xlsx
echo "test" > test-dir/subdir/test2.xlsx

cd test-dir

# 测试递归搜索（应该找到两个文件）
cargo run --release

# 测试仅当前目录搜索（应该只找到一个文件）
cargo run --release --no-default-features --features current-dir-only
```

---

通过合理选择 feature flags，你可以根据具体需求优化程序的搜索行为和性能表现。