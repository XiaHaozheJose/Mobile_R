//
//  SecondViewController.swift
//  Mobile_R
//
//  Created by JS_Coder on 2018/9/20.
//  Copyright © 2018年 JS_Coder. All rights reserved.
//

import Cocoa

class SecondViewController: NSViewController {

    class func loadFromNib() -> SecondViewController{
        let storyBoard = NSStoryboard(name:NSStoryboard.Name(rawValue: "Main"),bundle: nil)
        return storyBoard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "SecondViewController")) as! SecondViewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        showAlert()
    }
   
    @IBAction func closeCurrentController(_ sender: Any) {
        self.dismiss(self)
    }
    
    
    
    
    func showAlert(){
        let alert = NSAlert()
        alert.messageText = "AlertMessage"
        alert.informativeText = "Alert description message"
        alert.addButton(withTitle: "Default")
        alert.addButton(withTitle: "Alernative")
        alert.addButton(withTitle: "Other")
//        let result = alert.runModal()
//        switch result {
//        case .alertFirstButtonReturn :
//            print("first button")
//        case .alertSecondButtonReturn :
//            print("second button")
//        case .alertThirdButtonReturn :
//            print("third button")
//        default:
//            break
//        }
        
        alert.beginSheetModal(for: NSApplication.shared.keyWindow!) { (response) in
            print("select alert button \(response)")
        }
    }
}
