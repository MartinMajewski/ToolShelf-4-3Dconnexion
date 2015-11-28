//
//  ConnexionAddHandler.swift
//  ToolShelf-4-3Dconnexion
//
//  Created by Martin Majewski on 24.11.15.
//  Copyright © 2015 MartinMajewski.net. All rights reserved.
//

import Foundation

let addedHandler : ConnexionAddedHandlerProc = {(deviceId : UInt32) -> Void in
	print("Device added with ID \(deviceId)")
	
	if let device = CCH.DeviceDictonary[deviceId]{
		CCH.Instance.connectedDevicesDictonary[deviceId] = device
	}else{
		CCH.Instance.connectedDevicesDictonary[deviceId] = "Unknown"
	}
	
	AppInstance.mainVC.printConnectedDevicesFrom(Dictonary: CCH.Instance.connectedDevicesDictonary, sorted: true)
	
}