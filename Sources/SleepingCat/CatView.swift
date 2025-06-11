import AppKit
import AVFoundation
import Vision
import CoreImage

class CatView: NSView {
    private var playerLayer: AVPlayerLayer!
    private var player: AVPlayer!
    private var maskLayer: CALayer!
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupVideoPlayer()
        detectCatAndCreateMask()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func detectCatAndCreateMask() {
        // Extract frame for cat detection
        let frameImage = NSImage(contentsOfFile: "/Users/KoichiOkawa/Downloads/cat_frame.png")
        
        if let cgImage = frameImage?.cgImage(forProposedRect: nil, context: nil, hints: nil) {
            // Use Vision to detect cat
            let request = VNRecognizeAnimalsRequest { [weak self] request, error in
                if let results = request.results as? [VNRecognizedObjectObservation] {
                    for observation in results {
                        if observation.labels.first?.identifier == "Cat" {
                            print("Cat detected at: \(observation.boundingBox)")
                            // Create mask based on detection
                            self?.createMaskFromBounds(observation.boundingBox)
                        }
                    }
                }
            }
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            try? handler.perform([request])
        }
    }
    
    private func createMaskFromBounds(_ bounds: CGRect) {
        // Create a mask layer for the detected cat area
        maskLayer = CALayer()
        maskLayer.backgroundColor = NSColor.white.cgColor
        
        // Convert normalized bounds to view coordinates
        let viewBounds = self.bounds
        let catRect = CGRect(
            x: bounds.origin.x * viewBounds.width,
            y: bounds.origin.y * viewBounds.height,
            width: bounds.width * viewBounds.width,
            height: bounds.height * viewBounds.height
        )
        
        maskLayer.frame = catRect
        maskLayer.cornerRadius = 20
    }
    
    private func setupVideoPlayer() {
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.clear.cgColor
        
        // Use bundled video from app resources
        let videoURL: URL
        if let bundlePath = Bundle.main.path(forResource: "cat_video", ofType: "mov") {
            videoURL = URL(fileURLWithPath: bundlePath)
        } else {
            // Fallback for development - use trimmed version
            let videoPath = "/Users/KoichiOkawa/Desktop/SleepingCat/Resources/cat_trimmed_top.mov"
            videoURL = URL(fileURLWithPath: videoPath)
        }
        
        let playerItem = AVPlayerItem(url: videoURL)
        player = AVPlayer(playerItem: playerItem)
        
        // Create a container layer for masking
        let containerLayer = CALayer()
        containerLayer.frame = self.bounds
        containerLayer.backgroundColor = NSColor.clear.cgColor
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.bounds
        playerLayer.videoGravity = .resizeAspect
        playerLayer.backgroundColor = NSColor.clear.cgColor
        
        // Apply composition for selective transparency
        let compositionLayer = CALayer()
        compositionLayer.frame = self.bounds
        compositionLayer.addSublayer(playerLayer)
        
        // Add composition filter for background removal
        if #available(macOS 10.14, *) {
            let filter = CIFilter(name: "CISourceOverCompositing")
            compositionLayer.compositingFilter = filter
            compositionLayer.backgroundFilters = [
                CIFilter(name: "CIColorControls", parameters: [
                    "inputSaturation": 0,
                    "inputBrightness": 0.3,
                    "inputContrast": 2.0
                ])!
            ]
        }
        
        self.layer?.addSublayer(compositionLayer)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerItemDidReachEnd),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )
        
        player.play()
    }
    
    @objc private func playerItemDidReachEnd(notification: Notification) {
        player.seek(to: .zero)
        player.play()
    }
    
    override func layout() {
        super.layout()
        playerLayer?.frame = self.bounds
        maskLayer?.frame = self.bounds
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}