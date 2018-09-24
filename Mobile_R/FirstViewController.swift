//
//  FirstViewController.swift
//  Mobile_R
//
//  Created by JS_Coder on 2018/9/19.
//  Copyright © 2018年 JS_Coder. All rights reserved.
//

import Cocoa

class FirstViewController: NSViewController {

    
    
    @IBOutlet weak var repairTypes: NSComboBoxCell!
    @IBOutlet weak var registerDate: NSDatePicker!
    @IBOutlet weak var registroPerson: NSComboBox!
    @IBOutlet weak var registroNum: NSTextField!
    @IBOutlet weak var clientTypes: NSComboBox!
    @IBOutlet weak var clientName: NSTextField!
    @IBOutlet weak var clientContact: NSTextField!
    @IBOutlet weak var clientPhone: NSSearchField!
    @IBOutlet weak var clientAddress: NSTextField!
    @IBOutlet weak var cellPhoneBands: NSComboBox!
    @IBOutlet weak var cellPhoneModels: NSComboBox!
    @IBOutlet weak var cellPhoneIMEI: NSTextField!
    @IBOutlet weak var cellPhoneSerie: NSTextField!
    @IBOutlet weak var isWarranty: NSComboBox!
    @IBOutlet weak var cellPhoneColors: NSComboBox!
    @IBOutlet weak var cellPhoneProblem: NSTextField!
    @IBOutlet weak var repairTimeLimit: NSComboBox!
    @IBOutlet weak var prePayment: NSTextField!
    @IBOutlet weak var forecastPrice: NSTextField!
    @IBOutlet weak var repairPersons: NSComboBox!
    @IBOutlet weak var moreInfo: NSTextField!
    @IBOutlet weak var buttonRegistro: NSButton!
    @IBOutlet weak var buttonCancel: NSButton!
    
    
    class func loadFromNib() -> FirstViewController{
        let storyBoard = NSStoryboard(name:NSStoryboard.Name(rawValue: "Main"),bundle: nil)
        return storyBoard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "FirstViewController")) as! FirstViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        
    }
   
    
}


// MARK: - Config
extension FirstViewController{
    func setData(){
        cleanAllDataToInitial()
    }
    
    private func cleanAllDataToInitial(){
        repairTypes.removeAllItems()
        addItemsForComboBox(element: repairTypes, items: ["用户送修", "用户返修"])
        registroPerson.removeAllItems()
        clientTypes.removeAllItems()
        cellPhoneBands.removeAllItems()
        cellPhoneModels.removeAllItems()
        isWarranty.removeAllItems()
        cellPhoneColors.removeAllItems()
        repairPersons.removeAllItems()
        repairTimeLimit.removeAllItems()
    }
    
    private func addItemsForComboBox(element: NSComboBoxCell, items: [Any]){
        element.addItems(withObjectValues: items)
        element.selectItem(at: 0)
    }
}


// MARK: - Event
extension FirstViewController{
    @IBAction func printRegistro(_ sender: NSButton) {
    }
}
