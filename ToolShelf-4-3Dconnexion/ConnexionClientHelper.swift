//
//  ConnexionClientAPI.swift
//  ToolShelf-4-3Dconnexion
//
//  Created by Martin Majewski on 13.11.15.
//  Copyright © 2015 MartinMajewski.net. All rights reserved.
//

import Cocoa

typealias CCH = ConnexionClientHelper

class ConnexionClientHelper {
	// ==============================================================================
	// Singleton Pattern
	private static let instance : ConnexionClientHelper = ConnexionClientHelper();
	
	static var Instance : ConnexionClientHelper{
		get{
			return instance
		}
	}
	
	private init(){
		
	}
	
	// =============================================================================
	// Dictonary of device Ids and device names as found on
	// http://www.3dconnexion.de/index.php?id=200&faq_red=faq/27
	// Device Ids are integer equivalents of the hexcode PID values
	static let DeviceDictonary : [UInt32: String] = [
		50691: "SpaceMouse Plus (XT) USB",
		50693: "CadMan",
		50694: "SpaceMouse Classic USB",
		50721: "SpaceBall 5000 USB",
		50723: "SpaceTraveler",
		50725: "SpacePilot",
		50726: "SpaceNavigator",
		50727: "SpaceExplorer",
		50728: "SpaceNavigator for Notebooks",
		50729: "SpacePilot Pro",
		50731: "SpaceMouse Pro (wired)",
		50734: "SpceMouse (cabled)",
		50735: "SpceMouse (wireless)",
		50737: "SpceMouse Pro (cabled)",
		50738: "SpceMouse Pro (wireless)",
		50741: "SpaceMouse Compact (wired)",
		50768: "CADMouse (wired)"]
	
	// ==============================================================================
	// Start driver connection
	
	private var clientId : UInt16 = 0
	
    func start(MsgHandlerClosure msgHandler : @escaping ConnexionMessageHandlerProc, AddedHandlerClosure addHandler : @escaping ConnexionAddedHandlerProc, RemovedHandlerClosure remHandler : @escaping ConnexionRemovedHandlerProc ) throws -> Void{
		
		// Check if 3Dconnexion driver is present or else throw exception
		guard isConnexionDriverAvailable() == true else { throw ConnexionClientError.DriverNotFound }
		
		// Avoid multiple starts
		guard clientId == 0 else { throw ConnexionClientError.ClientIdAlreadySet }
		
		
		let error = SetConnexionHandlers(msgHandler, addHandler, remHandler, false)
		
		guard error == 0 else { throw ConnexionClientError.OSErr(osErrCode: error) }
		
        if let appSignature = Bundle.main.object(forInfoDictionaryKey: "CFBundleSignature") as? String{
			clientId = RegisterConnexionClient(ConnexionClientHelper.Instance.GetUInt32ValueFrom(String: appSignature), nil, ConnexionClient.ClientMode.TakeOver, ConnexionClient.Mask.All)
			
			guard clientId != 0 else { throw ConnexionClientError.ClientIdInvalid(clientId: clientId) }
			
			SetConnexionClientButtonMask(clientId, (UInt32)(ConnexionClient.Mask.AllButtons));
			SetConnexionClientMask(clientId, ConnexionClient.Mask.All)
			set(AxisMode: AxisMode.AllAxis, On: true)
			
			print("clientId: \(clientId)")
			
		}else{
			throw ConnexionClientError.CFBundleSignatureNotValid
		}
	}
	
	// ==============================================================================
	// Start driver connection
	
	func stop() throws -> Void{
		// Check if 3Dconnexion driver is present or else throw exception
		guard isConnexionDriverAvailable() == true else { throw ConnexionClientError.DriverNotFound }
		
		print("Stopping 3D Mouse for client ID \(clientId) and cleaning up")
		UnregisterConnexionClient(clientId)
		CleanupConnexionHandlers()
		
		clientId = 0
	}
	
	var ClientId : UInt16{
		get{
			return clientId
		}
	}
	
	// ==============================================================================
	// Device Configuration
	
	var connectedDevicesDictonary = [UInt32: String]()
	
	// Helper members to monitor and configure device state
	private var currentSwitchConfigState = ConnexionClient.Switch.EnableAll
	
