//
//  Common.swift
//  Mobile_R
//
//  Created by JS_Coder on 2018/9/25.
//  Copyright © 2018年 JS_Coder. All rights reserved.
//

import Cocoa

let API_ORDEN = "orden.json"
let API_PERSON = "receivePerson.json"
let NOTIFICATION_STATE = "NOTIFICATION_STATE"
let NOTIFICATION_PROBLEM = "NOTIFICATION_PROBLEM"
let NOTIFICATION_PRICE = "NOTIFICATION_PRICE"
// 登记人员以及维修人员数组(从Firebase 获取)
var registerPerson: [RegisterPerson] = []


struct BaseString {
    static let Band = "band"
    static let Model = "model"
    static let timeCell = "timeCellView"
    static let ordenCell = "ordenCellView"
}

struct BaseURL {
    static let FireBaseData = "https://reparacion-mobile.firebaseio.com/"
}

struct OrdenKeys {
    static let repairType = "repairType"
    static let registerTime = "registerTime"
    static let registerPerson = "registerPerson"
    static let ordenNum = "ordenNum"
    static let clientType = "clientType"
    static let clientName = "clientName"
    static let clientAddress = "clientAddress"
    static let clientContactName = "clientContactName"
    static let clientContactNum = "clientContactNum"
    static let mobileBand = "mobileBand"
    static let mobileModel = "mobileModel"
    static let mobileIMEI = "mobileIMEI"
    static let mobileSerie = "mobileSerie"
    static let mobileColor = "mobileColor"
    static let mobileProblem = "mobileProblem"
    static let duration = "duration"
    static let isWarraty = "isWarraty"
    static let prePayment = "prePayment"
    static let prePrice = "prePrice"
    static let repairPerson = "repairPerson"
    static let note = "note"
    static let repairStatus = "repairStatus"
    static let ordenLog = "ordenLog"
}

