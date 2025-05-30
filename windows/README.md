# Sleeping Cat for Windows

Windows版のSleeping Catです。

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
- 右クリックで終了
- .NET Framework不要（Electron内蔵）