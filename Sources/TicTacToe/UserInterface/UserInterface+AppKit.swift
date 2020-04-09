//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2020-04-09.
//

import SwiftUI

#if os(OSX)
import Foundation
import AppKit

public extension UserInterface {
    static func show<V>(view: V) where V: SwiftUI.View {
        let nshosting = NSHostingView(rootView: view)
        let app = createApp(view: nshosting) { app_ in
            print("window closed")
            app_.terminate(nil)
        }
        app.run()
    }
}

//var timer: Timer?
private func createApp(
    view: NSView,
    _ windowClosedHandler: @escaping (NSApplication) -> Void
) -> NSApplication {
    let app = createApp()
    
    window(contentView: view) {
        windowClosedHandler(app)
    }
    
    app.finishLaunching()
    
//    timer = Timer(timeInterval: 0.001, repeats: true) { [app] _ in
//        if let event = app.nextEvent(matching: .any, until: nil, inMode: .default, dequeue: true) {
//            app.sendEvent(event)
//        }
//    }
    
    return app
}

private func window(
    contentView: NSView,
    _ windowClosedHandler: @escaping () -> Void
) {
    
    let size = NSScreen.main!.frame.size.height / 2
    
    let window = NSWindow(
        contentRect: NSRect(x: 50, y: 50, width: size, height: size),
        styleMask: [.closable, .titled, .resizable, .miniaturizable],
        backing: .buffered,
        defer: true
    )
    
    let windowDelegate = WindowDelegate { windowWillCloseNotification in
        let _ = windowWillCloseNotification
        windowClosedHandler()
    }
    window.delegate = windowDelegate
    window.acceptsMouseMovedEvents = true
    window.orderFrontRegardless()
    window.contentView = contentView
}

private func createApp() -> NSApplication {
    let app = NSApplication.shared
    let appDelegate = AppDelegate()
    app.delegate = appDelegate
    app.setActivationPolicy(.regular)
    return app
}

private class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        print("📺 should have presented window")
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        print("📺 applicationWillTerminate")
    }
}

typealias WindowWillCloseListener = (Notification) -> Void
private class WindowDelegate: NSObject, NSWindowDelegate {
    private let windowWillCloseListener: WindowWillCloseListener
    init(windowWillCloseListener: @escaping WindowWillCloseListener) {
        self.windowWillCloseListener = windowWillCloseListener
    }
    
    func windowDidResize(_ notification: Notification) {
        // very verbose!
        //        print("resize window")
    }
    
    func windowWillClose(_ notification: Notification) {
        windowWillCloseListener(notification)
    }
}


#endif
