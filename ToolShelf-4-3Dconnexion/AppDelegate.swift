//
//  AppDelegate.swift
//  ToolShelf-4-3Dconnexion
//
//  Created by Martin Majewski on 21.10.15.
//  Copyright © 2015 MartinMajewski.net. All rights reserved.
//

import Cocoa

let AppInstance = NSApplication.shared.delegate as! AppDelegate

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var mainVC : VCMainView!
    
    override init() {
        super.init()
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
    }
	
    func ExitNow(sender: AnyObject) {
        NSApplication.shared.terminate(self)
    }
	
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
		return true
	}
	
	func openWebsite(URL url: String) -> Bool {
		if let checkURL = NSURL(string: url) {
            if NSWorkspace.shared.open(checkURL as URL) {
                print("\(checkURL) successfully opened")
				return true
			}
		}
		print("invalid url: \(url)")
		return false
	}

	@IBAction func openMyWebsite(_ sender: AnyObject) {
        if(!openWebsite(URL: "http://www.martinmajewski.net")) {
            print("failed to open")
        }
	}
}

