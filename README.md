# Smart Translator
> Windows 平台智能实时屏幕翻译工具 | OCR + 多引擎翻译

---

![CI Status](https://img.shields.io/github/actions/workflow/status/你的用户名/SmartTranslator/ci.yml?branch=main)
![platform](https://img.shields.io/badge/platform-Windows-blue)
![license](https://img.shields.io/github/license/你的用户名/SmartTranslator)

---

## 项目介绍
本项目是一款专为 **Windows 平台**打造的智能实时屏幕翻译工具，结合屏幕 OCR 识别与多翻译引擎，实现对任意屏幕内容的实时翻译，支持游戏、视频、文档等多场景使用，无需切换窗口即可获取翻译结果。

---

## 核心功能
- ✅ **实时屏幕 OCR 翻译**：支持全屏/自定义区域识别，一键获取文本并翻译
- ✅ **多翻译引擎支持**：可配置多个翻译接口，满足不同场景的翻译需求
- ✅ **Windows 深度适配**：针对 Windows 系统优化，低资源占用，后台稳定运行
- ✅ **自定义悬浮显示**：翻译结果以悬浮窗形式展示，不遮挡原内容
- ✅ **全局热键唤起**：支持自定义热键，快速启动/关闭翻译功能

---

## Windows 构建指南
### 环境依赖
- 系统：Windows 10 / Windows 11（64位）
- Qt：5.15.2（MSVC2019 64-bit 版本）
- CMake：3.16 及以上
- 编译器：Visual Studio 2022（需安装 MSVC 编译器组件）

### 构建步骤
1.  **克隆仓库**
    ```bash
    git clone https://github.com/你的用户名/SmartTranslator.git
    cd SmartTranslator
