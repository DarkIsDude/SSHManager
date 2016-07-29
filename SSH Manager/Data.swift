//
//  ExampleData.swift
//  SSH Manager
//
//  Created by Edouard COMTET on 28/07/16.
//  Copyright © 2016 Edouard COMTET. All rights reserved.
//

import Foundation
import RealmSwift

class Data {
    private static let singleton:Data = Data()
    private var groups: [Group] = []
    
    class func getSingleton() -> Data {
        return Data.singleton
    }
    
    private init() {
        self.loadData()
    }
    
    // Je dois tout copier pour éviter des erreurs lors dans les threads
    private func loadData() {
        let realm = try! Realm()
        groups = []
        
        let groupsToSort = realm.objects(Group.self)
        for g in groupsToSort {
            if (g.getParent() == nil) {
                groups.append(self.copyGroup(g))
            }
        }
        
        if groups.isEmpty {
            groups.append(Group().populate("My first group"))
        }
    }
    
    func copyGroup(group:Group) -> Group {
        let groupC:Group = Group()
        groupC.setNameValue(group.getName())
        
        // Mise à jour des hosts
        for h in group.getHosts() {
            groupC.addHost(self.copyHost(h))
        }
        
        // Mise à jour des groupes
        for g in group.getGroups() {
            groupC.addGroup(self.copyGroup(g))
        }
        
        return groupC
    }
    
    func copyHost(host:Host) -> Host {
        let hostC:Host = Host();
        hostC.setHostValue(host.getHost())
        hostC.setNameValue(host.getName())
        hostC.setPasswordValue(host.getPassword())
        hostC.setUsernameValue(host.getUsername())
        
        return hostC
    }
    
    /// Sauvegarde les données dans un fichier
    func save() {
        let realm = try! Realm()
        let groupsToDelete = realm.objects(Group.self)
        
        try! realm.write {
            for g in groupsToDelete {
                realm.delete(g)
            }
        }
        
        try! realm.write {
            for g in groups {
                realm.add(g)
            }
        }
        
        self.loadData()
    }
    
    /// Retourne l'ensemble de l'arbre
    func getTree() -> [Group] {
        return groups;
    }
    
    /// Retourne uniquement les groupes sous forme d'un tableau
    func getAllGroups() -> [Group] {
        var groupsOnly:[Group] = []
        
        for g in groups {
            groupsOnly = getAllGroups(groupsOnly, element: g)
        }
        
        return groupsOnly
    }
    
    func getAllGroups(groups:[Group], element:Group) -> [Group] {
        var groupsOnly:[Group] = groups
        groupsOnly.append(element)
        
        for g in element.getGroups() {
            groupsOnly = getAllGroups(groupsOnly, element: g)
        }
        
        return groupsOnly
    }
    
    /// Retourne le group portant le name ou nil
    func getGroup(name:String) -> Group? {
        var groupFind:Group? = nil
        var i:Int = 0
        
        while (groupFind == nil && i < groups.count) {
            let g = getGroup(name, group: groups[i])
            if (g != nil) {
                groupFind = g
            }
            
            i += 1
        }
        
        return groupFind
    }
    
    func getGroup(name:String, group:Group) -> Group? {
        var groupFind:Group? = nil
        
        if (group.getName() == name) {
            groupFind = group
        }
        else {
            var i:Int = 0
            
            while (groupFind == nil && i < group.getGroups().count) {
                let g = getGroup(name, group: group.getGroups()[i])
                if (g != nil) {
                    groupFind = g
                }
                
                i += 1
            }
        }
        
        return groupFind
    }
    
    // Fonction de gestion des groupes
    func addRootGroup(group:Group) {
        if (findIndex(group) < 0) {
            self.groups.append(group)
        }
    }
    
    func removeRootGroup(group:Group) {
        let i:Int = findIndex(group)
        if (i > 0) {
            groups.removeAtIndex(i)
        }
    }
    
    private func findIndex(group:Group) -> Int {
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
            return i
        }
        else {
            return -1
        }
    }
}