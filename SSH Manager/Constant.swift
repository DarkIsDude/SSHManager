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
        if UserDefaults.standard.bool(forKey: Constant.PARAM_HIDE_OR_SHOW_DETAIL) {
            return true
        }
        else {
            return false
        }
    }
    
    static func changeShowDetail() {
        Constant.changeShowDetail(!Constant.isShowDetail())
    }
    
    static func changeShowDetail(_ value:Bool) {
        UserDefaults.standard.set(value, forKey: Constant.PARAM_HIDE_OR_SHOW_DETAIL)
        NotificationCenter.default.post(name: Notification.Name(rawValue: Constant.PARAM_HIDE_OR_SHOW_DETAIL), object: value)
    }
    
    // SSH
    static func getSSHPath() -> String {
        if (UserDefaults.standard.string(forKey: Constant.PARAM_APP_SSH) != nil) {
            return UserDefaults.standard.string(forKey: Constant.PARAM_APP_SSH)!
        }
        else {
            return "/Applications/iTerm.app";
        }
    }
    
    static func setSSHPath(_ value:String) {
        UserDefaults.standard.setValue(value, forKey: Constant.PARAM_APP_SSH)
    }
    
    // SFTP
    static func getSFTPPath() -> String {
        if (UserDefaults.standard.string(forKey: Constant.PARAM_APP_SFTP) != nil) {
            return UserDefaults.standard.string(forKey: Constant.PARAM_APP_SFTP)!
        }
        else {
            return "/Applications/FileZilla.app/Contents/MacOS/filezilla";
        }
    }
    
    static func setSFTPPath(_ value:String) {
        UserDefaults.standard.setValue(value, forKey: Constant.PARAM_APP_SFTP)
    }
}
