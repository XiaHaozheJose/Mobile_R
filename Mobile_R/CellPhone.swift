//
//  CellPhone.swift
//  Mobile_R
//
//  Created by JS_Coder on 2018/9/26.
//  Copyright © 2018年 JS_Coder. All rights reserved.
//

import Cocoa

class CellPhone: NSObject {
    @objc var model: [String] = []
    @objc var band: String = ""
    
     init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

