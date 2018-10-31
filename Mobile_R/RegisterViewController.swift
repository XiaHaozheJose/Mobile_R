//
//  RegisterViewController.swift
//  Mobile_R
//
//  Created by JS_Coder on 10/30/18.
//  Copyright © 2018 JS_Coder. All rights reserved.
//

import Cocoa
import Alamofire
class RegisterViewController: NSViewController {

    
    class func loadFromNib() -> RegisterViewController{
        let storyBoard = NSStoryboard(name:NSStoryboard.Name(rawValue: "Main"),bundle: nil)
        return storyBoard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "RegisterViewController")) as! RegisterViewController
    }
    
    @IBOutlet weak var nameText: NSTextField!
    @IBOutlet weak var emailText: NSTextField!
    @IBOutlet weak var phoneText: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    
    @IBAction func beginToRegister(_ sender: NSButton) {
        if nameText.stringValue.count > 0 , emailText.stringValue.count > 0 , phoneText.stringValue.count > 0 {
            // 网络请求
            do{
            let params = ["name": nameText.stringValue,
                          "email": emailText.stringValue,
                          "phone": phoneText.stringValue]
            let data = try JSONSerialization.data(withJSONObject: params, options: [])
            var request = URLRequest(url: URL(string:"https://reparacion-mobile.firebaseio.com/receivePerson.json")!)
            request.httpMethod = "POST"
            request.httpBody = data
            
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let json = data, let dic = self.dataToDic(data: json){
                    let key = dic["name"] as! String
                    
                    Alamofire.request("https://reparacion-mobile.firebaseio.com/receivePerson/\(key).json", method: .get).responseJSON(completionHandler: { (response) in
                        if var result = response.result.value as? [String: Any]{
                            result["key"] = key
                            registerPerson.append(RegisterPerson(dict: result))
                        }
                        NSApplication.shared.keyWindow?.close()
                    })
                    
                }
                }.resume()
            
        } catch let err {
            print(err)
            NSApplication.shared.keyWindow?.close()

        }
        }else{
            NSApplication.shared.keyWindow?.close()
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
