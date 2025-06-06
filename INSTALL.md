# インストールガイド / Installation Guide

## 🚨 初回起動時の注意 / First Launch Notice

macOSのセキュリティ機能により、初回起動時に警告が表示される場合があります。

### 「開発元を検証できません」と表示された場合：

1. **キャンセル**をクリック
2. **システム設定** → **プライバシーとセキュリティ**を開く
3. 「Sleeping Catは開発元を検証できないため...」の横の**「このまま開く」**をクリック
4. 確認ダイアログで**「開く」**をクリック

または：

1. Finderで**Applications**フォルダを開く
2. **Sleeping Cat**を右クリック（またはControlキーを押しながらクリック）
3. **「開く」**を選択
4. 確認ダイアログで**「開く」**をクリック

## 📦 インストール手順

1. `SleepingCat-v1.0.dmg`をダウンロード
2. ダウンロードしたDMGファイルをダブルクリック
3. **Sleeping Cat**を**Applications**フォルダにドラッグ
4. DMGウィンドウを閉じて、デスクトップのDMGアイコンを取り出し
5. Applicationsフォルダから**Sleeping Cat**を起動

## 🗑 アンインストール

1. Applicationsフォルダを開く
2. **Sleeping Cat**をゴミ箱にドラッグ
3. ゴミ箱を空にする

## ❓ トラブルシューティング

**猫が表示されない場合：**
- 画面の最上部中央を確認
- 他のフルスクリーンアプリを終了
- アプリを再起動

**「壊れているため開けません」と表示される場合：**
- ターミナルを開いて以下を実行：
  ```bash
  xattr -cr "/Applications/Sleeping Cat.app"
  ```