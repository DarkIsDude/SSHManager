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
    
    func populate (name:String, host:String, username:String, password:String) -> Host {
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
    
    func setParentValue(value:Group) {
        parent = value
    }
    
    func setIconValue(value:String) {
        icon = value
    }
    
    func setNameValue(value:String) {
        name = value
    }
    
    func setHostValue(value:String) {
        host = value
    }
    
    func setUsernameValue(value:String) {
        username = value
    }
    
    func setPasswordValue(value:String) {
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
        let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("temp.sh")
        let pathFile = fileURL.path
        
        do {
            var write = "#!/usr/bin/expect -f\n"
            write = write + "spawn ssh " + self.getUsername() + "@" + self.getHost() + "\n"
            write = write + "match_max 100000\n"
            write = write + "expect \"*?assword:*\"\n"
            write = write + "send -- \"" + self.getPassword() + "\r\"\n"
            write = write + "interact\n"
            
            try write.writeToFile(pathFile!, atomically: false, encoding: NSUTF8StringEncoding)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        
        let taskChmod = NSTask()
        taskChmod.launchPath = "/bin/chmod"
        taskChmod.arguments = ["+x", pathFile!]
        taskChmod.launch()
        taskChmod.waitUntilExit()
        
        // TODO change iTerm by...
        let taskOpen = NSTask()
        taskOpen.launchPath = "/usr/bin/open"
        taskOpen.arguments = ["-a", "/Applications/iTerm.app", pathFile!]
        taskOpen.launch()
        taskOpen.waitUntilExit()
        
        // Don't delete the file (Directory is temp)
    }
    
    func connectSFTP() {
        let task = NSTask()
        task.launchPath = "/usr/bin/env"
        task.arguments = ["/Applications/FileZilla.app/Contents/MacOS/filezilla", "sftp://" + self.getUsername() + ":" + self.getPassword() + "@" + self.getHost()]
        task.launch()
        
        // TODO
    }
}