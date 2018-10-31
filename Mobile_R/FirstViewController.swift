//
//  FirstViewController.swift
//  Mobile_R
//
//  Created by JS_Coder on 2018/9/19.
//  Copyright © 2018年 JS_Coder. All rights reserved.
//

import Cocoa
import Alamofire

protocol RegisterViewDelegate {
    func DataIsSubmited(key: String)
}

class FirstViewController: NSViewController,NSWindowDelegate {
    
    // MARK: - 属性/变量
    // 单号数据库本地文件地址
    private var ordenFilePath: String?
    
    var delegate: RegisterViewDelegate?
    // 客户类型数组
    private let clientTypeData: [String] = ["店家", "散客"]
    // 手机型号以及牌子 model
    private var cellPhones: [CellPhone] = []
    // 手机颜色
    private let phoneColors: [String] = ["Blanco", "Negro", "Dorado", "Plata", "Gris", "Rosa", "Rojo", "Otros"]
    // 保修
    private let warrantyArray: [String] = ["Si", "No"]
    // 时限
    private let timeLimit: [String] = ["1", "2", "3", "4"]
    // MARK: - Element 控件
    /**
     * Element UI
     **/
    @IBOutlet weak var repairTypes: NSComboBox!         //维修类型
    @IBOutlet weak var registerDate: NSDatePicker!      // 登记时间
    @IBOutlet weak var registroPerson: NSComboBox!      //登记人员
    @IBOutlet weak var registroNum: NSTextField!        //单号
    @IBOutlet weak var clientTypes: NSComboBox!         //客户类型
    @IBOutlet weak var clientName: NSTextField!         //客户名称
    @IBOutlet weak var clientContact: NSTextField!      //联系人
    @IBOutlet weak var clientPhone: NSSearchField!      //联系电话
    @IBOutlet weak var clientAddress: NSTextField!      //客户地址
    @IBOutlet weak var cellPhoneBands: NSComboBox!      //手机牌子
    @IBOutlet weak var cellPhoneModels: NSComboBox!     //手机型号
    @IBOutlet weak var cellPhoneIMEI: NSTextField!      //手机IMEI
    @IBOutlet weak var cellPhoneSerie: NSTextField!     //手机序列号
    @IBOutlet weak var isWarranty: NSComboBox!          //是否保修
    @IBOutlet weak var cellPhoneColors: NSComboBox!     //手机颜色
    @IBOutlet weak var cellPhoneProblem: NSTextField!   //问题
    @IBOutlet weak var repairTimeLimit: NSComboBox!     //维修时限
    @IBOutlet weak var prePayment: NSTextField!         //预付款
    @IBOutlet weak var forecastPrice: NSTextField!      //预收款
    @IBOutlet weak var repairPersons: NSComboBox!       //维修人员
    @IBOutlet weak var moreInfo: NSTextField!           //更多信息
    @IBOutlet weak var buttonRegistro: NSButton!        //登记
    @IBOutlet weak var buttonCancel: NSButton!          //取消
    
    // MARK: - Load ViewController from Nib
    class func loadFromNib() -> FirstViewController{
        let storyBoard = NSStoryboard(name:NSStoryboard.Name(rawValue: "Main"),bundle: nil)
        return storyBoard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "FirstViewController")) as! FirstViewController
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "登记表,没做适配别把我拉长"
        setData()
        
    }
    
    func windowWillClose(_ notification: Notification) {
        NSApp.stopModal()
        //        notification.object
    }
}

