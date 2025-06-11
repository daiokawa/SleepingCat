const { app, BrowserWindow, screen, Menu, ipcMain } = require('electron');
const path = require('path');

let mainWindow;
let currentScale = 1.0;
const baseWidth = 280;
const baseHeight = 115;  // Adjusted for trimmed video
const minScale = 0.3;
const maxScale = 3.0;

function createWindow() {
  // Get screen size
  const primaryDisplay = screen.getPrimaryDisplay();
  const { width: screenWidth, height: screenHeight } = primaryDisplay.workAreaSize;

  // Create window
  mainWindow = new BrowserWindow({
    width: baseWidth,
    height: baseHeight,
    x: Math.floor((screenWidth - baseWidth) / 2), // Center horizontally
    y: 50,
    transparent: true,
    frame: false,
    alwaysOnTop: true,
    hasShadow: false,
    resizable: false,
    skipTaskbar: true,
    webPreferences: {
      nodeIntegration: true,
      contextIsolation: false
    }
  });

  // Load HTML
  mainWindow.loadFile('index.html');

  // Window closed handler
  mainWindow.on('closed', () => {
    mainWindow = null;
  });

  // Enable dragging
  mainWindow.webContents.on('dom-ready', () => {
    mainWindow.webContents.executeJavaScript(`
      document.body.style.webkitAppRegion = 'drag';
      document.body.style.userSelect = 'none';
    `);
  });

  // Right-click menu
  createContextMenu();
}

function createContextMenu() {
  const contextMenu = Menu.buildFromTemplate([
    {
      label: 'サイズ / Size',
      submenu: [
        {
          label: '極小 / Tiny (30%)',
          click: () => setScale(0.3),
          type: 'checkbox',
          checked: Math.abs(currentScale - 0.3) < 0.01
        },
        {
          label: '小 / Small (50%)',
          click: () => setScale(0.5),
          type: 'checkbox',
          checked: Math.abs(currentScale - 0.5) < 0.01
        },
        {
          label: '標準 / Standard (100%)',
          click: () => setScale(1.0),
          type: 'checkbox',
          checked: Math.abs(currentScale - 1.0) < 0.01
        },
        {
          label: '大 / Large (150%)',
          click: () => setScale(1.5),
          type: 'checkbox',
          checked: Math.abs(currentScale - 1.5) < 0.01
        },
        {
          label: '特大 / Extra Large (200%)',
          click: () => setScale(2.0),
          type: 'checkbox',
          checked: Math.abs(currentScale - 2.0) < 0.01
        },
        {
          label: '最大 / Maximum (300%)',
          click: () => setScale(3.0),
          type: 'checkbox',
          checked: Math.abs(currentScale - 3.0) < 0.01
        },
        { type: 'separator' },
        {
          label: 'フルスクリーン / Full Screen',
          click: () => setFullScreen()
        }
      ]
    },
    { type: 'separator' },
    {
      label: '終了 / Quit',
      click: () => app.quit()
    }
  ]);

  mainWindow.webContents.on('context-menu', (e) => {
    e.preventDefault();
    // Update menu checkmarks
    createContextMenu();
    contextMenu.popup(mainWindow);
  });
}

function setScale(targetScale) {
  if (targetScale < minScale || targetScale > maxScale) return;
  
  const bounds = mainWindow.getBounds();
  const centerX = bounds.x + bounds.width / 2;
  const centerY = bounds.y + bounds.height / 2;
  
  const newWidth = Math.round(baseWidth * targetScale);
  const newHeight = Math.round(baseHeight * targetScale);
  
  // Calculate new position to keep center
  const newX = Math.round(centerX - newWidth / 2);
  const newY = Math.round(centerY - newHeight / 2);
  
  currentScale = targetScale;
  
  // Send scale info to renderer for animation
  mainWindow.webContents.send('scale-animation', {
    scale: targetScale,
    duration: targetScale > currentScale ? 800 : 600
  });
  
  // Animate window bounds
  animateWindowBounds({
    x: newX,
    y: newY,
    width: newWidth,
    height: newHeight
  }, targetScale > currentScale ? 800 : 600);
}

function setFullScreen() {
  const display = screen.getDisplayNearestPoint({
    x: mainWindow.getBounds().x,
    y: mainWindow.getBounds().y
  });
  
  const { width: screenWidth, height: screenHeight } = display.bounds;
  const aspectRatio = baseWidth / baseHeight;
  
  let newWidth, newHeight;
  const screenAspect = screenWidth / screenHeight;
  
  if (screenAspect > aspectRatio) {
    // Screen is wider - fit by height
    newHeight = screenHeight;
    newWidth = Math.round(newHeight * aspectRatio);
  } else {
    // Screen is taller - fit by width
    newWidth = screenWidth;
    newHeight = Math.round(newWidth / aspectRatio);
  }
  
  const targetScale = Math.min(newWidth / baseWidth, newHeight / baseHeight);
  currentScale = targetScale;
  
  const newX = Math.round((screenWidth - newWidth) / 2);
  const newY = Math.round((screenHeight - newHeight) / 2);
  
  mainWindow.webContents.send('scale-animation', {
    scale: targetScale,
    duration: 1000
  });
  
  animateWindowBounds({
    x: display.bounds.x + newX,
    y: display.bounds.y + newY,
    width: newWidth,
    height: newHeight
  }, 1000);
}

function animateWindowBounds(targetBounds, duration) {
  const startBounds = mainWindow.getBounds();
  const startTime = Date.now();
  
  const animate = () => {
    const elapsed = Date.now() - startTime;
    const progress = Math.min(elapsed / duration, 1);
    
    // Easing function for smooth animation
    const eased = progress < 0.5
      ? 2 * progress * progress
      : 1 - Math.pow(-2 * progress + 2, 2) / 2;
    
    const currentBounds = {
      x: Math.round(startBounds.x + (targetBounds.x - startBounds.x) * eased),
      y: Math.round(startBounds.y + (targetBounds.y - startBounds.y) * eased),
      width: Math.round(startBounds.width + (targetBounds.width - startBounds.width) * eased),
      height: Math.round(startBounds.height + (targetBounds.height - startBounds.height) * eased)
    };
    
    mainWindow.setBounds(currentBounds);
    
    if (progress < 1) {
      setTimeout(animate, 16); // ~60fps
    }
  };
  
  animate();
}

// App ready
app.whenReady().then(createWindow);

// All windows closed
app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

// App activated
app.on('activate', () => {
  if (mainWindow === null) {
    createWindow();
  }
});

// Prevent multiple instances
const gotTheLock = app.requestSingleInstanceLock();

if (!gotTheLock) {
  app.quit();
} else {
  app.on('second-instance', () => {
    if (mainWindow) {
      if (mainWindow.isMinimized()) mainWindow.restore();
      mainWindow.focus();
    }
  });
}