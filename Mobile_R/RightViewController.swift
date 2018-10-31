//
//  RightViewController.swift
//  Mobile_R
//
//  Created by JS_Coder on 2018/9/21.
//  Copyright © 2018年 JS_Coder. All rights reserved.
//

import Cocoa
import Alamofire
class RightViewController: NSViewController {
// \n 跳行
    
    class func loadFromNib() -> RightViewController{
        let storyBoard = NSStoryboard(name:NSStoryboard.Name(rawValue: "Main"),bundle: nil)
        return storyBoard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "RightViewController")) as! RightViewController
    }
    
    var orden: OrdenModel?{
        didSet{
            setData()
        }
    }
    
    var statusLevel: Double = -1{
        didSet{
            if statusLevel == 0{
                repairLevel.criticalValue = 2
                repairStatus.stringValue = "维修中💪"
            }else if statusLevel == 1{
                repairLevel.criticalValue = 4
                repairStatus.stringValue = "维修完成✅"
            }else{
                repairLevel.criticalValue = 0
                repairStatus.stringValue = "未知状态❌"
            }
        }
    }
    
    lazy var popover: NSPopover = {
        let p = NSPopover()
        p.behavior = .transient
        return p
    }()
    
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
    @IBOutlet weak var noteTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    private func setData(){
        if let model = orden{
            ordenNumber.stringValue = model.ordenNum
            clientName.stringValue = model.clientName
            clientAddres.stringValue = model.clientAddress
            clientPhone.stringValue = model.clientContactNum
            cellPhoneBand.stringValue = model.mobileBand
            cellPhoneModel.stringValue = model.mobileModel
            cellPhoneIMEI.stringValue = model.mobileIMEI
            cellPhoneProblem.stringValue = model.mobileProblem
            repairPerson.stringValue = model.repairPerson
            price.stringValue = model.prePrice + "€"
            noteTextField.stringValue = model.note
            statusLevel = Double(model.repairStatus)
            gestionLog.stringValue = model.ordenLog
        }
    }
}

// MARK: - Event
extension RightViewController{
    
