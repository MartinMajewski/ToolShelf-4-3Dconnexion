//
//  ConnexionCallbacks.swift
//  ToolShelf-4-3Dconnexion
//
//  Created by Martin Majewski on 24.11.15.
//  Copyright © 2015 MartinMajewski.net. All rights reserved.
//

import Foundation

let messageHandler : ConnexionMessageHandlerProc = { (deviceId: UInt32, msgType: UInt32, var msgArgPtr: UnsafeMutablePointer<Void>) -> Void in
	//		print("Inside myMessageHandler")
	
	switch(msgType){
	case ConnexionClient.Msg.DeviceState:
		//			print("Inside ConnexionClient.Msg.DeviceState")
		
		let state = (UnsafeMutablePointer<ConnexionDeviceState>(msgArgPtr)).memory
		
		if state.client == CCH.Instance.ClientId {
			
			AppInstance.mainVC.tfActiveDevice.stringValue = "\(CCH.Instance.connectedDevicesDictonary[deviceId]!)\nDevice Id: \(deviceId)\nAddress: 0x\(String(state.address, radix: 16)) - 0d\(state.address)\n"
			
			print("Report:\t\(state.report)\n")
			
			switch(state.command){
			case ConnexionClient.Cmd.HandleAxis:
				
				AppInstance.mainVC.lblTranslateX.stringValue = String(state.axis.0)
				AppInstance.mainVC.lblTranslateY.stringValue = String(state.axis.1)
				AppInstance.mainVC.lblTranslateZ.stringValue = String(state.axis.2)
				AppInstance.mainVC.lblRotateX.stringValue	= String(state.axis.3)
				AppInstance.mainVC.lblRotateY.stringValue	= String(state.axis.4)
				AppInstance.mainVC.lblRotateZ.stringValue	= String(state.axis.5)
				
				break;
				
			case ConnexionClient.Cmd.HandleButtons:
				
				var outputString : String = ""
				
				for idx in 1...32{
					if(CCH.Instance.isButtonActive(withId: UInt32(idx), inside: state.buttons)){
						outputString += "- \(idx) -\n"
					}
					
				}
				
				AppInstance.mainVC.lblActiveBtns.stringValue = outputString
				
				break
				
			default: break
			}
		}
		
		break;
	case ConnexionClient.Msg.PrefsChanged:
		print("Inside ConnexionClient.Msg.PrefsChanged")
		
		break;
	case ConnexionClient.Msg.CalibrateDevice:
		print("Inside ConnexionClient.Msg.CalibrateDevice")
		
		break;
	default:
		// Ignoring other message types
		break;
	}
}