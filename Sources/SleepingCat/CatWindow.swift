import AppKit

class CatWindow: NSWindow {
    private var catView: CatView!
    var currentScale: CGFloat = 1.0
    weak var menuUpdateDelegate: MenuUpdateDelegate?
    
    // Base dimensions (after trimming top margin)
    private let baseWidth: CGFloat = 280
    private let baseHeight: CGFloat = 115
    
    // Scale limits
    private let minScale: CGFloat = 0.3
    private let maxScale: CGFloat = 3.0
    
    init() {
        let screenRect = NSScreen.main?.frame ?? NSRect(x: 0, y: 0, width: 800, height: 600)
        
        // Initial position: top center of screen
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
        
        setupWindow()
        setupCatView()
        setupContextMenu()
    }
    
    private func setupWindow() {
        self.isOpaque = false
        self.backgroundColor = NSColor.clear
        self.level = .floating
        self.collectionBehavior = [.canJoinAllSpaces, .stationary]
        self.isMovableByWindowBackground = true
        self.hasShadow = false
    }
    
    private func setupCatView() {
        catView = CatView(frame: self.contentView!.bounds)
        catView.autoresizingMask = [.width, .height]
        self.contentView!.addSubview(catView)
    }
    
    private func setupContextMenu() {
        updateContextMenu()
    }
    
