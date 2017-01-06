//
//  MainViewController.swift
//  SSH Manager
//
//  Created by Edouard COMTET on 06/01/2017.
//  Copyright © 2017 Edouard COMTET. All rights reserved.
//

import Foundation
import Cocoa

class MainWindowController : NSWindowController {
    override func windowDidLoad() {
        super.windowDidLoad()
        let window = self.window
        window?.setFrameAutosaveName("WindowSSHManager")
    }
}
