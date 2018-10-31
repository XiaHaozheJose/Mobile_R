//
//  OrdenModel.swift
//  Mobile_R
//
//  Created by JS_Coder on 2018/9/27.
//  Copyright © 2018年 JS_Coder. All rights reserved.
//

import Cocoa

class OrdenModel: NSObject {
    
    @objc var repairType: String = ""
    @objc var registerPerson: String = ""
    @objc var registerTime: String = ""
    @objc var ordenNum: String = ""
    @objc var clientType: String = ""
    @objc var clientName: String = ""
    @objc var clientContactName: String = ""
    @objc var clientContactNum: String = ""
    @objc var clientAddress: String = ""
    @objc var mobileBand: String = ""
    @objc var mobileModel: String = ""
    @objc var mobileIMEI: String = ""
    @objc var mobileSerie: String = ""
    @objc var mobileColor: String = ""
    @objc var mobileProblem: String = ""
    @objc var duration: String = ""
    @objc var isWarraty: String = ""
    @objc var prePayment: String = ""
    @objc var prePrice: String = ""
    @objc var repairPerson: String = ""
    @objc var note: String = ""
    @objc var key: String = ""
    @objc var repairStatus = 0
    @objc var ordenLog: String = ""
    
    init(data: [String: Any]) {
        super.init()
        setValuesForKeys(data)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