// MARK: - Config
extension FirstViewController{
    // MARK: - 从网络获取数据
    // 初始数据
    func setData(){
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
                    self.ordenFilePath = self.getOrdenFilePathWithShabox()
                    // Set Bands
                    _ = self.getCellPhoneFromPlist()
                    self.cleanAllDataToInitial()
                }
            case .failure(let error):
                print(error)
                break
            }}
        }else{
            ordenFilePath = getOrdenFilePathWithShabox()
            // Set Bands
            _ = getCellPhoneFromPlist()
            cleanAllDataToInitial()
        }
    }
    
    // 上传数据到firebase
    private func submitDataToFireBase(){
        
        let rType = repairTypes.stringValue
        let rTime = registerDate.stringValue
        let rPerson = registroPerson.stringValue
        let rOrden = registroNum.stringValue
        let cType = clientTypes.stringValue
        let cName = clientName.stringValue
        let cAddress = clientAddress.stringValue
        let cContactName = clientContact.stringValue
        let cNum = clientPhone.stringValue
        let mBand = cellPhoneBands.stringValue
        let mModel = cellPhoneModels.stringValue
        let mIMEI = cellPhoneIMEI.stringValue
        let mSerie = cellPhoneSerie.stringValue
        let mColor = cellPhoneColors.stringValue
        let mProblem = cellPhoneProblem.stringValue
        let warranty = isWarranty.stringValue
        let duration = repairTimeLimit.stringValue
        var rPrePayment = prePayment.stringValue
        var rForecastPrice = forecastPrice.stringValue
        let moreNote = moreInfo.stringValue
        let personRepair = repairPersons.stringValue
        
        // 验证重要信息
        if cName.count <= 0 {
            alertWithText(text: "客户名称不能为空")
            return
        }else if cNum.count <= 0 {
            alertWithText(text: "联系电话不能为空")
            return
        }else if mProblem.count <= 0 {
            alertWithText(text: "故障问题不能为空")
            return
        }else if rPrePayment.count <= 0 {
            rPrePayment = "0"
        }else if rForecastPrice.count <= 0 {
            rForecastPrice = "0"
        }
        // 表格信息
        let params = [OrdenKeys.repairType: rType,
                      OrdenKeys.registerPerson: rPerson,
                      OrdenKeys.registerTime: rTime,
                      OrdenKeys.ordenNum: rOrden,
                      OrdenKeys.clientType: cType,
                      OrdenKeys.clientName: cName,
                      OrdenKeys.clientAddress: cAddress,
                      OrdenKeys.clientContactName: cContactName,
                      OrdenKeys.clientContactNum: cNum,
                      OrdenKeys.mobileBand: mBand,
                      OrdenKeys.mobileModel: mModel,
                      OrdenKeys.mobileIMEI: mIMEI,
                      OrdenKeys.mobileSerie: mSerie,
                      OrdenKeys.mobileColor: mColor,
                      OrdenKeys.mobileProblem: mProblem,
                      OrdenKeys.duration: duration,
                      OrdenKeys.isWarraty: warranty,
                      OrdenKeys.prePayment: rPrePayment,
                      OrdenKeys.prePrice: rForecastPrice,
                      OrdenKeys.repairPerson: personRepair,
                      OrdenKeys.note: moreNote,
                      OrdenKeys.repairStatus: 0] as [String : Any]
        do {
            // 网络请求
            let data = try JSONSerialization.data(withJSONObject: params, options: [])
            var request = URLRequest(url: URL(string:BaseURL.FireBaseData + API_ORDEN)!)
            request.httpMethod = "POST"
            request.httpBody = data
            
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let json = data, let dic = self.dataToDic(data: json){
                    self.delegate?.DataIsSubmited(key:dic["name"] as! String)
                    DispatchQueue.main.async {
                        self.saveLocalData()
                    }
                }
                }.resume()
            
        } catch let err {
            print(err)
        }
    }
    
    // 提醒错误 缺省信息
    private func alertWithText(text: String){
        let alert = NSAlert()
        alert.addButton(withTitle: "知道了")
        alert.messageText = "缺少信息"
        alert.informativeText = text
        alert.beginSheetModal(for: NSApplication.shared.keyWindow!, completionHandler: nil)
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
    
    
    // MARK: - 从Plist获取手机信息
    func getCellPhoneFromPlist()->Bool{
        guard let path = Bundle.main.path(forResource: "Cellphone.plist", ofType: nil) else {return false}
        guard let arr = NSMutableArray(contentsOfFile: path) else {return false}
        for item in arr{
            if let data = item as? [String: Any]{
                cellPhones.append(CellPhone(dict: data))
            }
        }
        return true
    }
    
    
    // MARK: - 初始化数据
    private func cleanAllDataToInitial(){
        // 送修方式
        repairTypes.removeAllItems()
        repairTypes.isEditable = false
        addItemsForComboBox(element: repairTypes, items: ["用户送修", "用户返修"])
        
        // 登记人员 && 维修人员
        registroPerson.removeAllItems()
        repairPersons.removeAllItems()
        registroPerson.isEditable = false
        repairPersons.isEditable = false
        for model in registerPerson {
            addItemsForComboBox(element: registroPerson, items: [model.name])
            addItemsForComboBox(element: repairPersons, items: [model.name])
        }
        
        //计算当前时间
        getCurrentDate()
        
        // 计算当前单号
        let orden = getOrdenListData(filePath: ordenFilePath!)
        registroNum.stringValue = orden
        
        // 客户类型
        clientTypes.removeAllItems()
        clientTypes.isEditable = false
        addItemsForComboBox(element: clientTypes, items: clientTypeData)
        
        // 手机牌子 && 手机型号
        cellPhoneBands.removeAllItems()
        cellPhoneBands.isEditable = false
        
        cellPhoneModels.removeAllItems()
        cellPhoneModels.isEditable = false
        addCellPhoneBand()
        
        // 是否是保修
        isWarranty.removeAllItems()
        isWarranty.isEditable = false
        addItemsForComboBox(element: isWarranty, items: warrantyArray)
        
        // 手机颜色
        cellPhoneColors.removeAllItems()
        cellPhoneColors.isEditable = false
        addItemsForComboBox(element: cellPhoneColors, items: phoneColors)
        
        // 维修时间
        repairTimeLimit.removeAllItems()
        repairTimeLimit.isEditable = false
        repairTimeLimit.addItems(withObjectValues: timeLimit)
    }
    
    // 清除填写数据
    private func clearAllElementData(){
        clientName.stringValue = ""
        clientPhone.stringValue = ""
        clientContact.stringValue = ""
        clientAddress.stringValue = ""
        cellPhoneIMEI.stringValue = ""
        cellPhoneSerie.stringValue = ""
        cellPhoneProblem.stringValue = ""
        prePayment.stringValue = ""
        forecastPrice.stringValue = ""
        moreInfo.stringValue = ""
    }
    
    // 添加初始数据
    private func addItemsForComboBox(element: NSComboBox, items: [Any]){
        element.addItems(withObjectValues: items)
        element.selectItem(at: 0)
    }
    
    // 添加初始品牌
    private func addCellPhoneBand(){
        for phone in self.cellPhones{
            self.cellPhoneBands.addItem(withObjectValue: phone.band)
        }
        self.cellPhoneBands.selectItem(at: 0)
    }
    
    // MARK: - 获取本地持久化数据 (单号处理)
    private func getOrdenFilePathWithShabox()->String{
        let fileManager = FileManager.default
        if let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first{
            let ordenPlist = (documentDir as AnyObject).appendingPathComponent("OrdenList.plist") as String
            
            // 判断如果不存在
            if fileManager.fileExists(atPath: ordenPlist) != true{
                if let mainPath = Bundle.main.path(forResource: "OrdenList.plist", ofType: nil){
                    do {
                        let _ = try fileManager.copyItem(atPath: mainPath, toPath: ordenPlist)
                        print("拷贝成功")
                    }catch {
                        print("无法拷贝数据")
                    }
                }
            }
            print("数据文件已存在")
            //             清理
            //                        let arr = NSMutableArray(contentsOfFile: ordenPlist)
            //                        for item in arr!{
            //                            arr?.remove(item)
            //                        }
            //                        arr?.write(toFile: ordenPlist, atomically: true)
            return ordenPlist
        }
        return ""
    }
    
    // 写入单号(需要在点击打印之后)
    private func addOrdenNumber(orden: String){
        guard let path = ordenFilePath else { print("地址错误或为空"); return}
        let preResult = NSMutableArray(contentsOfFile: path)
        preResult?.add(orden)
        preResult?.write(toFile: path, atomically: true)
    }
    
    /// 计算单号
    ///
    /// - Parameter filePath: 单号保存本地地址
    /// - Returns: 当前计算所得单号
    private func getOrdenListData(filePath: String)->String{
        if let arr = NSArray(contentsOfFile: filePath){
            return ("\(getCurrentDateWithString())0\(arr.count)")
        }else{
            return ""
        }
    }
    
    // 计算当前时间
    private func getCurrentDate(){
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "dd/MM/yyyy, HH:mm"
        registerDate.formatter = timeFormatter
        registerDate.dateValue = Date()
    }
    
    // 当前时间字符串
    private func getCurrentDateWithString()->String{
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "ddMMyyyy"
        let date = Date()
        return timeFormatter.string(from: date)
    }
}

