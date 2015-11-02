//
//  AppDelegate.swift
//  3DconnexionStatsUtility
//
//  Created by Martin Majewski on 21.10.15.
//  Copyright © 2015 MartinMajewski.net. All rights reserved.
//

import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var mainVC : ViewController!
    
    override init() {
        super.init()
        
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func ExitNow(sender: AnyObject) {
        NSApplication.sharedApplication().terminate(self)
    }


}

