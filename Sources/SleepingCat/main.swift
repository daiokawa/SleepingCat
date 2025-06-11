import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    var catWindow: CatWindow!
    var statusItem: NSStatusItem!
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        // Prevent multiple instances
        if !flag {
            catWindow?.makeKeyAndOrderFront(nil)
        }
        return true
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Check if already running
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = runningApps.filter { 
            $0.bundleIdentifier == Bundle.main.bundleIdentifier && $0 != NSRunningApplication.current 
        }.count > 0
        
        if isRunning {
            NSApp.terminate(nil)
            return
        }
        
        catWindow = CatWindow()
        catWindow.makeKeyAndOrderFront(nil)
        
        NSApp.setActivationPolicy(.accessory)
        
        // Create status bar item
        setupStatusBarItem()
    }
    
    func setupStatusBarItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            button.title = "🐱"
        }
        
        let menu = NSMenu()
        
        let largerItem = NSMenuItem(title: "大きくする", action: #selector(makeLarger), keyEquivalent: "")
        largerItem.target = self
        menu.addItem(largerItem)
        
        let smallerItem = NSMenuItem(title: "小さくする", action: #selector(makeSmaller), keyEquivalent: "")
        smallerItem.target = self
        menu.addItem(smallerItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let quitItem = NSMenuItem(title: "終了", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        menu.addItem(quitItem)
        
        statusItem.menu = menu
    }
    
    @objc func makeLarger() {
        catWindow?.adjustSize(scale: 1.2)
    }
    
    @objc func makeSmaller() {
        catWindow?.adjustSize(scale: 0.8)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()