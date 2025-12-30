@echo off
chcp 65001 >nul
echo ========================================
echo GitHub Release 自动化脚本
echo ========================================
echo.

REM 配置区域 - 请根据实际情况修改 jefferyvivienne36@outlook.com
set "GITHUB_USERNAME=jefferyvi"
set "REPO_NAME=phoneModel"
set "VERSION=v1.0"
set "APK_PATH=phoneModel.apk"
set "APK_NEW_NAME=phoneModel-%VERSION%.apk"

echo 当前配置:
echo GitHub 用户名: %GITHUB_USERNAME%
echo 仓库名称: %REPO_NAME%
echo 版本号: %VERSION%
echo APK 路径: %APK_PATH%
echo.

REM 检查 GitHub CLI 是否安装
set "GH_PATH="
where gh >nul 2>&1
if %errorlevel% equ 0 (
    set "GH_PATH=gh"
) else (
    if exist "%ProgramFiles%\GitHub CLI\gh.exe" (
        set "GH_PATH=%ProgramFiles%\GitHub CLI\gh.exe"
    ) else (
        echo [错误] 未检测到 GitHub CLI (gh)
        echo 请重新打开命令行窗口或重启电脑
        pause
        exit /b 1
    )
)

echo [提示] 使用 GitHub CLI: %GH_PATH%

REM 检查是否登录
"%GH_PATH%" auth status >nul 2>&1
if %errorlevel% neq 0 (
    echo [提示] 需要登录 GitHub
    echo 正在启动登录流程...
    "%GH_PATH%" auth login
    if %errorlevel% neq 0 (
        echo [错误] 登录失败
        pause
        exit /b 1
    )
)

echo [1/6] 检查 Git 仓库状态...
if not exist ".git" (
    echo [提示] 未检测到 Git 仓库，正在初始化...
    git init
    git branch -M main
)

echo [2/6] 检查远程仓库...
git remote get-url origin >nul 2>&1
if %errorlevel% neq 0 (
    echo [提示] 添加远程仓库...
    git remote add origin https://github.com/%GITHUB_USERNAME%/%REPO_NAME%.git
) else (
    echo 远程仓库已存在
)

echo [3/6] 提交更改...
git add .
git commit -m "Release %VERSION%"
if %errorlevel% neq 0 (
    echo [提示] 没有新的更改需要提交
)

echo [4/6] 推送到 GitHub...
git push -u origin main
if %errorlevel% neq 0 (
    echo [警告] 推送失败，尝试强制推送...
    git push -u origin main --force
)

echo [5/6] 创建 Git 标签...
git tag %VERSION% 2>nul
git push origin %VERSION% 2>nul

echo [6/6] 创建 GitHub Release 并上传 APK...
"%GH_PATH%" release create %VERSION% "%APK_PATH%#%APK_NEW_NAME%" ^
    --title "懒猫 %VERSION%" ^
    --notes "## 📱 下载安装%VERSION%^

### 功能更新
- 版本：%VERSION%
- 构建时间：%date% %time%

### 📥 下载方式
1. 点击下方 APK 文件直接下载
2. 扫描二维码下载（见下方链接）

### 安装说明
1. 下载 APK 文件
2. 允许安装未知来源应用
3. 点击安装

---
🔗 下载链接将在发布后生成" ^
    --latest

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo ✅ 发布成功！
    echo ========================================
    echo.
    echo Release 页面:
    echo https://github.com/%GITHUB_USERNAME%/%REPO_NAME%/releases/tag/%VERSION%
    echo.
    echo APK 下载链接:
    echo https://github.com/%GITHUB_USERNAME%/%REPO_NAME%/releases/download/%VERSION%/%APK_NEW_NAME%
    echo.
    echo 📱 生成二维码:
    echo 访问 https://qrcode.tec-it.com/
    echo 或使用下面的在线生成链接
    echo.
) else (
    echo.
    echo ========================================
    echo ❌ 发布失败
    echo ========================================
    echo 请检查错误信息
)

pause
