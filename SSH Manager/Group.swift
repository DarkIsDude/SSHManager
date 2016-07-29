//
//  Group.swift
//  SSH Manager
//
//  Created by Edouard COMTET on 13/06/16.
//  Copyright © 2016 Edouard COMTET. All rights reserved.
//

import Foundation
import RealmSwift

class Group: Object {
    dynamic var name:String = ""
    dynamic var parent:Group? = nil
    dynamic var expanded:Bool = true
    
    var groups:List<Group> = List<Group>()
    var hosts:List<Host> = List<Host>()
    
    func populate(name:String) -> Group {
        self.name = name
        return self
    }
    
    func getExpanded() -> Bool {
        return expanded
    }
    
    func getParent() -> Group? {
        return parent
    }
    
    func getName() -> String {
        return name
    }
    
    func getGroups() -> List<Group> {
        return groups
    }
    
    func getHosts() -> List<Host> {
        return hosts
    }
    
    func addHost(host:Host) {
        hosts.append(host)
        host.setParentValue(self)
    }
    
    func addGroup(group:Group) {
        groups.append(group)
        group.parent = self
    }
    
    func removeGroup(group:Group) {
        var find:Bool = false;
        var i:Int = 0;
        
        while (!find && i < groups.count) {
            if (groups[i].getName() == group.getName()) {
                find = true
            }
            else {
                i += 1
            }
        }
        
        if (find) {
            groups.removeAtIndex(i)
        }
    }
    
    func removeHost(host:Host) {
        var find:Bool = false;
        var i:Int = 0;
        
        while (!find && i < hosts.count) {
            if (hosts[i].getName() == host.getName()) {
                find = true
            }
            else {
                i += 1
            }
        }
        
        if (find) {
            hosts.removeAtIndex(i)
        }
    }
    
    func setParentToRoot() {
        self.parent = nil
    }
    
    func setNameValue(value:String) {
        name = value
    }
    
    func setExpandedValue(value:Bool) {
        expanded = value
    }
    
    func copyIt() -> Group {
        let groupC:Group = Group()
        groupC.setNameValue(self.getName())
        groupC.setExpandedValue(self.getExpanded())
        
        // Mise à jour des hosts
        for h in self.getHosts() {
            groupC.addHost(h.copyIt())
        }
        
        // Mise à jour des groupes
        for g in self.getGroups() {
            groupC.addGroup(g.copyIt())
        }
        
        return groupC
    }
}