//
//  Playlist.swift
//  Mobile_R
//
//  Created by JS_Coder on 2018/9/20.
//  Copyright © 2018年 JS_Coder. All rights reserved.
//

import Cocoa
class Playlist: NSObject {
    @objc dynamic var name: String = "New Playlist"
    @objc dynamic var creator: String = "User"
    @objc dynamic var isLeaf: Bool{
        get{
             return true
        }
    }
    
}
