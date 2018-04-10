//
//  VCDriverError.swift
//  ToolShelf-4-3Dconnexion
//
//  Created by Martin Majewski on 25.11.15.
//  Copyright © 2015 MartinMajewski.net. All rights reserved.
//

import Cocoa

public class VCDriverError: NSViewController{
	@IBOutlet var mlMessage: NSTextField!
	
	@IBAction func btnCloseApp(sender: AnyObject) {
		print("Closing Application now!")
        self.dismiss(self)
        AppInstance.ExitNow(sender: self)
	}
	
	@IBAction func btnOpenWebsiteAndCloseApp(sender: AnyObject) {
        if(!AppInstance.openWebsite(URL: "http://www.3dconnexion.de/service/drivers.html")) {
            print("failed to open")
        }
        self.dismiss(self)
        btnCloseApp(sender: self)
	}
	
	@IBAction func btnOpenMMNetAndCloseApp(sender: AnyObject) {
        if(!AppInstance.openWebsite(URL: "http://www.martinmajewski.net")) {
            print("failed to open")
        }
        self.dismiss(self)
        btnCloseApp(sender: self)
	}
	
}
