//
//  EditStateController.swift
//  Mobile_R
//
//  Created by JS_Coder on 10/10/18.
//  Copyright © 2018 JS_Coder. All rights reserved.
//

import Cocoa
import Alamofire
class EditStateController: NSViewController {
    
    
    
    @IBOutlet weak var states: NSComboBox!
    @IBOutlet weak var persons: NSComboBox!
    @IBOutlet weak var opratorPerson: NSComboBox!
    // 单号模型
    var orden: OrdenModel?{
        didSet{
            currentState = orden?.repairStatus
            currentPerson = orden?.repairPerson
        }
    }
    let stateValues = ["维修中", "维修完成", "其他问题"]
    
    // 当前状态码
    var currentState: Int?{
        didSet{
            if currentState! == 0 {
                states.selectItem(at: 0)
            }else if currentState! == 1{
                states.selectItem(at: 1)
            }else{
                states.selectItem(at: 2)
            }
        }
    }
    
    //当前维修人员
    var currentPerson: String?{
        didSet{
            for (index, item) in registerPerson.enumerated(){
                if currentPerson! == item.name{
                    persons.selectItem(at: index)
                }
            }
        }
    }
    
    // 回调函数
    var changedValues: ((_ changedValue: [String: Any])->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        getData()
    }
    // 获取数据
    private func getData(){
        if registerPerson.count <= 0 {
            Alamofire.request(BaseURL.FireBaseData + API_PERSON, method: .get).responseJSON { (response) in
                switch response.result{
                case .success(_):
                    if let result = response.result.value as? [String: Any]{
                        for (key,value) in result{
                            if var val = value as? [String: Any]{
                                val["key"] = key
                                registerPerson.append(RegisterPerson(dict: val))
                            }
                        }
                        self.addItemToComboBox()
                    }
                case .failure(let error):
                    print(error)
                    break
                }}
        }else{
            addItemToComboBox()
        }
        states.addItems(withObjectValues: stateValues)
        states.selectItem(at: 0)
    }
    
    //初始化数据
    private func addItemToComboBox(){
        for person in registerPerson{
            persons.addItem(withObjectValue: person.name)
            opratorPerson.addItem(withObjectValue: person.name)
        }
        persons.selectItem(at: 0)
    }
    // 保存修改
    @IBAction func aceptedToSave(_ sender: NSButton) {
        if opratorPerson.stringValue.count <= 0 {
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
        var status = 0
        if states.stringValue == stateValues[0]{ status = 0 }
        else if states.stringValue == stateValues[1] {status = 1}
        else {status = -1}
        changedValues?([OrdenKeys.repairStatus: status, OrdenKeys.repairPerson: persons.stringValue,
                        "operator": opratorPerson.stringValue])
        }
    }
}
