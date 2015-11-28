//
//  ConnexionRemoveHandler.swift
//  ToolShelf-4-3Dconnexion
//
//  Created by Martin Majewski on 24.11.15.
//  Copyright © 2015 MartinMajewski.net. All rights reserved.
//

import Foundation

let removedHandler : ConnexionRemovedHandlerProc = {(deviceId : UInt32) -> Void in
	print("Device removed with ID \(deviceId)")
	
	CCH.Instance.connectedDevicesDictonary[deviceId] = nil
	
	AppInstance.mainVC.printConnectedDevicesFrom(Dictonary: CCH.Instance.connectedDevicesDictonary, sorted: true)
}