//
//  RightViewController.swift
//  Mobile_R
//
//  Created by JS_Coder on 2018/9/21.
//  Copyright © 2018年 JS_Coder. All rights reserved.
//

import Cocoa

class RightViewController: NSViewController {
// \n 跳行
    
    // MARK: - 属性
    @IBOutlet weak var ordenNumber: NSTextField! //订单号
    @IBOutlet weak var clientName: NSTextField!  //客户名
    @IBOutlet weak var clientAddres: NSTextField! //客户地址
    @IBOutlet weak var clientPhone: NSTextField! //客户电话
    @IBOutlet weak var cellPhoneBand: NSTextField! //手机牌子
    @IBOutlet weak var cellPhoneModel: NSTextField! //手机型号
    @IBOutlet weak var cellPhoneIMEI: NSTextField! //IMEI
    @IBOutlet weak var repairLevel: NSLevelIndicator! //
    @IBOutlet weak var repairPerson: NSTextField!
    @IBOutlet weak var repairStatus: NSTextField!
    @IBOutlet weak var cellPhoneProblem: NSTextField!
    @IBOutlet weak var price: NSTextField!
    @IBOutlet weak var gestionLog: NSTextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
    }
}


// MARK: - Event
extension RightViewController{
    
    @IBAction func editStateAndRepairPerson(_ sender: NSButton) {
        
    }
    
    @IBAction func editCellphoneProblem(_ sender: NSButton) {
        
    }
    
    @IBAction func editRepairPrice(_ sender: NSButton) {
        
    }
    
    @IBAction func printOrder(_ sender: NSButton) {
    
    }
    
}
