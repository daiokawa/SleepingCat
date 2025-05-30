import AppKit

class CatWindow: NSWindow {
    private var catView: CatView!
    
    init() {
        let screenRect = NSScreen.main?.frame ?? NSRect(x: 0, y: 0, width: 800, height: 600)
        let windowWidth: CGFloat = 280
        let windowHeight: CGFloat = 140
        
        let contentRect = NSRect(
            x: (screenRect.width - windowWidth) / 2,
            y: screenRect.height - windowHeight - 50,
            width: windowWidth,
            height: windowHeight
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
    }
}