//
//  AppDelegate.swift
//  SSH Manager
//
//  Created by Edouard COMTET on 13/06/16.
//  Copyright © 2016 Edouard COMTET. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var data:Data? = nil
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        data = Data.getSingleton()
        data!.save()
    }
    
    @IBAction func hideOrShowDetail(_ sender: AnyObject) {
        Constant.changeShowDetail()
    }
}

