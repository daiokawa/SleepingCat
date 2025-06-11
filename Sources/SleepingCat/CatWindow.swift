import AppKit

class CatWindow: NSWindow {
    private var catView: CatView!
    private var currentScale: CGFloat = 1.0
    private let baseWidth: CGFloat = 280
    private let baseHeight: CGFloat = 140
    
    init() {
        let screenRect = NSScreen.main?.frame ?? NSRect(x: 0, y: 0, width: 800, height: 600)
        
        let contentRect = NSRect(
            x: (screenRect.width - baseWidth) / 2,
            y: screenRect.height - baseHeight - 50,
            width: baseWidth,
            height: baseHeight
        )
        
        super.init(
            contentRect: contentRect,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        self.isOpaque = false
        self.backgroundColor = NSColor.clear
        self.level = .floating
        self.collectionBehavior = [.canJoinAllSpaces, .stationary]
        self.isMovableByWindowBackground = true
        self.hasShadow = false
        
        catView = CatView(frame: self.contentView!.bounds)
        catView.autoresizingMask = [.width, .height]
        self.contentView!.addSubview(catView)
        
        // Add right-click menu
        setupContextMenu()
    }
    
    func setupContextMenu() {
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
        
        self.contentView?.menu = menu
    }
    
    @objc func makeLarger() {
        adjustSize(scale: 1.2)
    }
    
    @objc func makeSmaller() {
        adjustSize(scale: 0.8)
    }
    
    func adjustSize(scale: CGFloat) {
        // Limit scale between 0.5 and 3.0
        let newScale = currentScale * scale
        if newScale < 0.5 || newScale > 3.0 {
            return
        }
        
        currentScale = newScale
        
        let newWidth = baseWidth * currentScale
        let newHeight = baseHeight * currentScale
        
        var frame = self.frame
        let centerX = frame.midX
        let centerY = frame.midY
        
        frame.size.width = newWidth
        frame.size.height = newHeight
        frame.origin.x = centerX - newWidth / 2
        frame.origin.y = centerY - newHeight / 2
        
        self.setFrame(frame, display: true, animate: true)
    }
}