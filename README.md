# 🐱 Sleeping Cat - Desktop Companion

A peaceful desktop companion that sleeps at the top of your screen. Watch as the cat's tail gently sways while it dreams.

## 🎉 Available for macOS and Windows! 🎉

### 📥 Quick Download
- **macOS**: [Download DMG](https://github.com/daiokawa/SleepingCat/releases/latest/download/SleepingCat.dmg)
- **Windows**: [Download from Windows Repository](https://github.com/daiokawa/SleepingCat-Windows)

https://github.com/user-attachments/assets/c2ed51d1-18f2-42eb-8258-3207bf892022

You can place your cat anywhere on your screen like this.

![Sleeping Cat Icon](icon_original.png)

## ✨ Features

- 🌙 Adorable sleeping cat animation
- 🎯 Stays at the top of your screen
- 🪶 Lightweight and unobtrusive
- 🎨 Hand-drawn artwork
- 💤 Realistic tail movement (62% static body, 38% animated tail)

## 📦 Installation

### macOS - Easy Install
1. Download the latest release from [Releases](https://github.com/daiokawa/SleepingCat/releases)
2. Open the DMG file
3. Drag "Sleeping Cat" to your Applications folder
4. Launch from Applications

### macOS - Manual Build
```bash
git clone https://github.com/daiokawa/SleepingCat.git
cd SleepingCat
swift build -c release
./create_app_bundle.sh
```

### Windows - Easy Install
1. Download the installer from [Releases](https://github.com/daiokawa/SleepingCat/releases)
2. Run "Sleeping Cat Setup X.X.X.exe"
3. Follow the installation wizard
4. Launch from Start Menu or Desktop shortcut

### Windows - Build from Source
Windows版のソースコードは`windows/`ディレクトリにあります。
```bash
git clone https://github.com/daiokawa/SleepingCat.git
cd SleepingCat/windows
npm install
npm run build-win
```

## 🎮 Usage

- **Launch**: Double-click "Sleeping Cat" in Applications
- **Move**: Click and drag the cat to reposition
- **Resize**: 
  - Right-click on the cat and select "大きくする" (Make Larger) or "小さくする" (Make Smaller)
  - Or use the menu bar icon 🐱
- **Quit**: Right-click on the cat and select "終了" (Quit) or use the menu bar

## 🖥 System Requirements

### macOS
- macOS 10.15 (Catalina) or later
- Apple Silicon or Intel Mac

### Windows
- Windows 10/11
- 64-bit system

## 🛠 Technical Details

### macOS
- Built with Swift and AppKit
- Uses AVFoundation for smooth video playback
- Hybrid static/animated approach for optimal performance
- ProRes 4444 video format with alpha channel

### Windows
- Built with Electron
- WebM video format with VP9 codec for transparency
- Transparent frameless window
- Cross-platform JavaScript/HTML5

## 📝 License

MIT License - See [LICENSE](LICENSE) file for details

## 🙏 Acknowledgments

- Original cat video by [your name/source]
- Icon artwork created with love

## 🐛 Troubleshooting

**Cat not appearing?**
- Check the top center of your screen
- Make sure no other windows are in full-screen mode
- Try relaunching the app

**Multiple cats appearing?**
- This has been fixed in v1.0
- Quit all instances and relaunch

---

Made with ❤️ for cat lovers everywhere
