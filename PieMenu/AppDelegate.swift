import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var pies = [Pie]()
    var key = HotKey(key: .a, modifiers: [.command, .option, .control])
    var mouseMonitor: AnyObject? = nil
    var window: CircleWindow?
    var view: CircleView?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        pies.append(Pie(
            key: HotKey(key: .a, modifiers: [.command, .option, .control]),
            slices: [
                (title: "First", command: "osascript -e 'tell app \"System Events\" to display dialog \"Hello World\""),
                (title: "Second", command: ""),
                (title: "Third", command: "")
            ]
        ))
        
        
        window = NSApplication.shared().windows.last as? CircleWindow
        window?.close()
        view = window?.contentViewController?.view as? CircleView
        
        key.keyDownHandler = {
            self.mouseMonitor = NSEvent.addLocalMonitorForEvents(matching: .mouseMoved, handler: {event in
                self.view?.updatePosition()
                return event
            }) as AnyObject
            
            let position = NSEvent.mouseLocation()
            self.window?.setFrameOrigin(NSPoint(x: position.x - 128.0, y: position.y - 128.0))
            self.window?.makeKeyAndOrderFront(self)
            NSApp.activate(ignoringOtherApps: true)
        }
        
        key.keyUpHandler = {
            NSEvent.removeMonitor(self.mouseMonitor as Any)
            self.mouseMonitor = nil
            self.window?.close()
            NSApp.hide(self)
        }
    }

}

