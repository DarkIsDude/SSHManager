//
//  Model.swift
//  SwiftSourceList
//
//  Created by Debasis Das on 3/29/15.
//  Copyright (c) 2015 Knowstack. All rights reserved.
//

import Cocoa
import RealmSwift

class Host: Object {
    dynamic var name:String = ""
    dynamic var host:String = ""
    dynamic var username:String = ""
    dynamic var password: String = ""
    dynamic var parent:Group? = Group()
    
    func populate (name:String, host:String, username:String, password:String) -> Host {
        self.name = name
        self.host = host
        self.username = username
        self.password = password
        return self
    }
    
    func getParent() -> Group {
        return parent!
    }
    
    func getName() -> String {
        return name
    }
    
    func getHost() -> String {
        return host
    }
    
    func getUsername() -> String {
        return username
    }
    
    func getPassword() -> String {
        return password
    }
    
    func setParentValue(value:Group) {
        parent = value
    }
    
    func setNameValue(value:String) {
        name = value
    }
    
    func setHostValue(value:String) {
        host = value
    }
    
    func setUsernameValue(value:String) {
        username = value
    }
    
    func setPasswordValue(value:String) {
        password = value
    }
}