// MARK: - Event
extension FirstViewController: NSComboBoxDelegate{
    
    // 取消
    @IBAction func cancelRegistro(_ sender: NSButton) {
        let alert = NSAlert()
        alert.alertStyle = .warning
        alert.addButton(withTitle: "确定")
        alert.addButton(withTitle: "继续编辑")
        alert.messageText = "关闭表单"
        alert.informativeText = "确认关闭表单吗...你没手贱❓"
        alert.beginSheetModal(for: NSApplication.shared.keyWindow!) { (response) in
            if response.rawValue == 1000 {
                self.dismiss(self)
            }else{
                print("????")
            }
        }
    }
    
    // 确定登记
    @IBAction func aceptedRegistro(_ sender: NSButton) {
        // 上传数据
        submitDataToFireBase()
    }
    
    // 监听ComBox
    func comboBoxSelectionDidChange(_ notification: Notification) {
        if let box = notification.object as? NSComboBox{
            cleanCellPhoneModels()
            let index = box.indexOfItem(withObjectValue: box.objectValueOfSelectedItem ?? 0)
            if index >= 9999 || index <= -1 {return}
            cellPhoneModels.addItems(withObjectValues: cellPhones[index].model)
            cellPhoneModels.selectItem(at: 0)
        }
    }
    