    func updateContextMenu() {
        let menu = NSMenu()
        
        // Size submenu
        let sizeItem = NSMenuItem(title: "サイズ / Size", action: nil, keyEquivalent: "")
        let sizeMenu = NSMenu()
        
        // Size options with percentage
        let sizes: [(String, CGFloat)] = [
            ("極小 / Tiny (30%)", 0.3),
            ("小 / Small (50%)", 0.5),
            ("標準 / Standard (100%)", 1.0),
            ("大 / Large (150%)", 1.5),
            ("特大 / Extra Large (200%)", 2.0),
            ("最大 / Maximum (300%)", 3.0),
            ("フルスクリーン / Full Screen", -1.0)  // Special value for fullscreen
        ]
        
        for (title, scale) in sizes {
            let item = NSMenuItem(title: title, action: #selector(setSpecificSize(_:)), keyEquivalent: "")
            item.target = self
            item.representedObject = scale
            // Add checkmark for current size
            item.state = abs(scale - currentScale) < 0.1 ? .on : .off
            sizeMenu.addItem(item)
        }
        
        sizeItem.submenu = sizeMenu
        menu.addItem(sizeItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Quit menu item
        let quitItem = NSMenuItem(
            title: "終了 / Quit",
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: ""
        )
        menu.addItem(quitItem)
        
        self.contentView?.menu = menu
    }
    
    @objc func makeLarger() {
        performScale(1.2)
    }
    
    @objc func makeSmaller() {
        performScale(0.8)
    }
    
    func setScale(_ targetScale: CGFloat) {
        if targetScale == -1.0 {
            // Full screen mode
            setFullScreen()
        } else {
            // Calculate the scale factor needed to reach target scale
            let scaleFactor = targetScale / currentScale
            performScale(scaleFactor)
        }
    }
    
    @objc func setSpecificSize(_ sender: NSMenuItem) {
        guard let scale = sender.representedObject as? CGFloat else { return }
        setScale(scale)
    }
    
    private func canMakeLarger() -> Bool {
        return currentScale * 1.2 <= maxScale
    }
    
    private func canMakeSmaller() -> Bool {
        return currentScale * 0.8 >= minScale
    }
    
    private func performScale(_ scaleFactor: CGFloat) {
        let newScale = currentScale * scaleFactor
        
        // Check limits
        guard newScale >= minScale && newScale <= maxScale else { return }
        
        // Get current frame center
        let currentFrame = self.frame
        let centerX = currentFrame.midX
        let centerY = currentFrame.midY
        
        // Calculate new dimensions
        let newWidth = baseWidth * newScale
        let newHeight = baseHeight * newScale
        
        // Calculate new frame keeping center point
        var newFrame = NSRect(
            x: centerX - newWidth / 2,
            y: centerY - newHeight / 2,
            width: newWidth,
            height: newHeight
        )
        
        // Ensure window stays on screen
        newFrame = constrainToScreen(newFrame)
        
        // Update scale
        currentScale = newScale
        
        // Animate with bounce effect
        animateWithBounce(to: newFrame, scaleFactor: scaleFactor)
    }
    
    private func constrainToScreen(_ frame: NSRect) -> NSRect {
        // Get the screen where the window currently is
        let currentScreen = self.screen ?? NSScreen.main ?? NSScreen.screens[0]
        
        var constrainedFrame = frame
        let screenFrame = currentScreen.visibleFrame
        
        // Keep window on the same screen
        if constrainedFrame.minX < screenFrame.minX {
            constrainedFrame.origin.x = screenFrame.minX
        }
        if constrainedFrame.maxX > screenFrame.maxX {
            constrainedFrame.origin.x = screenFrame.maxX - constrainedFrame.width
        }
        if constrainedFrame.minY < screenFrame.minY {
            constrainedFrame.origin.y = screenFrame.minY
        }
        if constrainedFrame.maxY > screenFrame.maxY {
            constrainedFrame.origin.y = screenFrame.maxY - constrainedFrame.height
        }
        
        return constrainedFrame
    }
    
    private func animateWithBounce(to targetFrame: NSRect, scaleFactor: CGFloat) {
        let isGrowing = scaleFactor > 1.0
        
        if isGrowing {
            // Growing: slow breathing-like expansion
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.8  // Much slower
                context.timingFunction = CAMediaTimingFunction(
                    controlPoints: 0.2, 0.8, 0.3, 1.05  // Gentle ease with tiny overshoot
                )
                self.animator().setFrame(targetFrame, display: true)
            }, completionHandler: {
                self.updateContextMenu()
                self.menuUpdateDelegate?.updateMenuItems()
            })
        } else {
            // Shrinking: slow deflation
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.6
                context.timingFunction = CAMediaTimingFunction(
                    controlPoints: 0.1, 0.25, 0.25, 1  // Faster start, then smooth
                )
                self.animator().setFrame(targetFrame, display: true)
            }, completionHandler: {
                self.updateContextMenu()
                self.menuUpdateDelegate?.updateMenuItems()
            })
        }
    }
    
    private func setFullScreen() {
        guard let screen = self.screen ?? NSScreen.main else { return }
        
        let screenFrame = screen.frame
        let aspectRatio = baseWidth / baseHeight
        
        // Calculate size to fit screen while maintaining aspect ratio
        let screenAspect = screenFrame.width / screenFrame.height
        let newWidth: CGFloat
        let newHeight: CGFloat
        
        if screenAspect > aspectRatio {
            // Screen is wider - fit by height
            newHeight = screenFrame.height
            newWidth = newHeight * aspectRatio
        } else {
            // Screen is taller - fit by width
            newWidth = screenFrame.width
            newHeight = newWidth / aspectRatio
        }
        
        // Calculate scale needed
        let scaleByWidth = newWidth / baseWidth
        let scaleByHeight = newHeight / baseHeight
        let targetScale = min(scaleByWidth, scaleByHeight)
        
        // Update current scale
        currentScale = targetScale
        
        // Center on screen
        let newFrame = NSRect(
            x: screenFrame.midX - newWidth / 2,
            y: screenFrame.midY - newHeight / 2,
            width: newWidth,
            height: newHeight
        )
        
        // Animate to fullscreen
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 1.0
            context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            self.animator().setFrame(newFrame, display: true)
        }, completionHandler: {
            self.updateContextMenu()
            self.menuUpdateDelegate?.updateMenuItems()
        })
    }
}