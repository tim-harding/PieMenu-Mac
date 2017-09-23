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

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        pies.append(Pie(
            key: HotKey(key: .a, modifiers: [.command, .option, .control]),
            slices: [
                (title: "First", command: "osascript -e 'tell app \"System Events\" to display dialog \"Hello World\"'"),
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
            key: HotKey(key: .a, modifiers: [.command, .shift]),
            slices: [
                (title: "One", command: "osascript -e 'tell app \"System Events\" to display dialog \"Hi\"'"),
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
        
        for pie in pies {
            pie.key?.keyDownHandler = {
                self.activePie = pie
                
                self.mouseMonitor = NSEvent.addLocalMonitorForEvents(matching: NSEvent.EventTypeMask.mouseMoved, handler: {event in
                    self.view?.updatePosition()
                    return event
                }) as AnyObject
                
                let position = NSEvent.mouseLocation
                self.window?.setFrameOrigin(NSPoint(x: position.x - 128.0, y: position.y - 128.0))
                self.window?.makeKeyAndOrderFront(self)
                NSApp.activate(ignoringOtherApps: true)
            }
            
            pie.key?.keyUpHandler = {
                NSEvent.removeMonitor(self.mouseMonitor as Any)
                self.mouseMonitor = nil
                self.window?.close()
                NSApp.hide(self)
                
                let position = self.view!.position
                if position < pie.slices.count {
                    self.run(command: pie.slices[position].command)
                }
            }
        }
    }
    
    func run(command: String) {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = ["/usr/local/bin/node", "~/Documents/permanent/scripts/say_hello.js"]
        task.launch()
    }

}

