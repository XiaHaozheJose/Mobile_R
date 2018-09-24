//
//  LeftViewController.swift
//  Mobile_R
//
//  Created by JS_Coder on 2018/9/21.
//  Copyright © 2018年 JS_Coder. All rights reserved.
//

import Cocoa

class LeftViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func click(_ sender: NSButton) {
        let vc = FirstViewController.loadFromNib()
        let popover = NSPopover()
        popover.behavior = .transient
        popover.contentViewController = vc
        popover.show(relativeTo: sender.bounds, of: sender, preferredEdge: .maxX)
    }
}
