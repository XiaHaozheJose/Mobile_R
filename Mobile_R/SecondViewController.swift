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
        alert.messageText = "新单🥚"
        alert.informativeText = "确定要创建一个新单吗,你确定吗😄😄"
        alert.addButton(withTitle: "确定✅") // 1000
        alert.addButton(withTitle: "取消❌") // 1001
        alert.addButton(withTitle: "疑问❓") // 1002
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
            switch response.rawValue {
            case 1000: do{
                
                }
            case 1001: do{
                self.dismiss(self)
                }
            case 1002: do{
                
                }
            default:
                return
            }
        }
    }
}
