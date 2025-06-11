import AppKit

// Protocol for menu update notification
protocol MenuUpdateDelegate: AnyObject {
    func updateMenuItems()
}

class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate, MenuUpdateDelegate {
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
        catWindow.menuUpdateDelegate = self
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
        
        // Set menu delegate to update dynamically
        let menu = createMenu()
        menu.delegate = self
        statusItem.menu = menu
        
        // Initial update
        updateMenuItems()
    }
    
    func createMenu() -> NSMenu {
        let menu = NSMenu()
        
        let quitItem = NSMenuItem(title: "終了 / Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "")
        menu.addItem(quitItem)
        
        return menu
    }
    
    func updateMenuItems() {
        // Nothing to update anymore
    }
    
    @objc func makeLarger() {
        catWindow?.makeLarger()
    }
    
    @objc func makeSmaller() {
        catWindow?.makeSmaller()
    }
    
    @objc func setSpecificSize(_ sender: NSMenuItem) {
        guard let scale = sender.representedObject as? CGFloat else { return }
        catWindow?.setScale(scale)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    // NSMenuDelegate - Update menu items when menu is about to be shown
    func menuWillOpen(_ menu: NSMenu) {
        updateMenuItems()
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()