    // 编辑维修状态 和 维修人员
    @IBAction func editStateAndRepairPerson(_ sender: NSButton) {
        let vc = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "EditStateController")) as! EditStateController
        popover.contentViewController = vc
        popover.show(relativeTo: sender.bounds, of: sender, preferredEdge: .minX)
        vc.orden = orden
        vc.changedValues = {[weak self](values: [String: Any]) in
            
            if self?.orden?.repairStatus == (values[OrdenKeys.repairStatus] as! Int) , self?.orden?.repairPerson == (values[OrdenKeys.repairPerson] as! String) {self?.popover.close(); print("same values")}
            let newStatus = values[OrdenKeys.repairStatus] as! Int
            let newPerson = values[OrdenKeys.repairPerson] as! String
            let currentOperator = values["operator"] as! String
            self?.orden?.repairStatus = newStatus
            self?.orden?.repairPerson = newPerson
            self?.statusLevel = Double(values[OrdenKeys.repairStatus] as! Int)
            
            self?.orden?.ordenLog = (self?.appendOrdenLog(currentLog: (self?.gestionLog.stringValue ?? ""), currentOperator: currentOperator)) ?? "未知错误"
            self?.updateOrden()
            self?.popover.close()
        }
    }
    
    // 编辑故障问题
    @IBAction func editCellphoneProblem(_ sender: NSButton) {
        let vc = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "EditProblemController")) as! EditProblemController
        popover.contentViewController = vc
        popover.show(relativeTo: sender.bounds, of: sender, preferredEdge: .minX)
        vc.problem = orden?.mobileProblem
        vc.changedValues = {[weak self](values) in
            let currentOperator = values?["operator"] as! String
            if let valor = values?[OrdenKeys.mobileProblem] as? String {
                self?.orden?.mobileProblem = valor
                self?.cellPhoneProblem.stringValue = valor
                self?.orden?.ordenLog = (self?.appendOrdenProblemLog(currentLog: (self?.gestionLog.stringValue ?? ""), currentOperator: currentOperator)) ?? "未知错误"
                self?.updateOrden()
            }
            self?.popover.close()
        }
    }
    
    // 编辑 报价
    @IBAction func editRepairPrice(_ sender: NSButton) {
        let vc = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "EditPriceController")) as! EditPriceController
        popover.contentViewController = vc
        popover.show(relativeTo: sender.bounds, of: sender, preferredEdge: .minX)
        vc.price = orden?.prePrice
        vc.changedValues = {[weak self] (values) in
            let currentOperator = values?["operator"] as! String
            if let valor = values?[OrdenKeys.prePrice] as? String {
                self?.price.stringValue = valor + "€"
                self?.orden?.prePrice = valor
                self?.orden?.ordenLog = (self?.appendOrdenPriceLog(currentLog: (self?.gestionLog.stringValue ?? ""), currentOperator: currentOperator)) ?? "未知错误"
                self?.updateOrden()
            }
            self?.popover.close()
        }
    }
    
    // 打印单子
    @IBAction func printOrder(_ sender: NSButton) {
        let printView = PrintViewController.loadFromNib()
        printView.ordenModels.append(orden!)
        self.presentViewControllerAsModalWindow(printView)
        
    }
    
    private func updateOrden(){
        guard let key = orden?.key, let orden = orden else {return}
        let params = [OrdenKeys.repairType: orden.repairType,
                      OrdenKeys.registerPerson: orden.registerPerson,
                      OrdenKeys.registerTime: orden.registerTime,
                      OrdenKeys.ordenNum: orden.ordenNum,
                      OrdenKeys.clientType: orden.clientType,
                      OrdenKeys.clientName: orden.clientName,
                      OrdenKeys.clientAddress: orden.clientAddress,
                      OrdenKeys.clientContactName: orden.clientContactName,
                      OrdenKeys.clientContactNum: orden.clientContactNum,
                      OrdenKeys.mobileBand: orden.mobileBand,
                      OrdenKeys.mobileModel: orden.mobileModel,
                      OrdenKeys.mobileIMEI: orden.mobileIMEI,
                      OrdenKeys.mobileSerie: orden.mobileSerie,
                      OrdenKeys.mobileColor: orden.mobileColor,
                      OrdenKeys.mobileProblem: orden.mobileProblem,
                      OrdenKeys.duration: orden.duration,
                      OrdenKeys.isWarraty: orden.isWarraty,
                      OrdenKeys.prePayment: orden.prePayment,
                      OrdenKeys.prePrice: orden.prePrice,
                      OrdenKeys.repairPerson: orden.repairPerson,
                      OrdenKeys.note: orden.note,
                      OrdenKeys.repairStatus: orden.repairStatus,
                      OrdenKeys.ordenLog: orden.ordenLog] as [String : Any]
        let url = BaseURL.FireBaseData + "orden/" + key + ".json"
        networkingWithPut(params: params, url: url)
    }
    
    //添加状态Log
    private func appendOrdenLog(currentLog: String, currentOperator: String)-> String{
        var log = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy, HH:mm"
        let currentTime = dateFormatter.string(from: Date())
        if currentLog.count > 0 {
            log = "\(currentOperator): " + "修改了状态为[" + repairStatus.stringValue + "] , 修改了技术员为[" + repairPerson.stringValue + "]- \(currentTime)" + "\n" + currentLog
        }else{
            log = "\(currentOperator): " + "修改了状态为[" + repairStatus.stringValue + "] , 修改了技术员为[" + repairPerson.stringValue + "] - \(currentTime)."
        }
        return log
    }
    
    //添加问题Log
    private func appendOrdenProblemLog(currentLog: String, currentOperator: String)-> String{
        var log = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy, HH:mm"
        let currentTime = dateFormatter.string(from: Date())
        if currentLog.count > 0 {
            log = "\(currentOperator): " + "修改了故障为[" + cellPhoneProblem.stringValue + "] - \(currentTime)" + "\n" + currentLog
        }else{
            log = "\(currentOperator): " + "修改了故障为[" + cellPhoneProblem.stringValue + "] - \(currentTime)."
        }
        return log
    }
    
    private func appendOrdenPriceLog(currentLog: String, currentOperator: String)-> String{
        var log = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy, HH:mm"
        let currentTime = dateFormatter.string(from: Date())
        if currentLog.count > 0 {
            log = "\(currentOperator): " + "修改了报价为[" + price.stringValue + "] - \(currentTime)" + "\n" + currentLog
        }else{
            log = "\(currentOperator): " + "修改了报价为[" + price.stringValue + "€] - \(currentTime)."
        }
        return log
    }
    
    func networkingWithPut(params: [String: Any], url: String){
        do {
            // 网络请求
            let data = try JSONSerialization.data(withJSONObject: params, options: [])
            var request = URLRequest(url: URL(string:url)!)
            request.httpMethod = "PUT"
            request.httpBody = data
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let json = data, let _ = self.dataToDic(data: json){
                    DispatchQueue.main.async {
                       self.setData()
                        self.dismiss(self)
                    }
                }
                }.resume()
        } catch let err {
            print(err)
        }
    }
    // data 转 字典
    private func dataToDic(data: Data) -> [String: Any]?{
        do {
            guard let dic = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {return nil}
            return dic
        } catch _ {
            return nil
        }
    }
    
}
