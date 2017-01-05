//
//  ViewController.swift
//  SSH Manager
//
//  Created by Edouard COMTET on 13/06/16.
//  Copyright © 2016 Edouard COMTET. All rights reserved.
//

import Cocoa

class ListController: NSViewController, NSOutlineViewDelegate, NSOutlineViewDataSource {

    @IBOutlet weak var outlineView: NSOutlineView!
    
    var data:Data? = nil
    var groupSelected:Group? = nil
    var hostSelected:Host? = nil
    
    func reloadData() {
        self.outlineView.reloadData()
    }
    
    func setDetail() -> Bool {
        let splitViewController = self.parent as! NSSplitViewController
        return !splitViewController.splitView.isSubviewCollapsed(splitViewController.splitViewItems[1].viewController.view)
    }
    
    func setHost(_ host:Host, connect: Bool) {
        if (setDetail()) {
            let splitViewController = self.parent as! NSSplitViewController
            let detailController = splitViewController.childViewControllers[1] as! DetailController
            detailController.changeHost(host)
        }
        
        if (connect) {
            host.connectSSH()
        }
    }
    
    func hideOrShowDetail() {
        let splitViewController = self.parent as! NSSplitViewController
        splitViewController.splitViewItems[1].isCollapsed = !Constant.isShowDetail()
    }
    
    /** NSViewController **/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = Data.getSingleton()
        
        hideOrShowDetail()
        NotificationCenter.default.addObserver(self, selector: #selector(hideOrShowDetail), name: NSNotification.Name(rawValue: Constant.PARAM_HIDE_OR_SHOW_DETAIL), object: nil)
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    /** NSOutlineViewDelegate, NSOutlineViewDataSource **/
    
    func outlineViewItemWillExpand(_ notification: Notification) {
        let o:AnyObject = ((notification as NSNotification).userInfo?.first?.1)! as AnyObject
        let group:Group = o as! Group
        group.setExpandedValue(true)
    }
    
    func outlineViewItemWillCollapse(_ notification: Notification) {
        let o:AnyObject = ((notification as NSNotification).userInfo?.first?.1)! as AnyObject
        let group:Group = o as! Group
        group.setExpandedValue(false)
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let item: AnyObject = item as AnyObject? {
            switch item {
                case let group as Group:
                    if (index >= group.getGroups().count) {
                        return group.getHosts()[index - group.getGroups().count]
                    }
                    else {
                        return group.getGroups()[index]
                    }
                default:
                    return self
            }
        }
        else {
            return data!.getTree()[index]
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        switch item {
        case let group as Group:
            return ((group.getHosts().count + group.getGroups().count) > 0) ? true : false
        default:
            return false
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let item: AnyObject = item as AnyObject? {
            switch item {
                case let group as Group:
                    return (group.getHosts().count + group.getGroups().count)
                default:
                    return 0
            }
        } else {
            return data!.getTree().count
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor viewForTableColumn: NSTableColumn?, item: Any) -> NSView? {
        switch item {
        case let group as Group:
            let view = outlineView.make(withIdentifier: "HeaderCell", owner: self) as! NSTableCellView
            view.textField?.stringValue = group.getName()
            
            if (group.getExpanded()) {
                DispatchQueue.main.async(execute: {
                    self.outlineView.expandItem(item, expandChildren: false)
                });
            }
            
            return view
        case let host as Host:
            let view = outlineView.make(withIdentifier: "DataCell", owner: self) as! NSTableCellView
            view.textField?.stringValue = host.getName()
            (view.subviews[0] as! NSImageView).image = NSImage(named: host.getIcon())
            
            return view
        default:
            return nil
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        switch item {
            case let group as Group:
                return (group.getParent() == nil) ? true : false
            default:
                return false
        }
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        let selectedIndex = (notification.object as AnyObject).selectedRow
        let object:Any? = (notification.object as AnyObject).item(atRow: selectedIndex!)
        
        if (object is Host) {
            let host:Host = object as! Host
            self.setHost(host, connect: false)
        }
        else if (object is Group) {
            let group:Group = object as! Group
            
            if (setDetail()) {
                let splitViewController = self.parent as! NSSplitViewController
                let detailController = splitViewController.childViewControllers[1] as! DetailController
                detailController.changeGroup(group)
            }
        }
    }
    
    /** Action **/
    
    @IBAction func doubleClickItem(_ sender: AnyObject) {
        let item = sender.item(atRow: sender.clickedRow)
        
        // Si c'est un group, je l'ouvre ou je le ferme et j'enregistre
        if (item is Group) {
            let group:Group = item as! Group
            
            if sender.isItemExpanded(item) {
                sender.collapseItem(item)
                group.setExpandedValue(false)
            } else {
                sender.expandItem(item)
                group.setExpandedValue(true)
            }
        }
        // Si c'est un hote, je me connecte
        else if (item is Host) {
            let host:Host = item as! Host
            self.setHost(host, connect: true)
        }
    }
}

