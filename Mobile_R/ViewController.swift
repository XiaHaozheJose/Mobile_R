//
//  ViewController.swift
//  Mobile_R
//
//  Created by JS_Coder on 2018/9/19.
//  Copyright © 2018年 JS_Coder. All rights reserved.
//

import Cocoa
import Alamofire

class ViewController: NSViewController,NSTextFieldDelegate{
    // "dd/MM/yyyy, HH:mm"

    @objc dynamic var ordenModels: [OrdenModel] = []
    
    var allOrdenModels: [OrdenModel] = []
    var newOrdenModels: [OrdenModel] = []
    
    @IBOutlet weak var baseView: NSView!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var searchText: NSSearchField!
    
    
    lazy var registerView: FirstViewController = {
        let v = FirstViewController.loadFromNib()
        v.delegate = self
        return v
    }()
    
    private var isShow: Bool?{
        didSet{
            progress.isHidden = !isShow!
        }
    }
    
    lazy var rightDetailViewController: RightViewController = {
        let vc = RightViewController.loadFromNib()
        vc.view.frame = baseView.bounds
        return vc
    }()
    
    @IBOutlet weak var progress: NSProgressIndicator!
    // MARK: - Cycle Life
    override func viewDidLoad() {
        super.viewDidLoad()
        baseView.addSubview(rightDetailViewController.view)
        getOrdenData()
        getPersonData()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func presentNextPage(_ sender: Any) {
        showAlert()
    }
    
    
    
    // MARK: - TextfieldDelegate
    override func controlTextDidEndEditing(_ obj: Notification) {
        print("Enter")
        newOrdenModels.removeAll()
        if searchText.stringValue.count > 0 {
            for (index, item) in ordenModels.enumerated(){
                if item.ordenNum.contains(searchText.stringValue){
                    newOrdenModels.append(ordenModels[index])
                }
            }
            ordenModels = newOrdenModels
        }
    }
    
    override func controlTextDidChange(_ obj: Notification) {
        if searchText.stringValue.count <= 0 {
            ordenModels = allOrdenModels
        }
    }
    
    @IBAction func searchOrden(_ sender: NSButton) {
        newOrdenModels.removeAll()
        if searchText.stringValue.count > 0 {
            for (index, item) in ordenModels.enumerated(){
                if item.ordenNum.contains(searchText.stringValue){
                    newOrdenModels.append(ordenModels[index])
                }
            }
            ordenModels = newOrdenModels
        }
    }
    
    
    
    
}


// MARK: - Custom Function
extension ViewController{
    private func getOrdenData(){
        progress.startAnimation(self)
        isShow = true
        // 获取Ordens
        Alamofire.request(BaseURL.FireBaseData + API_ORDEN, method: .get).responseJSON { (response) in
            switch response.result{
            case .success(_):
                if let result = response.result.value as? [String: Any]{
                    for (key,value) in result{
                        if var val = value as? [String: Any]{
                            val["key"] = key
                            self.allOrdenModels.append(OrdenModel(data: val))
                        }
                    }
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yyyy, HH:mm"
                    self.allOrdenModels.sort(by: { (m1, m2) -> Bool in
                        dateFormatter.date(from: m1.registerTime)! > dateFormatter.date(from: m2.registerTime)!
                    })
                    self.ordenModels = self.allOrdenModels
                    self.tableView.selectRowIndexes(IndexSet.init(integer:0), byExtendingSelection: true)
                    self.progress.stopAnimation(self)
                    self.isShow = false
                }else{
                    self.progress.stopAnimation(self)
                    self.isShow = false
                }
            case .failure(let error):
                print(error)
                self.progress.stopAnimation(self)
                self.isShow = false
                break
        }
        }
    }
    
    private func getPersonData(){
        if registerPerson.count <= 0 {
            Alamofire.request(BaseURL.FireBaseData + API_PERSON, method: .get).responseJSON { (response) in
                switch response.result{
                case .success(_):
                    if let result = response.result.value as? [String: Any]{
                        for (key,value) in result{
                            if var val = value as? [String: Any]{
                                val["key"] = key
                                registerPerson.append(RegisterPerson(dict: val))
                            }}}
                case .failure(let error):
                    print(error)
                    break
                
        }}}
    }
    
    private func showAlert(){
        let alert = NSAlert()
        alert.alertStyle = .informational
        alert.messageText = "新单🥚"
        alert.informativeText = "确定要创建一个新单吗,你确定吗😄😄"
        alert.addButton(withTitle: "确定✅") // 1000
        alert.addButton(withTitle: "取消❌") // 1001
        alert.addButton(withTitle: "疑问❓") // 1002
        alert.beginSheetModal(for: NSApplication.shared.keyWindow!) { (response) in
            switch response.rawValue {
            case 1000: do{
                self.presentViewControllerAsModalWindow(self.registerView)
                }
            case 1001: do{
                
                }
            case 1002: do{
                
                }
            default:
                return
            }
        }
    }
}

// MARK: - RegisterViewDelegate
extension ViewController: RegisterViewDelegate{
    //上传数据 代理
    func DataIsSubmited(key: String) {
        let url = BaseURL.FireBaseData + "/orden/\(key).json"
        updateOrdenModels(key: key, urlName: url, isGetRequest: true)
    }
    
    private func updateOrdenModels(key: String, urlName: String, isGetRequest: Bool){
        Alamofire.request(urlName, method: .get).responseJSON {(response) in
            switch response.result{
            case .success(_):
                if var result = response.result.value as? [String: Any]{
                    result["key"] = key
                    let model = OrdenModel(data: result)
                    self.ordenModels.append(model)
                    
                }
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    
}

// MARK: - NSTableViewDelegate
extension ViewController: NSTableViewDelegate,NSTableViewDataSource{
    func tableViewSelectionDidChange(_ notification: Notification) {
        if let tableView = notification.object as? NSTableView{
            if tableView.selectedRow == -1{ // 点出界面了
                return
            }else {
              rightDetailViewController.orden = ordenModels[tableView.selectedRow]
            }
        }
    }
    
    
    
    
    
    
}

