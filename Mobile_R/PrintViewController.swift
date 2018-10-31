//
//  PrintViewController.swift
//  Mobile_R
//
//  Created by JS_Coder on 10/30/18.
//  Copyright © 2018 JS_Coder. All rights reserved.
//

import Cocoa

class PrintViewController: NSViewController {

    
    class func loadFromNib() -> PrintViewController{
        let storyBoard = NSStoryboard(name:NSStoryboard.Name(rawValue: "Main"),bundle: nil)
        return storyBoard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "PrintViewController")) as! PrintViewController
    }
    
   @objc dynamic var ordenModels: [OrdenModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    
    func printPage(){
        configPrintAtt()
    }
    
    // 打印设置
    private func configPrintAtt(){
        var printInfo = NSPrintInfo.shared
        let shareDic = printInfo.dictionary()
        let printDic = NSMutableDictionary(dictionary: shareDic)
        printDic.setObject(Date(), forKey: NSPrintInfo.AttributeKey.time as NSCopying)
        printInfo.topMargin = 10
        printInfo.leftMargin = 10
        printInfo.rightMargin = 10
        printInfo.bottomMargin = 10
        printInfo.horizontalPagination = .fitPagination
        printInfo.verticalPagination = .fitPagination
        printInfo.isVerticallyCentered = false
        printInfo = NSPrintInfo(dictionary: printDic as! [NSPrintInfo.AttributeKey : Any])
        let printOP = NSPrintOperation(view: self.view, printInfo: printInfo)
        printOP.printPanel.options = [.showsOrientation, .showsPaperSize, .showsPreview, .showsPageSetupAccessory, .showsScaling, .showsPrintSelection]
        printOP.run()
    }
}
