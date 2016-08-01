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
    
    var data:Data? = nil
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
    @IBOutlet weak var iconField: NSComboBox!
    
    @IBOutlet weak var iconPreview: NSImageView!
    
    override func viewDidLoad() {
        data = Data.getSingleton()
        super.viewDidLoad()
        
        iconField.removeAllItems()
        for i in self.getAllNSImageName() {
            iconField.addItemWithObjectValue(i)
        }
    }

    /** Action **/
    @IBAction func changeIcon(sender: AnyObject) {
        iconPreview.image = NSImage(named: iconField.objectValueOfSelectedItem as! String)
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
            data!.removeRootGroup(groupSelected!)
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
            data!.removeRootGroup(groupSelected!)
            groupSelected?.setParentToRoot()
            
            if (parentField.selectedItem?.title != "ROOT") {
                data!.getGroup(parentField.selectedItem!.title)!.addGroup(groupSelected!)
            }
            else {
                data!.addRootGroup(groupSelected!)
            }
        }
        else {
            hostSelected?.setNameValue(nameField.stringValue)
            hostSelected?.setPasswordValue(passwordField.stringValue)
            hostSelected?.setHostValue(hostField.stringValue)
            hostSelected?.setUsernameValue(usernameField.stringValue)
            hostSelected?.setIconValue(iconField.objectValueOfSelectedItem as! String)
            
            hostSelected?.getParent().removeHost(hostSelected!)
            data!.getGroup(parentField.selectedItem!.title)?.addHost(hostSelected!)
        }

        reloadList()
    }
    
    @IBAction func connect(sender: AnyObject) {
        hostSelected!.connect()
    }
    
    /** Others **/
    
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
        iconField.selectItemWithObjectValue(host.getIcon())
        iconPreview.image = NSImage(named: host.getIcon())
        iconField.enabled = true
        
        parentField.enabled = true
        parentField.removeAllItems()
        for g in data!.getAllGroups() {
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
        iconField.selectItemWithObjectValue("NSApplicationIcon")
        iconPreview.image = NSImage(named: "NSApplicationIcon")
        iconField.enabled = false
        
        parentField.enabled = true
        parentField.removeAllItems()
        parentField.addItemWithTitle("ROOT")
        for g in data!.getAllGroups() {
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
        let splitViewController = self.parentViewController as! NSSplitViewController
        let listController = splitViewController.childViewControllers[0] as! ListController

        listController.reloadData()
    }
    
    func getAllNSImageName() -> [String] {
        return [
            NSImageNameQuickLookTemplate,
            NSImageNameBluetoothTemplate,
            NSImageNameIChatTheaterTemplate,
            NSImageNameSlideshowTemplate,
            NSImageNameActionTemplate,
            NSImageNameSmartBadgeTemplate,
            NSImageNameIconViewTemplate,
            NSImageNameListViewTemplate,
            NSImageNameColumnViewTemplate,
            NSImageNameFlowViewTemplate,
            NSImageNamePathTemplate,
            NSImageNameInvalidDataFreestandingTemplate,
            NSImageNameLockLockedTemplate,
            NSImageNameLockUnlockedTemplate,
            NSImageNameGoRightTemplate,
            NSImageNameGoLeftTemplate,
            NSImageNameRightFacingTriangleTemplate,
            NSImageNameLeftFacingTriangleTemplate,
            NSImageNameAddTemplate,
            NSImageNameRemoveTemplate,
            NSImageNameRevealFreestandingTemplate,
            NSImageNameFollowLinkFreestandingTemplate,
            NSImageNameEnterFullScreenTemplate,
            NSImageNameExitFullScreenTemplate,
            NSImageNameStopProgressTemplate,
            NSImageNameStopProgressFreestandingTemplate,
            NSImageNameRefreshTemplate,
            NSImageNameRefreshFreestandingTemplate,
            NSImageNameBonjour,
            NSImageNameComputer,
            NSImageNameFolderBurnable,
            NSImageNameFolderSmart,
            NSImageNameFolder,
            NSImageNameNetwork,
            NSImageNameMobileMe,
            NSImageNameMultipleDocuments,
            NSImageNameUserAccounts,
            NSImageNamePreferencesGeneral,
            NSImageNameAdvanced,
            NSImageNameInfo,
            NSImageNameFontPanel,
            NSImageNameColorPanel,
            NSImageNameUser,
            NSImageNameUserGroup,
            NSImageNameEveryone,
            NSImageNameUserGuest,
            NSImageNameMenuOnStateTemplate,
            NSImageNameMenuMixedStateTemplate,
            NSImageNameApplicationIcon,
            NSImageNameTrashEmpty,
            NSImageNameTrashFull,
            NSImageNameHomeTemplate,
            NSImageNameBookmarksTemplate,
            NSImageNameCaution,
            NSImageNameStatusAvailable,
            NSImageNameStatusPartiallyAvailable,
            NSImageNameStatusUnavailable,
            NSImageNameStatusNone,
            NSImageNameShareTemplate
        ]
    }
}