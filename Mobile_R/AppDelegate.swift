//
//  AppDelegate.swift
//  Mobile_R
//
//  Created by JS_Coder on 2018/9/19.
//  Copyright © 2018年 JS_Coder. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
  
    func applicationDidFinishLaunching(_ aNotification: Notification) {
      
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        
    }
    
    
}



/*
 let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
 let popover = NSPopover()
 var eventMonitor: EventMonitor?
 
 // Insert code here to initialize your application
 if let button = statusItem.button {
 button.title = "夏浩哲"
 button.action = #selector(showWeather(sender:))
 }
 //        menu.addItem(withTitle: "Open", action: #selector(openView), keyEquivalent: "O")
 //        menu.addItem(NSMenuItem.separator())
 //        menu.addItem(withTitle: "Close", action: #selector(closeView), keyEquivalent: "Q")
 //        statusItem.menu = menu
 popover.contentViewController = registerView
 eventMonitor = EventMonitor(mask: [.leftMouseUp, .rightMouseUp], handler: { (event) in
 if self.popover.isShown{
 self.closePopover(sender: nil)
 }
 })
 func closePopover(sender: AnyObject?) {
 popover.performClose(sender)
 eventMonitor?.stop()
 }
 
 func showPopover(sender: AnyObject?) {
 if let button = statusItem.button {
 popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
 eventMonitor?.start()
 }
 
 }
 
 @objc func showWeather(sender: NSStatusBarButton) {
 print("ShowMe")
 if popover.isShown {
 closePopover(sender: sender)
 } else {
 showPopover(sender: sender)
 }
 }
 
 @objc func openView(){
 print("Open")
 
 }
 
 @objc func closeView(){
 
 }
 
 */
