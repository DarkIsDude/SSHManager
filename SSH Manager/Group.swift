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
    
    class func sort(g1:Group, g2:Group) -> Bool {
        return g1.name < g2.name
    }
    
    /**
     * Trie les groupes et les hotes que contient ce groupe
     */
    func sort() {
        let groups:[Group] = self.groups.sorted(by: Group.sort)
        let hosts:[Host] = self.hosts.sorted(by: Host.sort)
        
        self.groups.removeAll()
        self.hosts.removeAll()
        
        for g in groups {
            self.groups.append(g)
            g.sort()
        }
        
        for h in hosts {
            self.hosts.append(h)
        }
    }
    
    func populate(_ name:String) -> Group {
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
    
    func addHost(_ host:Host) {
        hosts.append(host)
        host.setParentValue(self)
    }
    
    func addGroup(_ group:Group) {
        groups.append(group)
        group.parent = self
    }
    
    func removeGroup(_ group:Group) {
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
            groups.remove(at: i)
        }
    }
    
    func removeHost(_ host:Host) {
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
            hosts.remove(at: i)
        }
    }
    
    func setParentToRoot() {
        self.parent = nil
    }
    
    func setNameValue(_ value:String) {
        name = value
    }
    
    func setExpandedValue(_ value:Bool) {
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
