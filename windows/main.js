const { app, BrowserWindow, screen } = require('electron');
const path = require('path');

let mainWindow;

function createWindow() {
  // スクリーンサイズを取得
  const primaryDisplay = screen.getPrimaryDisplay();
  const { width: screenWidth } = primaryDisplay.workAreaSize;

  // ウィンドウを作成
  mainWindow = new BrowserWindow({
    width: 280,
    height: 140,
    x: Math.floor((screenWidth - 280) / 2), // 画面中央上部
    y: 50,
    transparent: true,     // 透過ウィンドウ
    frame: false,          // フレームなし
    alwaysOnTop: true,     // 常に最前面
    hasShadow: false,      // 影なし
    resizable: false,      // リサイズ不可
    skipTaskbar: true,     // タスクバーに表示しない
    webPreferences: {
      nodeIntegration: true,
      contextIsolation: false
    }
  });

  // HTMLを読み込む
  mainWindow.loadFile('index.html');

  // ウィンドウが閉じられたときの処理
  mainWindow.on('closed', () => {
    mainWindow = null;
  });

  // 右クリックで終了できるようにする
  mainWindow.webContents.on('context-menu', (e) => {
    app.quit();
  });
}

// アプリケーションの準備ができたら
app.whenReady().then(createWindow);

// すべてのウィンドウが閉じられたとき
app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

// アプリケーションがアクティブになったとき
app.on('activate', () => {
  if (mainWindow === null) {
    createWindow();
  }
});

// 多重起動を防ぐ
const gotTheLock = app.requestSingleInstanceLock();

if (!gotTheLock) {
  app.quit();
} else {
  app.on('second-instance', () => {
    // 既存のウィンドウにフォーカス
    if (mainWindow) {
      if (mainWindow.isMinimized()) mainWindow.restore();
      mainWindow.focus();
    }
  });
}