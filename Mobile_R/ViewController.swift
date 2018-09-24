//
//  ViewController.swift
//  Mobile_R
//
//  Created by JS_Coder on 2018/9/19.
//  Copyright © 2018年 JS_Coder. All rights reserved.
//

import Cocoa

class ViewController: NSViewController,NSTableViewDataSource,NSTextFieldDelegate,NSOutlineViewDataSource,NSOutlineViewDelegate {

    var fruits = ["apple", "orange", "banana", "watermelon"]
    
    @IBOutlet weak var textField: NSTextField!
    
    @IBOutlet weak var tableView: NSTableView!
    
    @IBOutlet weak var outLineView: NSOutlineView!
    
    @IBOutlet var treeController: NSTreeController!
    // MARK: - Cycle Life
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        addData()
        outLineView.expandItem(nil, expandChildren: true)
        outLineView.registerForDraggedTypes([NSPasteboard.PasteboardType.string])
    }

    // MARK: - Function
    @IBAction func addFruit(_ sender: Any?) {
        let str = textField.stringValue
        if str.count > 0 {
            fruits.append(str)
            textField.stringValue = ""
            tableView.reloadData()
        }
    }
    
    @IBAction func presentNextPage(_ sender: Any) {
        presentViewControllerAsSheet(SecondViewController.loadFromNib())
    }
    
    
    func addData(){
        let library: [String : Any] = [
            "name": "Library",
            "isLeaf": false
            ]
        let music: [String : Any] = [
            "name": "Music",
            "isLeaf": false
        ]
        
        let dict: NSMutableDictionary = NSMutableDictionary(dictionary: library)
        let p1 = Playlist()
        p1.name = "P1"
        
        let p2 = Playlist()
        p2.name = "P2"
        
        dict.setObject([p1,p2], forKey: "children" as NSCopying)
        
        treeController.addObject(dict)
        treeController.addObject(music)
    }
    
    func isHeader(item: Any) -> Bool{
        if let item = item as? NSTreeNode{
            return !(item.representedObject is Playlist)
        }else {
            return !(item is Playlist)
        }
    }

    func reverse(source: NSTreeNode?, fromIndexPath: IndexPath?){
        treeController.move(source!, to: fromIndexPath!)
        
    }
    
    
    // MARK: - TableViewDataSource, OutlineDataSource
    func numberOfRows(in tableView: NSTableView) -> Int {
        return fruits.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return fruits[row]
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        if isHeader(item: item) {
            return outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HeaderCell"), owner: self)
        }else{
            return outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "DataCell"), owner: self)
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, validateDrop info: NSDraggingInfo, proposedItem item: Any?, proposedChildIndex index: Int) -> NSDragOperation {
        return NSDragOperation.every
    }
    
    func outlineView(_ outlineView: NSOutlineView, pasteboardWriterForItem item: Any) -> NSPasteboardWriting? {
        let pItem = NSPasteboardItem()
        if let playlist = ( item as? NSTreeNode)?.representedObject as? Playlist{
            pItem.setString(playlist.name, forType: NSPasteboard.PasteboardType.string)
            return pItem
        }
        return nil
    }
    
    func outlineView(_ outlineView: NSOutlineView, acceptDrop info: NSDraggingInfo, item: Any?, childIndex index: Int) -> Bool {
        let pb = info.draggingPasteboard()
        let name = pb.string(forType: NSPasteboard.PasteboardType.string)
        
        var sourceNode: NSTreeNode?
        
        if let item = item as? NSTreeNode, item.children != nil {
            for node in item.children! {
                if let playlist = node.representedObject as? Playlist{
                    if playlist.name == name{
                        sourceNode = node
                    }
                }
            }
        }
        if sourceNode == nil{
            return false
        }
        let fromIndexPath = treeController.selectionIndexPath
        let indexArr: [Int] = [0, index]
        let toIndexPath = NSIndexPath(indexes: indexArr, length: 2)
        
        undoManager?.registerUndo(withTarget: self, handler: { (_) in
            self.reverse(source: sourceNode, fromIndexPath: fromIndexPath)
        })
        treeController.move(sourceNode!, to: toIndexPath as IndexPath)
        return true
    }
    
    
    
    // MARK: - TextfieldDelegate, OutlineDelegate
    override func controlTextDidEndEditing(_ obj: Notification) {
        addFruit(nil)
    }
    
   
//    func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
//        return isHeader(item:item)
//    }
//
//    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
//        return !isHeader(item: item)
//    }
//
//    func outlineView(_ outlineView: NSOutlineView, shouldShowOutlineCellForItem item: Any) -> Bool {
//        return !isHeader(item: item)
//    }
    
}

