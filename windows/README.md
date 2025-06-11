# Sleeping Cat for Windows v1.2

Windows版のSleeping Catです。

## 新機能 (v1.2)

- 🎯 右クリックメニューから7段階のサイズ選択（30%〜300% + フルスクリーン）
- 🌸 スムーズで有機的なアニメーション
- 🖥️ マルチディスプレイ対応
- 📏 センターベースのスケーリングで位置ずれを解消

## 開発

```bash
# 依存関係のインストール
npm install

# 開発モードで起動
npm start

# Windows用インストーラーの作成
npm run build-win
```

## インストーラーのビルド

### Windows環境でのビルド
```bash
npm run build-win
```

### macOS環境からのクロスビルド
```bash
# Wineが必要（Homebrewでインストール可能）
brew install wine-stable
npm run build-win
```

`dist`フォルダに以下のファイルが作成されます：
- `Sleeping Cat Setup X.X.X.exe` - Windowsインストーラー
- その他の配布用ファイル

## インストーラーの特徴

- ワンクリックインストール対応
- インストール先の変更可能
- スタートメニューへの登録
- デスクトップショートカットの作成（オプション）
- アンインストーラー付属

## 注意事項

- Windows 10/11で動作確認済み
- 透過ウィンドウをサポート
- 右クリックでサイズメニューと終了オプション
- .NET Framework不要（Electron内蔵）
- 動画の上部余白を削除してより自然な表示に