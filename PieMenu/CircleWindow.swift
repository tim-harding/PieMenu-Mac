import Cocoa

class CircleWindow: NSWindow {
    override var canBecomeKey: Bool {
        return true
    }
    
    override var canBecomeMain: Bool {
        return true
    }
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing bufferingType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: NSWindow.StyleMask.borderless, backing: .buffered, defer: false)
        backgroundColor = NSColor.clear
        isOpaque = false
    }

}