    //  清除之前记录
    private func cleanCellPhoneModels(){
        cellPhoneModels.removeAllItems()
    }
    
    private func saveLocalData(){
        // 本地存储单号
        addOrdenNumber(orden: registroNum.stringValue)
        registroNum.stringValue = getOrdenListData(filePath: ordenFilePath!)
        clearAllElementData()
        dismissViewController(self)
    }
    
    // 打印设置
    private func configPrintAtt(){
        var printInfo = NSPrintInfo.shared
        let shareDic = printInfo.dictionary()
        let printDic = NSMutableDictionary(dictionary: shareDic)
        printDic.setObject(Date(), forKey: NSPrintInfo.AttributeKey.time as NSCopying)
        printInfo.topMargin = 0
        printInfo.leftMargin = 0
        printInfo.rightMargin = 0
        printInfo.bottomMargin = 0
        printInfo.horizontalPagination = .fitPagination
        printInfo.verticalPagination = .fitPagination
        printInfo.isVerticallyCentered = false
        printInfo = NSPrintInfo(dictionary: printDic as! [NSPrintInfo.AttributeKey : Any])
        
        let printOP = NSPrintOperation(view: self.view, printInfo: printInfo)
        printOP.printPanel.options = [.showsOrientation, .showsPaperSize, .showsPreview, .showsPageSetupAccessory, .showsScaling, .showsPrintSelection]
        printOP.run()
    }
}