	/* Turn a switch on or off.
	|| Because a switch can contain one axis or an axis-set we have to perform an OR operation eiter at the ON and OFF case to ensure that all bits of the switch are set to 1.
	|| If the switch should be turned off every bit related to the switch has to be flipped to 0 inside the currentSwitchConfigState variable.
	|| This is accomplished by XOR, which depends on having the 1s set in both fields, what is ensured by the previously OR operation.
	|| Having a 1 inside just the switch or the currentSwitchConfigState would lead to an 1 in the result.
	*/
	private func turnModeFor(Switch sw: Int32, On on : Bool){
		currentSwitchConfigState = sw | currentSwitchConfigState
		if !on{
			currentSwitchConfigState = sw ^ currentSwitchConfigState
		}
		
		ConnexionClientControl(ClientId, ConnexionClient.Ctrl.SetSwitches, currentSwitchConfigState, nil)
	}
	
	func isStateActiveFor(Switch sw : Int32) -> Bool{
		return (sw & currentSwitchConfigState) != 0
	}
	
	enum AxisMode{
		case DisableAllAxis
		case DominantMode
		case AllAxis
		case RotationOnly
		case TranslationOnly
	}
	
	func set(AxisMode am : AxisMode, On on : Bool = true) -> Void{
		switch am {
		case .DominantMode:
			turnModeFor(Switch: ConnexionClient.Switch.Dominant, On: on)
			print("Dominant Mode: \(isStateActiveFor(Switch: ConnexionClient.Switch.Dominant))")
			
		case .DisableAllAxis:
			turnModeFor(Switch: ConnexionClient.Switch.EnableAll, On: false)
			print("All Axis Mode: \(isStateActiveFor(Switch: ConnexionClient.Switch.EnableAll))")
			
		case .AllAxis:
			turnModeFor(Switch: ConnexionClient.Switch.EnableAll, On: on)
			print("All Axis Mode: \(isStateActiveFor(Switch: ConnexionClient.Switch.EnableAll))")
			
		case .RotationOnly:
			turnModeFor(Switch: ConnexionClient.Switch.EnableTrans, On: false)
			turnModeFor(Switch: ConnexionClient.Switch.EnableRot, On: true)
			print("Rotation Only Mode: \(isStateActiveFor(Switch: ConnexionClient.Switch.EnableRot))")
			
		case .TranslationOnly:
			turnModeFor(Switch: ConnexionClient.Switch.EnableRot, On: false)
			turnModeFor(Switch: ConnexionClient.Switch.EnableTrans, On: true)
			print("Translation Only Mode: \(isStateActiveFor(Switch: ConnexionClient.Switch.EnableTrans))")
			
		}
	}
	
	// ==============================================================================
	// Helper functions - C Utilities to interact with driver
	
	let BitMaskOne : UInt32 = 0x0001
	
	// Convert a Swift String into a UInt32 C like four-characters encoding used e.g. inside the RegisterConnexionClient() function
	func GetUInt32ValueFrom(String string : String) -> UInt32 {
		var result : UInt32 = 0
        if let data = string.data(using: String.Encoding.macOSRoman) {
            for i in 0..<data.count {
				result = result << 8 + UInt32(data[i])
			}
		}
		
		//print("\(string) results in \(result)")
		return result
	}
	
	
    func getArrayOfButtons(buttons : inout UInt32) -> [Bool]{
		
        var btnDictonary = [Bool](repeating: false, count: 32)
		
		for bitIdx in 0...31{
			if (buttons & BitMaskOne) == BitMaskOne{
				btnDictonary[bitIdx] = true;
			}
			
			buttons = buttons >> 1
		}
		
		return btnDictonary
	}
	
	func getDeviceID() -> Int32{
		var result : Int32 = 0
		
		ConnexionControl(ConnexionClient.Ctrl.GetDeviceID, 0, &result)
		
		return result & 0xFFFF
	}
	
	func openPreferencesPane() -> Void{
		ConnexionClientControl(ClientId, ConnexionClient.Ctrl.OpenPrefPane, 0, nil)
	}
	
	
    func isButtonActive(withId id: UInt32, inside buttons: inout UInt32) -> Bool{
		buttons = buttons >> (id - 1)
		return (buttons & BitMaskOne) == BitMaskOne
	}
	
}
