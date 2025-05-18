# OllamaTranslator

## English

OllamaTranslator is a macOS application that provides instant translation between Chinese and English using locally running Ollama models. It detects text language automatically and translates clipboard content when focused.

### Features

- Automatic language detection between Chinese and English
- One-click translation using locally hosted Ollama models
- Clipboard integration for quick translation workflows
- Clean, simple SwiftUI interface
- Privacy-focused: all translation occurs locally without sending data to external services

### Requirements

- macOS device
- [Ollama](https://ollama.com/) installed and running locally on port 11434
- Recommended model: qwen2.5:1.5b (or any model capable of translation)

### Usage

1. Install and run Ollama on your Mac
2. Pull the recommended model: `ollama pull qwen2.5:1.5b`
3. Launch OllamaTranslator
4. Copy text to translate to your clipboard
5. Click in the input field to automatically paste and translate

## 中文

OllamaTranslator 是一款 macOS 应用程序，使用本地运行的 Ollama 模型提供中英文之间的即时翻译。它能自动检测文本语言，并在获得焦点时翻译剪贴板内容。

### 特点

- 自动检测中文和英文
- 使用本地托管的 Ollama 模型进行一键翻译
- 剪贴板集成，实现快速翻译工作流
- 简洁的 SwiftUI 界面
- 注重隐私：所有翻译在本地进行，无需将数据发送到外部服务

### 要求

- macOS 设备
- 本地安装并运行 [Ollama](https://ollama.com/)，默认端口 11434
- 推荐模型：qwen2.5:1.5b（或任何能够进行翻译的模型）

### 使用方法

1. 在 Mac 上安装并运行 Ollama
2. 拉取推荐模型：`ollama pull qwen2.5:1.5b`
3. 启动 OllamaTranslator
4. 将需要翻译的文本复制到剪贴板
5. 点击输入框自动粘贴并翻译