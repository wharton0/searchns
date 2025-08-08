# GitHub 上传指南

## 📋 准备工作

1. **确保已安装 Git**
   ```bash
   git --version
   ```

2. **在 GitHub 上创建新仓库**
   - 访问 https://github.com
   - 点击 "New repository"
   - 仓库名称: `excel-serial-search`
   - 描述: `A high-performance Excel serial number search tool`
   - 选择 Public 或 Private
   - **不要**勾选 "Initialize this repository with a README"
   - 点击 "Create repository"

## 🚀 上传步骤

### 1. 初始化 Git 仓库

```bash
# 在项目目录中初始化 Git
git init

# 添加所有文件
git add .

# 创建初始提交
git commit -m "Initial commit: Excel serial number search tool v1.3.0"
```

### 2. 连接到 GitHub 仓库

```bash
# 添加远程仓库（替换 your-username 为你的 GitHub 用户名）
git remote add origin https://github.com/your-username/excel-serial-search.git

# 设置主分支
git branch -M main
```

### 3. 推送到 GitHub

```bash
# 推送代码到 GitHub
git push -u origin main
```

### 4. 创建第一个 Release

```bash
# 创建并推送标签
git tag -a v1.3.0 -m "Release version 1.3.0"
git push origin v1.3.0
```

## 🔧 后续维护

### 日常提交流程

```bash
# 查看状态
git status

# 添加更改的文件
git add .

# 提交更改
git commit -m "描述你的更改"

# 推送到 GitHub
git push origin main
```

### 发布新版本

使用提供的发布脚本：

**Windows:**
```cmd
scripts\release.bat
```

**Linux/macOS:**
```bash
./scripts/release.sh
```

或手动执行：

```bash
# 更新版本号（在 Cargo.toml 中）
# 运行测试
cargo test

# 构建发布版本
cargo build --release

# 提交版本更新
git add Cargo.toml
git commit -m "chore: bump version to x.x.x"

# 创建标签
git tag -a vx.x.x -m "Release version x.x.x"

# 推送
git push origin main
git push origin vx.x.x
```

## 📝 重要提醒

1. **更新 README.md 中的链接**
   - 将所有 `your-username` 替换为你的实际 GitHub 用户名

2. **配置 GitHub Actions**
   - 推送代码后，GitHub Actions 会自动运行
   - 检查 Actions 标签页确保构建成功

3. **设置仓库描述和标签**
   - 在 GitHub 仓库页面添加描述
   - 添加相关标签: `rust`, `excel`, `search`, `xlsx`, `xls`

4. **启用 Issues 和 Discussions**
   - 在仓库设置中启用 Issues
   - 可选择启用 Discussions 用于社区交流

## 🎯 下一步

- [ ] 更新 README.md 中的用户名链接
- [ ] 添加项目截图或演示 GIF
- [ ] 编写更详细的使用文档
- [ ] 添加更多测试用例
- [ ] 考虑添加 CI/CD 徽章到 README

## 📞 需要帮助？

如果在上传过程中遇到问题：

1. 检查 Git 配置: `git config --list`
2. 确认远程仓库地址: `git remote -v`
3. 查看 Git 状态: `git status`
4. 查看提交历史: `git log --oneline`

---

祝你的项目在 GitHub 上获得成功！🎉