import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, CircleViewDelegate {
    func needsTitles() -> [String] {
        var titles = [String]()
        if let slices = activePie?.slices {
            for slice in slices {
                titles.append(slice.title)
            }
        }
        return titles
    }

    var pies = [Pie]()
    var activePie: Pie?
    var mouseMonitor: AnyObject? = nil
    var window: CircleWindow?
    var view: CircleView?
    var didShowPie = false

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        pies.append(Pie(
//            key: HotKey(key: .f1, modifiers: []),
            boundApplication: URL(fileURLWithPath: "/Applications/Spotify.app"),
            slices: [
                (title: "First", command: "Documents/temp/hide.py"),
                (title: "Second", command: ""),
                (title: "Third", command: ""),
                (title: "Hello", command: ""),
                (title: "Hi", command: ""),
                (title: "Howdy", command: ""),
                (title: "Things", command: ""),
                (title: "Stuff", command: "")
            ]
        ))
        
        pies.append(Pie(
//            key: HotKey(key: .a, modifiers: [.command, .shift]),
            boundApplication: nil,
            slices: [
                (title: "One", command: ""),
                (title: "Two", command: ""),
                (title: "Three", command: ""),
                (title: "Four", command: ""),
                (title: "Five", command: ""),
                (title: "Six", command: ""),
                (title: "Seven", command: ""),
                (title: "Eight", command: "")
            ]
        ))
        
        window = NSApplication.shared.windows.last as? CircleWindow
        window?.close()
        view = window?.contentViewController?.view as? CircleView
        view?.delegate = self
        
//        for pie in pies {
//            pie.key?.keyDownHandler = {
//                guard pie.boundApplication == nil || pie.boundApplication?.standardizedFileURL == NSWorkspace.shared.frontmostApplication?.bundleURL?.standardizedFileURL else {
//                    self.didShowPie = false
//                    return
//                }
//                self.didShowPie = true
//                self.activePie = pie
//
//                self.mouseMonitor = NSEvent.addGlobalMonitorForEvents(matching: NSEvent.EventTypeMask.mouseMoved, handler: {event in
//                    self.view?.updatePosition()
//                }) as AnyObject
//
//                let position = NSEvent.mouseLocation
//                self.window?.setFrameOrigin(NSPoint(x: position.x - 128.0, y: position.y - 128.0))
//                self.window?.makeKeyAndOrderFront(self)
//                self.window?.level = NSWindow.Level.floating
//                self.view?.needsDisplay = true
//            }
//
//            pie.key?.keyUpHandler = {
//                guard self.didShowPie else { return }
//
//                NSEvent.removeMonitor(self.mouseMonitor as Any)
//                self.mouseMonitor = nil
//                self.window?.close()
//
//                let position = self.view!.position
//                if position < pie.slices.count {
////                    self.runProgram(binary: "/Users/tim/anaconda/bin/python3", args: [pie.slices[position].command])
//                    self.performShortcut(keycodes: [0x8, 0x4]) // Cmd-h
//                }
//            }
//        }
    }
    
    func runProgram(binary: String, args: [String]) {
        let task = Process()
        task.launchPath = binary
        task.currentDirectoryPath = "~"
        task.arguments = args
        task.launch()
    }
    
    func performShortcut(keycodes: [Int]) {
        let source = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)
        let location = CGEventTapLocation.cghidEventTap
        
        for keycode in keycodes {
            let down = CGEvent(keyboardEventSource: source, virtualKey: CGKeyCode(keycode), keyDown: true)
            down?.flags = CGEventFlags.maskCommand
            down?.post(tap: location)
        }
        
        for keycode in keycodes {
            let up = CGEvent(keyboardEventSource: source, virtualKey: CGKeyCode(keycode), keyDown: false)
            up?.post(tap: location)
        }
    }

}

