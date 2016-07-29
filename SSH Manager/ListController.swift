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
    
    let data = Data.getSingleton()
    
    func reloadData() {
        data.save()        
        self.outlineView.reloadData()
    }
    
    /** NSViewController **/
 
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    /** NSOutlineViewDelegate, NSOutlineViewDataSource **/
    
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
            return data.getTree()[index]
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
            return data.getTree().count
        }
    }
    
    func outlineView(outlineView: NSOutlineView, viewForTableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
        dispatch_async(dispatch_get_main_queue(), {
            self.outlineView.expandItem(nil, expandChildren: true)
        });
        
        switch item {
        case let group as Group:
            let view = outlineView.makeViewWithIdentifier("HeaderCell", owner: self) as! NSTableCellView
            view.textField?.stringValue = group.getName()
            
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
            detailController.changeHost(host)
        }
        else if (object is Group){
            let group:Group = object as! Group
            detailController.changeGroup(group)
        }
    }
}

