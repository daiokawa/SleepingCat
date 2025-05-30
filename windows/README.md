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

## 配布

Windows環境で以下を実行：
```bash
npm run build-win
```

`dist`フォルダに`.exe`インストーラーが作成されます。

## 注意事項

- Windows 10/11で動作確認済み
- 透過ウィンドウをサポート
- 右クリックで終了