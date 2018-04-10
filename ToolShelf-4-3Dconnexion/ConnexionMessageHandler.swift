//
//  ConnexionCallbacks.swift
//  ToolShelf-4-3Dconnexion
//
//  Created by Martin Majewski on 24.11.15.
//  Copyright © 2015 MartinMajewski.net. All rights reserved.
//

import Foundation

let messageHandler : ConnexionMessageHandlerProc = { (deviceId: UInt32, msgType: UInt32, msgArgPtr: UnsafeMutableRawPointer!) -> Void in
	//print("Inside myMessageHandler")
	switch(msgType){
	case ConnexionClient.Msg.DeviceState:
		//			print("Inside ConnexionClient.Msg.DeviceState")
        let state = msgArgPtr.assumingMemoryBound(to: ConnexionDeviceState.self)
		if state.pointee.client == CCH.Instance.ClientId {
			AppInstance.mainVC.tfActiveDevice.stringValue = "\(CCH.Instance.connectedDevicesDictonary[deviceId]!)\nDevice Id: \(deviceId)\nAddress: 0x\(String(state.pointee.address, radix: 16)) - 0d\(state.pointee.address)\n"
			print("Report:\t\(state.pointee.report)\n")
			switch(state.pointee.command){
			case ConnexionClient.Cmd.HandleAxis:
				AppInstance.mainVC.lblTranslateX.stringValue = String(state.pointee.axis.0)
				AppInstance.mainVC.lblTranslateY.stringValue = String(state.pointee.axis.1)
				AppInstance.mainVC.lblTranslateZ.stringValue = String(state.pointee.axis.2)
				AppInstance.mainVC.lblRotateX.stringValue    = String(state.pointee.axis.3)
				AppInstance.mainVC.lblRotateY.stringValue    = String(state.pointee.axis.4)
				AppInstance.mainVC.lblRotateZ.stringValue    = String(state.pointee.axis.5)
				break;
			case ConnexionClient.Cmd.HandleButtons:
				var outputString : String = ""
				for idx in 1...32{
                    if(CCH.Instance.isButtonActive(withId: UInt32(idx), inside: &state.pointee.buttons)){
						outputString += "- \(idx) -\n"
					}
				}
				AppInstance.mainVC.lblActiveBtns.stringValue = outputString
				break
			default:
                break
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
    } as! ConnexionMessageHandlerProc
