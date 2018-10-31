//
//  EditPriceController.swift
//  Mobile_R
//
//  Created by JS_Coder on 10/10/18.
//  Copyright © 2018 JS_Coder. All rights reserved.
//

import Cocoa

class EditPriceController: NSViewController {

    @IBOutlet weak var operatorPerson: NSComboBox!
    @IBOutlet weak var priceTextField: NSTextField!
    var price: String?{
        didSet{
            priceTextField.stringValue = price!
        }
    }
    var changedValues: (([String: Any]?)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        addItemToComboBox()
    }
    
    //初始化数据
    private func addItemToComboBox(){
        if registerPerson.count > 0 {
            for person in registerPerson{
                operatorPerson.addItem(withObjectValue: person.name)
            }
        }
    }
    
    @IBAction func aceptedToSave(_ sender: NSButton) {
        if operatorPerson.stringValue.count <= 0 {
            let alert = NSAlert()
            alert.alertStyle = .warning
            alert.messageText = "缺少操作员"
            alert.beginSheetModal(for: NSApp.keyWindow!) { (response) in
                switch response.rawValue{
                case 0:
                    return
                default:
                    return
                }
            }
        }else{
        if price != nil, priceTextField.stringValue != price!{
            changedValues?([OrdenKeys.prePrice: priceTextField.stringValue,
                            "operator": operatorPerson.stringValue])
        }else{
            changedValues?(nil)
        }
        }
    }
}
