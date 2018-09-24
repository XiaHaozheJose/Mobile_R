//
//  EventMonitor.swift
//  Mobile_R
//
//  Created by JS_Coder on 2018/9/19.
//  Copyright © 2018年 JS_Coder. All rights reserved.
//

import Cocoa

class EventMonitor {
    
    private var monitor: Any?
    private var mask: NSEvent.EventTypeMask
    private var handler: (NSEvent?) -> ()
    
    init(mask: NSEvent.EventTypeMask,handler: @escaping (NSEvent?) -> ()) {
        self.handler = handler
        self.mask = mask
    }
    
    deinit {
        stop()
    }
    
    func start(){
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler)
    }
    
    func stop(){
        if monitor != nil{
            NSEvent.removeMonitor(monitor!)
            monitor = nil
        }
    }
}
