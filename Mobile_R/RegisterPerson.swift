//
//  RegisterPerson.swift
//  Mobile_R
//
//  Created by JS_Coder on 2018/9/25.
//  Copyright © 2018年 JS_Coder. All rights reserved.
//

import Cocoa

class RegisterPerson: NSObject {

    @objc var name: String = ""
    @objc var email: String = ""
    @objc var phone: String = ""
    @objc var key: String = ""
    
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
//        print(key)
//        print(value)
    }
}
