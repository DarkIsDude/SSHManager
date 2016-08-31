//
//  Constant.swift
//  SSH Manager
//
//  Created by Edouard COMTET on 31/08/2016.
//  Copyright © 2016 Edouard COMTET. All rights reserved.
//

import Foundation
import Cocoa

class Constant {
    static let PARAM_HIDE_OR_SHOW_DETAIL = "hideOrShowDetail"
    static let PARAM_APP_SSH = "appSSH"
    static let PARAM_APP_SFTP = "appSFTP"
    
    // Hide Or Show Detail
    static func isShowDetail() -> Bool {
        if NSUserDefaults.standardUserDefaults().boolForKey(Constant.PARAM_HIDE_OR_SHOW_DETAIL) {
            return true
        }
        else {
            return false
        }
    }
    
    static func changeShowDetail() {
        Constant.changeShowDetail(!Constant.isShowDetail())
    }
    
    static func changeShowDetail(value:Bool) {
        NSUserDefaults.standardUserDefaults().setBool(value, forKey: Constant.PARAM_HIDE_OR_SHOW_DETAIL)
        NSNotificationCenter.defaultCenter().postNotificationName(Constant.PARAM_HIDE_OR_SHOW_DETAIL, object: value)
    }
    
    // SSH
    static func getSSHPath() -> String {
        if (NSUserDefaults.standardUserDefaults().stringForKey(Constant.PARAM_APP_SSH) != nil) {
            return NSUserDefaults.standardUserDefaults().stringForKey(Constant.PARAM_APP_SSH)!
        }
        else {
            return "/Applications/iTerm.app";
        }
    }
    
    static func setSSHPath(value:String) {
        NSUserDefaults.standardUserDefaults().setValue(value, forKey: Constant.PARAM_APP_SSH)
    }
    
    // SFTP
    static func getSFTPPath() -> String {
        if (NSUserDefaults.standardUserDefaults().stringForKey(Constant.PARAM_APP_SSH) != nil) {
            return NSUserDefaults.standardUserDefaults().stringForKey(Constant.PARAM_APP_SSH)!
        }
        else {
            return "/Applications/FileZilla.app/Contents/MacOS/filezilla";
        }
    }
    
    static func setSFTPPath(value:String) {
        NSUserDefaults.standardUserDefaults().setValue(value, forKey: Constant.PARAM_APP_SSH)
    }
}
