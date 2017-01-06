//
//  Model.swift
//  SwiftSourceList
//
//  Created by Debasis Das on 3/29/15.
//  Copyright (c) 2015 Knowstack. All rights reserved.
//

import Cocoa
import RealmSwift
import Foundation

class Host: Object {
    dynamic var name:String = ""
    dynamic var host:String = ""
    dynamic var username:String = ""
    dynamic var password:String = ""
    dynamic var icon:String = "NSComputer"
    dynamic var parent:Group? = Group()
    
    class func sort(h1:Host, h2:Host) -> Bool {
        return h1.name < h2.name
    }
    
    func populate (_ name:String, host:String, username:String, password:String) -> Host {
        self.name = name
        self.host = host
        self.username = username
        self.password = password
        return self
    }
    
    func getParent() -> Group {
        return parent!
    }
    
    func getName() -> String {
        return name
    }
    
    func getHost() -> String {
        return host
    }
    
    func getUsername() -> String {
        return username
    }
    
    func getPassword() -> String {
        return password
    }
    
    func getIcon() -> String {
        return icon
    }
    
    func setParentValue(_ value:Group) {
        parent = value
    }
    
    func setIconValue(_ value:String) {
        icon = value
    }
    
    func setNameValue(_ value:String) {
        name = value
    }
    
    func setHostValue(_ value:String) {
        host = value
    }
    
    func setUsernameValue(_ value:String) {
        username = value
    }
    
    func setPasswordValue(_ value:String) {
        password = value
    }
    
    func copyIt() -> Host {
        let hostC:Host = Host();
        hostC.setHostValue(self.getHost())
        hostC.setNameValue(self.getName())
        hostC.setPasswordValue(self.getPassword())
        hostC.setUsernameValue(self.getUsername())
        hostC.setIconValue(self.getIcon())
        
        return hostC
    }
    
    func connectSSH() {
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("temp.sh")
        let pathFile = fileURL.path
        
        do {
            var write = "";
            
            if (!self.getPassword().isEmpty) {
                write = "#!/usr/bin/expect -f\n"
                write = write + "spawn ssh " + self.getUsername() + "@" + self.getHost() + "\n"
                write = write + "match_max 100000\n"
                write = write + "expect \"*?assword:*\"\n"
                write = write + "send -- \"" + self.getPassword() + "\r\"\n"
                write = write + "interact\n"
            }
            else {
                write = "#!/bin/sh -f\n"
                write = write + "ssh " + self.getUsername() + "@" + self.getHost() + "\n"
            }
            
            try write.write(toFile: pathFile, atomically: false, encoding: String.Encoding.utf8)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        
        let taskChmod = Process()
        taskChmod.launchPath = "/bin/chmod"
        taskChmod.arguments = ["+x", pathFile]
        taskChmod.launch()
        taskChmod.waitUntilExit()
        
        let taskOpen = Process()
        taskOpen.launchPath = "/usr/bin/open"
        taskOpen.arguments = ["-a", Constant.getSSHPath(), pathFile]
        taskOpen.launch()
        taskOpen.waitUntilExit()
        
        // Don't delete the file (Directory is temp)
    }
    
    func connectSFTP() {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        if (self.getPassword().isEmpty) {
            task.arguments = [Constant.getSFTPPath(), "sftp://" + self.getUsername() + "@" + self.getHost()]
        }
        else {
            task.arguments = [Constant.getSFTPPath(), "sftp://" + self.getUsername() + ":" + self.getPassword() + "@" + self.getHost()]
        }
        task.launch()
    }
}
