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
		self.dismissController(self)
		AppInstance.ExitNow(self)
	}
	
	@IBAction func btnOpenWebsiteAndCloseApp(sender: AnyObject) {
		AppInstance.openWebsite(URL: "http://www.3dconnexion.de/service/drivers.html")
		self.dismissController(self)
		btnCloseApp(self)
	}
	
	@IBAction func btnOpenMMNetAndCloseApp(sender: AnyObject) {
		AppInstance.openWebsite(URL: "http://www.martinmajewski.net")
		self.dismissController(self)
		btnCloseApp(self)
	}
	
}
