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
    private static var singleton:Data? = nil
    private var groups: [Group] = []
    
    class func getSingleton() -> Data {
        if (Data.singleton == nil) {
            Data.singleton = Data()
        }
        
        return Data.singleton!
    }
    
    private init() {
        // Gestion des migration
        let config = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                    migration.enumerate(Group.className()) { oldObject, newObject in
                        if (oldObject!["expanded"] != nil) {
                            newObject!["expanded"] = oldObject!["expanded"]
                        }
                        else {
                            newObject!["expanded"] = true
                        }
                    }
                }
                
                if (oldSchemaVersion < 2) {
                    migration.enumerate(Host.className()) { oldObject, newObject in
                        newObject!["icon"] = "NSComputer"
                    }
                }
        })
        
        Realm.Configuration.defaultConfiguration = config
        self.loadData()
    }
    
    // Je dois tout copier pour éviter des erreurs lors dans les threads
    private func loadData() {
        let realm = try! Realm()
        groups = []
        
        let groupsToSort = realm.objects(Group.self)
        for g in groupsToSort {
            if (g.getParent() == nil) {
                groups.append(g.copyIt())
            }
        }
        
        if groups.isEmpty {
            groups.append(Group().populate("My first group"))
        }
    }
    
    /// Sauvegarde les données dans un fichier
    func save() {
        let realm = try! Realm()
        let groupsToDelete = realm.objects(Group.self)
        let hostsToDelete = realm.objects(Host.self)
        
        try! realm.write {
            for g in groupsToDelete {
                realm.delete(g)
            }
        }
        
        try! realm.write {
            for h in hostsToDelete {
                realm.delete(h)
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