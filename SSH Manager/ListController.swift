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
    
    func reloadData() {
        data!.save()
        self.outlineView.reloadData()
    }
    
    func setHost(host:Host, connect: Bool) {
        let splitViewController = self.parentViewController as! NSSplitViewController
        let detailController = splitViewController.childViewControllers[1] as! DetailController
        
        detailController.changeHost(host)
        if (connect) {
            detailController.connect()
        }
    }
    
    func hideOrShowDetail() {
        let splitViewController = self.parentViewController as! NSSplitViewController
        splitViewController.splitViewItems[1].collapsed = !splitViewController.splitViewItems[1].collapsed
        NSUserDefaults.standardUserDefaults().setBool(splitViewController.splitViewItems[1].collapsed, forKey: "hideOrShowDetail")
    }
    
    /** NSViewController **/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = Data.getSingleton()
        
        if NSUserDefaults.standardUserDefaults().boolForKey("hideOrShowDetail") {
            hideOrShowDetail()
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(hideOrShowDetail), name: "hideOrShowDetail", object: nil)
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    /** NSOutlineViewDelegate, NSOutlineViewDataSource **/
    
    func outlineViewItemWillExpand(notification: NSNotification) {
        let o:AnyObject = (notification.userInfo?.first?.1)!
        let group:Group = o as! Group
        group.setExpandedValue(true)
    }
    
    func outlineViewItemWillCollapse(notification: NSNotification) {
        let o:AnyObject = (notification.userInfo?.first?.1)!
        let group:Group = o as! Group
        group.setExpandedValue(false)
    }
    
    func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        if let item: AnyObject = item {
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
    
    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
        switch item {
        case let group as Group:
            return ((group.getHosts().count + group.getGroups().count) > 0) ? true : false
        default:
            return false
        }
    }
    
    func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        if let item: AnyObject = item {
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
    
    func outlineView(outlineView: NSOutlineView, viewForTableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
        switch item {
        case let group as Group:
            let view = outlineView.makeViewWithIdentifier("HeaderCell", owner: self) as! NSTableCellView
            view.textField?.stringValue = group.getName()
            
            if (group.getExpanded()) {
                dispatch_async(dispatch_get_main_queue(), {
                    self.outlineView.expandItem(item, expandChildren: false)
                });
            }
            
            return view
        case let host as Host:
            let view = outlineView.makeViewWithIdentifier("DataCell", owner: self) as! NSTableCellView
            view.textField?.stringValue = host.getName()
            
            return view
        default:
            return nil
        }
    }
    
    func outlineView(outlineView: NSOutlineView, isGroupItem item: AnyObject) -> Bool {
        switch item {
            case let group as Group:
                return (group.getParent() == nil) ? true : false
            default:
                return false
        }
    }
    
    func outlineViewSelectionDidChange(notification: NSNotification) {
        let selectedIndex = notification.object?.selectedRow
        let object:AnyObject? = notification.object?.itemAtRow(selectedIndex!)
        
        let splitViewController = self.parentViewController as! NSSplitViewController
        let detailController = splitViewController.childViewControllers[1] as! DetailController
        
        if (object is Host) {
            let host:Host = object as! Host
            self.setHost(host, connect: false)
        }
        else if (object is Group){
            let group:Group = object as! Group
            detailController.changeGroup(group)
        }
    }
    
    /** Action **/
    
    @IBAction func doubleClickItem(sender: AnyObject) {
        let item = sender.itemAtRow(sender.clickedRow)
        
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

