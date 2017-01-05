//
//  PreferenceController.swift
//  SSH Manager
//
//  Created by Edouard COMTET on 31/08/2016.
//  Copyright © 2016 Edouard COMTET. All rights reserved.
//

import Foundation
import Cocoa

class PreferenceController : NSViewController {
    
    
    @IBOutlet weak var buttonHideOrShowDetail: NSButton!
    @IBOutlet weak var pathSSH: NSPathControl!
    @IBOutlet weak var pathSFTP: NSPathControl!
    
    override func viewDidAppear() {
        if (Constant.isShowDetail()) {
            buttonHideOrShowDetail.state = 1
        }
        else {
            buttonHideOrShowDetail.state = 0
        }
        
        pathSSH.url = URL(fileURLWithPath: Constant.getSSHPath())
        pathSFTP.url = URL(fileURLWithPath: Constant.getSFTPPath())
    }
    
    @IBAction func changeViewOrHideDetail(_ sender: AnyObject) {
        Constant.changeShowDetail()
    }
    
    @IBAction func changeSSHApplication(_ sender: AnyObject) {
        let dialog: NSOpenPanel = NSOpenPanel()
        dialog.canChooseDirectories = false
        dialog.canChooseFiles = true
        dialog.allowsMultipleSelection = false
        dialog.runModal()
        
        let path = dialog.url?.path
        
        if (path != nil) {
            Constant.setSSHPath(path!)
            pathSSH.url = dialog.url
        }
    }
    
    @IBAction func changeSFTPApplication(_ sender: AnyObject) {
        let dialog: NSOpenPanel = NSOpenPanel()
        dialog.canChooseDirectories = false
        dialog.canChooseFiles = true
        dialog.allowsMultipleSelection = false
        dialog.runModal()
        
        let path = dialog.url?.path
        
        if (path != nil) {
            Constant.setSFTPPath(path!)
            pathSSH.url = dialog.url
        }
    }
    
}
