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
    
    @IBOutlet weak var connectSFTPButton: NSButton!
    @IBOutlet weak var connectSSHButton: NSButton!
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
            iconField.addItem(withObjectValue: i)
        }
    }

    /** Action **/
    @IBAction func changeIcon(_ sender: AnyObject) {
        iconPreview.image = NSImage(named: iconField.objectValueOfSelectedItem as! String)
    }
    
    @IBAction func addHost(_ sender: AnyObject) {
        groupSelected?.addHost(Host().populate("New HOST", host: "", username: "", password: ""))
        reloadList()
    }
    
    @IBAction func addGroup(_ sender: AnyObject) {
        groupSelected?.addGroup(Group().populate("New GROUP"))
        reloadList()
    }
    
    @IBAction func remove(_ sender: AnyObject) {
        if (groupSelected != nil) {
            groupSelected?.getParent()?.removeGroup(groupSelected!)
            data!.removeRootGroup(groupSelected!)
        }
        else {
            hostSelected?.getParent().removeHost(hostSelected!)
        }
        
        reloadList()
    }
    
    @IBAction func refresh(_ sender: AnyObject) {
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
    
    @IBAction func connectSHH(_ sender: AnyObject) {
        hostSelected!.connectSSH()
    }
    
    @IBAction func connectSFTP(_ sender: AnyObject) {
        hostSelected!.connectSFTP()
    }
    
    /** Others **/
    
    func changeHost(_ host: Host) {
        groupSelected = nil
        hostSelected = host
        
        nameField.stringValue = host.getName()
        nameField.isEnabled = true
        hostField.stringValue = host.getHost()
        hostField.isEnabled = true
        usernameField.stringValue = host.getUsername()
        usernameField.isEnabled = true
        passwordField.stringValue = host.getPassword()
        passwordField.isEnabled = true
        iconField.selectItem(withObjectValue: host.getIcon())
        iconPreview.image = NSImage(named: host.getIcon())
        iconField.isEnabled = true
        
        parentField.isEnabled = true
        parentField.removeAllItems()
        for g in data!.getAllGroups() {
            parentField.addItem(withTitle: g.getName())
        }
        parentField.selectItem(withTitle: host.getParent().getName())
        
        connectSSHButton.isEnabled = true
        connectSFTPButton.isEnabled = true
        addHostButton.isEnabled = false
        addGroupButton.isEnabled = false
        saveButton.isEnabled = true
        removeButton.isEnabled = true
    }
    
    func changeGroup(_ group: Group) {
        groupSelected = group
        hostSelected = nil
        
        nameField.stringValue = group.getName()
        nameField.isEnabled = true
        hostField.stringValue = ""
        hostField.isEnabled = false
        usernameField.stringValue = ""
        usernameField.isEnabled = false
        passwordField.stringValue = ""
        passwordField.isEnabled = false
        iconField.selectItem(withObjectValue: "NSApplicationIcon")
        iconPreview.image = NSImage(named: "NSApplicationIcon")
        iconField.isEnabled = false
        
        parentField.isEnabled = true
        parentField.removeAllItems()
        parentField.addItem(withTitle: "ROOT")
        for g in data!.getAllGroups() {
            parentField.addItem(withTitle: g.getName())
        }
        
        if (group.getParent() == nil) {
            parentField.selectItem(withTitle: "ROOT")
        }
        else {
            parentField.selectItem(withTitle: group.getParent()!.getName())
        }
        
        connectSSHButton.isEnabled = false
        connectSFTPButton.isEnabled = false
        addHostButton.isEnabled = true
        addGroupButton.isEnabled = true
        saveButton.isEnabled = true
        removeButton.isEnabled = true
    }
    
    func reloadList() {
        let splitViewController = self.parent as! NSSplitViewController
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
