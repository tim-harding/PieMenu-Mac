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
        let mouseOrigin = NSEvent.mouseLocation
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
        frame.fill()
        
        let strings: [String]
        if let delegate = delegate {
            strings = delegate.needsTitles()
        } else {
            strings = [String](repeating: "", count: 8)
        }
        
        let center = NSPoint(x: bounds.midX, y: bounds.midY)
        for slice in 0..<8 {
            darkActive(section: slice)
            
            let shape = NSBezierPath()
            
            let bisector = Double(slice * 45)
            let angleOffset = 22.5 - gap
            shape.appendArc(
                withCenter: center,
                radius: bounds.midX,
                startAngle: CGFloat(bisector - angleOffset),
                endAngle: CGFloat(bisector + angleOffset)
            )
            
            let innerGap = 22.5 - gap / Double(innerRadius / bounds.midX)
            shape.appendArc(
                withCenter: center,
                radius: innerRadius,
                startAngle: CGFloat(bisector + innerGap),
                endAngle: CGFloat(bisector -  innerGap),
                clockwise: true
            )
            
            shape.fill()
            
            let x = CGFloat(sin(Double(slice * -1 + 2) * Double.pi / 4) * 90 + 128)
            let y = CGFloat(cos(Double(slice * -1 + 2) * Double.pi / 4) * 90 + 128)
            
            let string = slice < strings.count ? strings[slice] : ""
            drawText(string: string, x: x, y: y)
        }
        
        darkActive(section: 8)
        let pad = CGFloat(4)
        let shape = NSBezierPath(ovalIn: NSRect(x: bounds.midX - innerRadius + pad, y: bounds.midY - innerRadius + pad, width: innerRadius * 2 - pad * 2, height: innerRadius * 2 - pad * 2))
        shape.fill()
        
        drawText(string: "Prefs", x: center.x, y: center.y)
        
        window!.hasShadow = false
        window!.display()
    }
    
    func drawText(string: String, x: CGFloat, y: CGFloat) {
        let attributes = [
            NSAttributedStringKey.font: NSFont.boldSystemFont(ofSize: 12),
            NSAttributedStringKey.foregroundColor: NSColor.white
        ]

        let text = NSString(string: string)
        let size = text.size(withAttributes: attributes)
        let textOrigin = NSPoint(x: x - size.width / 2, y: y - size.height / 2)
        text.draw(at: textOrigin, withAttributes: attributes)
    }
    
}
