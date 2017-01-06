//
//  SplitViewController.swift
//  SSH Manager
//
//  Created by Edouard COMTET on 06/01/2017.
//  Copyright © 2017 Edouard COMTET. All rights reserved.
//

import Foundation
import Cocoa

class SplitViewController : NSSplitViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let splitView = self.splitView
        splitView.autosaveName = "SplitViewMainSSHManager"
    }
}
