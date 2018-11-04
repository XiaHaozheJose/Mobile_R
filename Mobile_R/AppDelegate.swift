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
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let popover = NSPopover()
    var eventMonitor: EventMonitor?
    let containerController = RegisterViewController.loadFromNib()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        

        // Insert code here to initialize your application
        if let button = statusItem.button {
            button.title = "注册用户"
            button.action = #selector(showWeather(sender:))
        }
        eventMonitor = EventMonitor(mask: [.leftMouseUp, .rightMouseUp], handler: { (event) in
            if self.popover.isShown{
                self.closePopover(sender: nil)
            }
        })
        
        
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        
    }
    
    
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
        popover.contentViewController = containerController
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
}

