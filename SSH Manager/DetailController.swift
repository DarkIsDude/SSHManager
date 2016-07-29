//
//  DetailController.swift
//  SSH Manager
//
//  Created by Edouard COMTET on 16/06/16.
//  Copyright © 2016 Edouard COMTET. All rights reserved.
//

import Foundation
import Cocoa

class DetailController : NSViewController {
    
    let data = Data.getSingleton()
    var groupSelected:Group? = nil
    var hostSelected:Host? = nil
    
    @IBOutlet weak var connectButton: NSButton!
    @IBOutlet weak var addHostButton: NSButton!
    @IBOutlet weak var addGroupButton: NSButton!
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var removeButton: NSButton!
    
    @IBOutlet weak var nameField: NSTextField!
    @IBOutlet weak var hostField: NSTextField!
    @IBOutlet weak var usernameField: NSTextField!
    @IBOutlet weak var passwordField: NSSecureTextField!
    @IBOutlet weak var parentField: NSPopUpButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func addHost(sender: AnyObject) {
        groupSelected?.addHost(Host().populate("New HOST", host: "", username: "", password: ""))
        reloadList()
    }
    
    @IBAction func addGroup(sender: AnyObject) {
        groupSelected?.addGroup(Group().populate("New GROUP"))
        reloadList()
    }
    
    @IBAction func remove(sender: AnyObject) {
        if (groupSelected != nil) {
            groupSelected?.getParent()?.removeGroup(groupSelected!)
            data.removeRootGroup(groupSelected!)
        }
        else {
            hostSelected?.getParent().removeHost(hostSelected!)
        }
        
        reloadList()
    }
    
    @IBAction func save(sender: AnyObject) {
        if (groupSelected != nil) {
            groupSelected?.setNameValue(nameField.stringValue)
            
            groupSelected?.getParent()?.removeGroup(groupSelected!)
            data.removeRootGroup(groupSelected!)
            groupSelected?.setParentToRoot()
            
            if (parentField.selectedItem?.title != "ROOT") {
                data.getGroup(parentField.selectedItem!.title)!.addGroup(groupSelected!)
            }
            else {
                data.addRootGroup(groupSelected!)
            }
        }
        else {
            hostSelected?.setNameValue(nameField.stringValue)
            hostSelected?.setPasswordValue(passwordField.stringValue)
            hostSelected?.setHostValue(hostField.stringValue)
            hostSelected?.setUsernameValue(usernameField.stringValue)
            
            hostSelected?.getParent().removeHost(hostSelected!)
            data.getGroup(parentField.selectedItem!.title)?.addHost(hostSelected!)
        }

        reloadList()
    }
    
    @IBAction func connect(sender: AnyObject) {
        let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("temp.sh")
        let pathFile = fileURL.path
        
        do {
            var write = "#!/usr/bin/expect -f\n"
            write = write + "spawn ssh " + usernameField.stringValue + "@" + hostField.stringValue + "\n"
            write = write + "match_max 100000\n"
            write = write + "expect \"*?assword:*\"\n"
            write = write + "send -- \"" + passwordField.stringValue + "\r\"\n"
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
    
    func changeHost(host: Host) {
        groupSelected = nil
        hostSelected = host
        
        nameField.stringValue = host.getName()
        nameField.enabled = true
        hostField.stringValue = host.getHost()
        hostField.enabled = true
        usernameField.stringValue = host.getUsername()
        usernameField.enabled = true
        passwordField.stringValue = host.getPassword()
        passwordField.enabled = true
        
        parentField.enabled = true
        parentField.removeAllItems()
        for g in data.getAllGroups() {
            parentField.addItemWithTitle(g.getName())
        }
        parentField.selectItemWithTitle(host.getParent().getName())
        
        connectButton.enabled = true
        addHostButton.enabled = false
        addGroupButton.enabled = false
        saveButton.enabled = true
        removeButton.enabled = true
    }
    
    func changeGroup(group: Group) {
        groupSelected = group
        hostSelected = nil
        
        nameField.stringValue = group.getName()
        nameField.enabled = true
        hostField.stringValue = ""
        hostField.enabled = false
        usernameField.stringValue = ""
        usernameField.enabled = false
        passwordField.stringValue = ""
        passwordField.enabled = false
        
        parentField.enabled = true
        parentField.removeAllItems()
        parentField.addItemWithTitle("ROOT")
        for g in data.getAllGroups() {
            parentField.addItemWithTitle(g.getName())
        }
        
        if (group.getParent() == nil) {
            parentField.selectItemWithTitle("ROOT")
        }
        else {
            parentField.selectItemWithTitle(group.getParent()!.getName())
        }
        
        connectButton.enabled = false
        addHostButton.enabled = true
        addGroupButton.enabled = true
        saveButton.enabled = true
        removeButton.enabled = true
    }
    
    func reloadList() {
        data.save()
        
        let splitViewController = self.parentViewController as! NSSplitViewController
        let listController = splitViewController.childViewControllers[0] as! ListController

        listController.reloadData()
    }
}