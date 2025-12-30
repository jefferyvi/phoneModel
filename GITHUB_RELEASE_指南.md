# 📦 GitHub Release 发布指南

## 🎯 快速开始

### 方案一：自动化脚本（推荐）

#### 1. 安装 GitHub CLI

```powershell
# 使用 winget 安装（推荐）
winget install --id GitHub.cli

# 或下载安装器
# https://cli.github.com/
```

#### 2. 配置脚本

编辑 `release-to-github.bat` 文件，修改以下配置：

```batch
set "GITHUB_USERNAME=your-username"     # 替换为您的 GitHub 用户名
set "REPO_NAME=ActFlow"                 # 仓库名称
set "VERSION=v1.6.3"                    # 当前版本号
```

#### 3. 运行脚本

```cmd
cd D:\argle\Documents\win11\Android\ActFlow
release-to-github.bat
```

脚本会自动完成：
- ✅ 初始化 Git 仓库（如果需要）
- ✅ 添加并提交更改
- ✅ 推送到 GitHub
- ✅ 创建版本标签
- ✅ 创建 Release 并上传 APK
- ✅ 生成下载链接

---

## 📱 生成下载二维码

### 方法一：使用本地 HTML 工具（推荐）

1. 打开 `生成下载二维码.html` 文件
2. 填写您的 GitHub 信息：
   - GitHub 用户名
   - 仓库名称：ActFlow
   - 版本号：v1.6.3
   - APK 文件名：LanMao-v1.6.3.apk
3. 点击"生成二维码"
4. 点击"下载二维码"保存为图片

### 方法二：在线二维码生成器

使用 Release 后生成的下载链接：

```
https://github.com/YOUR-USERNAME/ActFlow/releases/download/v1.6.3/LanMao-v1.6.3.apk
```

访问以下网站生成二维码：

1. **草料二维码**（中文）
   - https://cli.im/
   - 支持自定义样式和 Logo

2. **QR Code Generator**（国际）
   - https://www.qr-code-generator.com/
   - 功能丰富，支持高清下载

3. **快图云**
   - https://www.wwei.cn/
   - 简单快速

---

## 🔧 手动发布步骤

如果不使用自动化脚本，可以手动执行：

### 1. 初始化 Git 仓库

```bash
cd D:\argle\Documents\win11\Android\ActFlow
git init
git branch -M main
```

### 2. 创建 GitHub 仓库

在 GitHub 上创建新仓库：https://github.com/new

### 3. 关联远程仓库

```bash
git remote add origin https://github.com/YOUR-USERNAME/ActFlow.git
```

### 4. 提交并推送

```bash
git add .
git commit -m "Release v1.6.3"
git push -u origin main
```

### 5. 创建 Release

**方法 A：使用 GitHub CLI**

```bash
gh release create v1.6.3 "app\build\outputs\apk\release_benco\懒猫1.6(3).apk#LanMao-v1.6.3.apk" ^
    --title "懒猫 v1.6.3" ^
    --notes "版本更新说明" ^
    --latest
```

**方法 B：使用 GitHub 网页**

1. 访问：https://github.com/YOUR-USERNAME/ActFlow/releases/new
2. 填写标签版本：v1.6.3
3. 填写 Release 标题：懒猫 v1.6.3
4. 上传 APK 文件
5. 填写更新说明
6. 点击"Publish release"

---

## 📝 Release 说明模板

```markdown
## 📱 懒猫 v1.6.3 版本更新

### ✨ 新增功能
- 功能 1
- 功能 2

### 🐛 问题修复
- 修复问题 1
- 修复问题 2

### 📥 下载安装

#### 方式一：直接下载
点击下方 APK 文件下载

#### 方式二：扫码下载
扫描二维码直接下载安装

![下载二维码](二维码图片链接)

### 📌 安装说明
1. 下载 APK 文件
2. 在设备上允许安装未知来源应用
3. 点击安装即可

### 📊 版本信息
- 版本号：v1.6.3
- 构建时间：2025-12-30
- APK 大小：[自动显示]

---
💡 如有问题请提交 Issue
```

---

## 🎨 美化二维码

### 添加 Logo

使用在线工具添加您的应用图标：
- https://www.logosc.cn/logo/qrcode

### 自定义样式

1. 修改颜色
2. 添加渐变效果
3. 添加边框和文字
4. 设置圆角

### 推荐尺寸

- **小尺寸**：200x200 像素（适合网页）
- **标准尺寸**：400x400 像素（推荐）
- **高清尺寸**：800x800 像素（打印）

---

## 🚀 自动化进阶

### GitHub Actions 自动发布

创建 `.github/workflows/release.yml`：

```yaml
name: Release APK

on:
  push:
    tags:
      - 'v*'

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup JDK
        uses: actions/setup-java@v3
        with:
          java-version: '17'
          distribution: 'temurin'
      
      - name: Build APK
        run: |
          cd Android/ActFlow
          chmod +x ./gradlew
          ./gradlew assembleRelease
      
      - name: Create Release
        uses: softprops/action-gh-release@v1
        with:
          files: Android/ActFlow/app/build/outputs/apk/release_benco/*.apk
          body: |
            ## 📱 懒猫 ${{ github.ref_name }}
            
            ### 下载安装
            点击下方 APK 文件下载安装
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

---

## 📚 参考资源

- [GitHub CLI 文档](https://cli.github.com/manual/)
- [GitHub Releases 指南](https://docs.github.com/zh/repositories/releasing-projects-on-github)
- [二维码最佳实践](https://www.qr-code-generator.com/qr-code-marketing/qr-codes-basics/)

---

## 🎉 完成清单

- [ ] 安装 GitHub CLI
- [ ] 配置发布脚本
- [ ] 创建 GitHub 仓库
- [ ] 运行发布脚本
- [ ] 生成下载二维码
- [ ] 分享给用户

**祝发布顺利！** 🎊
