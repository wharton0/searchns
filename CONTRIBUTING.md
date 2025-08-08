# 贡献指南

感谢你对 Excel 序列号查询工具的关注！我们欢迎各种形式的贡献。

## 🤝 如何贡献

### 报告 Bug

如果你发现了 bug，请：

1. 检查 [Issues](https://github.com/your-username/excel-serial-search/issues) 确认问题未被报告
2. 创建新的 Issue，包含：
   - 详细的问题描述
   - 重现步骤
   - 预期行为 vs 实际行为
   - 系统环境信息
   - 相关的错误日志

### 功能请求

如果你有新功能的想法：

1. 先在 Issues 中讨论你的想法
2. 描述功能的用途和价值
3. 提供具体的使用场景

### 代码贡献

#### 开发环境设置

```bash
# 克隆仓库
git clone https://github.com/your-username/excel-serial-search.git
cd excel-serial-search

# 安装依赖
cargo build

# 运行测试
cargo test

# 运行程序
cargo run
```

#### 提交流程

1. **Fork** 仓库
2. **创建分支** (`git checkout -b feature/amazing-feature`)
3. **编写代码** 并确保：
   - 代码风格一致
   - 添加必要的测试
   - 更新相关文档
4. **提交更改** (`git commit -m 'Add amazing feature'`)
5. **推送分支** (`git push origin feature/amazing-feature`)
6. **创建 Pull Request**

#### 代码规范

- 使用 `cargo fmt` 格式化代码
- 使用 `cargo clippy` 检查代码质量
- 确保所有测试通过 (`cargo test`)
- 为新功能添加测试
- 更新相关文档

#### 提交信息规范

使用清晰的提交信息：

```
类型: 简短描述

详细描述（可选）

- 修复了什么问题
- 添加了什么功能
- 为什么做这个更改
```

类型包括：
- `feat`: 新功能
- `fix`: Bug 修复
- `docs`: 文档更新
- `style`: 代码格式化
- `refactor`: 代码重构
- `test`: 测试相关
- `chore`: 构建过程或辅助工具的变动

## 📋 开发指南

### 项目结构

```
excel-serial-search/
├── src/
│   └── main.rs          # 主程序
├── tests/               # 测试文件
├── docs/                # 文档
├── .github/             # GitHub Actions
├── Cargo.toml           # 项目配置
└── README.md            # 项目说明
```

### 测试

```bash
# 运行所有测试
cargo test

# 运行特定测试
cargo test test_name

# 运行集成测试
cargo test --test integration_test
```

### 性能测试

```bash
# 构建优化版本
cargo build --release

# 性能基准测试
cargo bench
```

## 🎯 优先级任务

当前需要帮助的领域：

- [ ] 添加单元测试和集成测试
- [ ] 支持更多 Excel 格式特性
- [ ] 添加配置文件支持
- [ ] 改进错误处理和用户提示
- [ ] 性能优化
- [ ] 国际化支持

## 📞 联系方式

如果你有任何问题，可以：

- 创建 Issue
- 发送邮件到 [your-email@example.com]
- 在 Pull Request 中讨论

## 📄 许可证

通过贡献代码，你同意你的贡献将在 MIT 许可证下发布。

---

再次感谢你的贡献！🎉