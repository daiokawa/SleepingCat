# Changelog

## [1.2.0] - 2025-06-11

### Added
- Direct size selection from right-click menu (30%, 50%, 100%, 150%, 200%, 300%)
- Fullscreen mode that maintains aspect ratio
- Organic growth/shrink animations with life-like breathing effects
- Multi-display support - cat stays on current screen when resizing
- Support for extreme sizes: 極小/Tiny (30%) and フルスクリーン/Full Screen

### Changed
- Simplified menu structure - removed keyboard shortcuts and menu bar size controls
- Menu bar now only shows quit option for cleaner interface
- Right-click menu now primary interface for all size controls
- Smoother, slower animations (0.8s grow, 0.6s shrink)
- Improved animation timing curves for more natural movement
- Removed excessive transparent area at top of cat video (cropped 130px)

### Fixed
- Cat no longer gets cut off when scaling up
- Position drift when shrinking eliminated with center-based scaling
- Window jumping between screens on multi-display setups
- Animation delay on shrink operations

### Technical
- Complete code refactoring for cleaner architecture
- Removed unnecessary development files (Python scripts, HTML viewers)
- Optimized video with top margin cropping using ffmpeg

## [1.1.0] - 2025-06-11

### Added
- Menu bar icon (🐱) for easy access to controls
- Right-click context menu on the cat window
- Resize functionality with 20% increment/decrement
- Menu items now gray out when size limits are reached (0.5x - 3.0x)
- Better Japanese localization for menu items

### Changed
- Improved menu integration with dynamic state updates
- Enhanced user experience with visual feedback for size limits

### Fixed
- Menu items now properly reflect the current size state

## [1.0.0] - 2025-06-10

### Initial Release
- Adorable sleeping cat animation
- Transparent background
- Draggable window
- Lightweight resource usage
- Works on all spaces/desktops
- Available for both macOS and Windows