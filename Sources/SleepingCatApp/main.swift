import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    var catWindow: CatWindow!
    
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
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()