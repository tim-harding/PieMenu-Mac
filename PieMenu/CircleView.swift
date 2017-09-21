import Cocoa

protocol CircleViewDelegate {
    func needsTitles() -> [String]
}

class CircleView: NSView {
    var delegate: CircleViewDelegate?
    
    public var position: Int {
        get {
            return _position
        }
    }
    
    // center, right, top-right, top, ...
    private var _position: Int = 8
    // Degrees
    private var gap = 1.0
    private let innerRadius = CGFloat(32)
    
    func updatePosition() {
        let mouseOrigin = NSEvent.mouseLocation()
        let windowOrigin = window!.frame.origin
        let originOffset = NSPoint(x: mouseOrigin.x - windowOrigin.x - bounds.midX, y: mouseOrigin.y - windowOrigin.y - bounds.midY)
        let distanceToOrigin = pow(pow(originOffset.x, 2) + pow(originOffset.y, 2), 1 / 2)
        
        if distanceToOrigin < innerRadius {
            _position = 8
        } else {
            _position = (Int((atan(originOffset.y / originOffset.x) / CGFloat.pi * 6)) + 8 + (originOffset.x < 0 ? 4 : 0)) % 8
        }
        
        needsDisplay = true
    }
    
    private func darkActive(section: Int) {
        if (section == _position) {
            NSColor.black.withAlphaComponent(0.4).set()
        } else {
            NSColor.black.withAlphaComponent(0.2).set()
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        NSColor.clear.set()
        NSRectFill(frame)
        
        let center = NSPoint(x: bounds.midX, y: bounds.midY)
        for slice in 0..<8 {
            darkActive(section: slice)
            
            let oval = NSBezierPath()
            
            let bisector = Double(slice * 45)
            let angleOffset = 22.5 - gap
            oval.appendArc(
                withCenter: center,
                radius: bounds.midX,
                startAngle: CGFloat(bisector - angleOffset),
                endAngle: CGFloat(bisector + angleOffset)
            )
            
            let innerGap = 22.5 - gap / Double(innerRadius / bounds.midX)
            oval.appendArc(
                withCenter: center,
                radius: innerRadius,
                startAngle: CGFloat(bisector + innerGap),
                endAngle: CGFloat(bisector -  innerGap),
                clockwise: true
            )
            
            oval.fill()
        }
        
        darkActive(section: 8)
        let pad = CGFloat(4)
        let oval = NSBezierPath(ovalIn: NSRect(x: bounds.midX - innerRadius + pad, y: bounds.midY - innerRadius + pad, width: innerRadius * 2 - pad * 2, height: innerRadius * 2 - pad * 2))
        oval.fill()
        
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let text = NSString(string: "Prefs")
        let textFrame = text.boundingRect(with: NSSize(width: 256, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: nil)
        let font = NSFont()
        let fontHeight = findHeight(text: text, widthValue: frame.width, font: font)
        Swift.print(fontHeight)
        
        text.draw(in: textFrame, withAttributes: [
            NSForegroundColorAttributeName: NSColor.white,
            NSParagraphStyleAttributeName: paragraph
        ])
        
        
        window!.hasShadow = false
        window!.display()
    }
    
    private func findHeight(text: NSString, widthValue: CGFloat, font: NSFont) -> CGSize {
        var textFrame = CGSize.zero
        if (text.boolValue) {
            textFrame = text.boundingRect(
                with: CGSize(width: widthValue, height: CGFloat.greatestFiniteMagnitude),
                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                attributes: [NSFontAttributeName: font]
            )
        }
        return CGSize(width: frame.width, height: frame.height + 1)
    }
    
}
