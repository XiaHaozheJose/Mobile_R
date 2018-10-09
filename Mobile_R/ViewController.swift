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
    
    @objc dynamic var ordenModels: [OrdenModel] = []
    
    lazy var registerView: FirstViewController = {
        let v = FirstViewController.loadFromNib()
        v.delegate = self
        return v
    }()
    // MARK: - Cycle Life
    override func viewDidLoad() {
        super.viewDidLoad()
        getOrdenData()
        // Do any additional setup after loading the view.
    }
    
    func generateBarcode(from string: String) -> CIImage? {
        let data = string.data(using: String.Encoding.ascii)
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue(NSNumber(integerLiteral: 5), forKey: "inputQuietSpace")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            if let output = filter.outputImage?.transformed(by: transform) {
                return output
            }
        }
        return nil
    }
    
    @IBAction func presentNextPage(_ sender: Any) {
        showAlert()
    }
    
    
    
    // MARK: - TextfieldDelegate
    override func controlTextDidEndEditing(_ obj: Notification) {
        
    }
    
    
}


// MARK: - Custom Function
extension ViewController{
    private func getOrdenData(){
        Alamofire.request(BaseURL.FireBaseData + API_ORDEN, method: .get).responseJSON { (response) in
            switch response.result{
            case .success(_):
                if let result = response.result.value as? [String: Any]{
                    for (key,value) in result{
                        if var val = value as? [String: Any]{
                            val["key"] = key
                            self.ordenModels.append(OrdenModel(data: val))
                        }
                    }
                }
            case .failure(let error):
                print(error)
                break
            }
        }
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
        Alamofire.request(urlName, method: .get).responseJSON { (response) in
            switch response.result{
            case .success(_):
                if var result = response.result.value as? [String: Any]{
                    result["key"] = key
                    self.ordenModels.append(OrdenModel(data: result))
                }
            case .failure(let error):
                print(error)
                break
            }
        }
    }
}

// MARK: - NSTableViewDelegate
extension ViewController: NSTableViewDelegate{
    func tableView(_ tableView: NSTableView, didClick tableColumn: NSTableColumn) {
        print(tableColumn)
    }
    
    
    
    
}

