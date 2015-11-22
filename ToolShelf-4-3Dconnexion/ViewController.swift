//
//  ViewController.swift
//  3DconnexionStatsUtility
//
//  Created by Martin Majewski on 21.10.15.
//  Copyright © 2015 MartinMajewski.net. All rights reserved.
//

import Cocoa

public class ViewController: NSViewController {
	static let appInstance = NSApplication.sharedApplication().delegate as! AppDelegate
	
	@IBOutlet var lblTranslateX: NSTextField!
	@IBOutlet var lblTranslateY: NSTextField!
	@IBOutlet var lblTranslateZ: NSTextField!
	
	@IBOutlet var lblRotateX: NSTextField!
	@IBOutlet var lblRotateY: NSTextField!
	@IBOutlet var lblRotateZ: NSTextField!
	
	@IBOutlet var lblActiveBtns: NSTextField!
	@IBOutlet var lblActiveDevice: NSTextFieldCell!
	
	@IBOutlet var tfConnectedDevices: NSTextFieldCell!
	
	private let connexionCH = CCH.Instance
	
	private var connectedDevicesDictonary = [UInt32: String]()

	
	let myMessageHandler : ConnexionMessageHandlerProc = { (deviceID: UInt32, msgType: UInt32, var msgArgPtr: UnsafeMutablePointer<Void>) -> Void in
//		print("Inside myMessageHandler")
		
		switch(msgType){
		case ConnexionClient.Msg.DeviceState:
//			print("Inside ConnexionClient.Msg.DeviceState")
			
			let state = (UnsafeMutablePointer<ConnexionDeviceState>(msgArgPtr)).memory
			
			if state.client == CCH.Instance.ClientId {
				
				var result = UnsafeMutablePointer<Int32>()
				
				let id = UInt32(CCH.Instance.getDeviceID())
				let name = ViewController.appInstance.mainVC.connectedDevicesDictonary[id]
				ViewController.appInstance.mainVC.lblActiveDevice.stringValue = "\(id) - \(name!)"
				
				switch(state.command){
				case ConnexionClient.Cmd.HandleAxis:
					
					ViewController.appInstance.mainVC.lblTranslateX.stringValue = String(state.axis.0)
					ViewController.appInstance.mainVC.lblTranslateY.stringValue = String(state.axis.1)
					ViewController.appInstance.mainVC.lblTranslateZ.stringValue = String(state.axis.2)
					ViewController.appInstance.mainVC.lblRotateX.stringValue	= String(state.axis.3)
					ViewController.appInstance.mainVC.lblRotateY.stringValue	= String(state.axis.4)
					ViewController.appInstance.mainVC.lblRotateZ.stringValue	= String(state.axis.5)
					
					break;
					
				case ConnexionClient.Cmd.HandleButtons:
					
					var outputString : String = ""
					
					for idx in 1...32{
						if(CCH.Instance.IsButtonActive(withId: UInt32(idx), inside: state.buttons)){
							outputString += "- \(idx) -\n"
						}
						
					}
					
					ViewController.appInstance.mainVC.lblActiveBtns.stringValue = outputString
					
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
	
	let myAddedHandler : ConnexionAddedHandlerProc = {(deviceID : UInt32) -> Void in
		print("Device added with ID \(deviceID)")
		
		if let device = CCH.DeviceDictonary[deviceID]{
			ViewController.appInstance.mainVC.connectedDevicesDictonary[deviceID] = device
		}else{
			ViewController.appInstance.mainVC.connectedDevicesDictonary[deviceID] = "Unknown"
		}
		ViewController.appInstance.mainVC.printConnectedDevices(true)
		
	}
	
	let myRemovedHandler : ConnexionRemovedHandlerProc = {(deviceID : UInt32) -> Void in
		print("Device removed with ID \(deviceID)")
		
		ViewController.appInstance.mainVC.connectedDevicesDictonary[deviceID] = nil
		
		ViewController.appInstance.mainVC.printConnectedDevices(true)
	}
	
	func printConnectedDevices(sorted: Bool = false) -> Void {
		var output : String = ""
		
		func appendLineFrom(DeviceId id: UInt32, DeviceName value: String) -> Void{
			output.appendContentsOf("\(id) - \(value)\n")
		}
		
		if sorted{
			let sortedConnectedDevices = connectedDevicesDictonary.sort({$0.0 < $1.0})
			
			for (id, name) in sortedConnectedDevices {
				appendLineFrom(DeviceId: id, DeviceName: name)
			}
		}else{
			for (id, name) in connectedDevicesDictonary {
				appendLineFrom(DeviceId: id, DeviceName: name)
			}
		}
		
		tfConnectedDevices.stringValue = output
	}
	
	
	@IBAction func cofigureAxis(sender: NSButton) {
		if let identifier = sender.identifier {
			print("Identifier: \(identifier)")
			
			switch identifier{
			case "cbDominantMode":
				if(sender.state == NSOnState){
					connexionCH.set(AxisMode: CCH.AxisMode.DominantMode)
				}else{
					connexionCH.set(AxisMode: CCH.AxisMode.DominantMode, On: false)
				}
				break
			case "rbAxisAll":
				connexionCH.set(AxisMode: CCH.AxisMode.AllAxis)
				break
			case "rbAxisTranslation":
				connexionCH.set(AxisMode: CCH.AxisMode.TranslationOnly)
				break
			case "rbAxisRotation":
				connexionCH.set(AxisMode: CCH.AxisMode.RotationOnly)
				break
			case "rbAxisDisabled":
				connexionCH.set(AxisMode: CCH.AxisMode.DisableAllAxis)
				break
			default:
				break
			}
		}
	}
	
	@IBAction func btnOpenPrefPane(sender: AnyObject) {
		connexionCH.openPreferencesPane()
	}
	
	override public func viewDidLoad() {
		super.viewDidLoad()
		
		ViewController.appInstance.mainVC = self
	}
	
	override public func viewDidAppear() {
		do{
			try connexionCH.start(MsgHandlerClosure: myMessageHandler, AddedHandlerClosure: myAddedHandler, RemovedHandlerClosure: myRemovedHandler)
		}catch{
			print("An error occured")
		}
	}
	
	override public func viewDidDisappear() {
		connexionCH.stop()
		
		NSApplication.sharedApplication().terminate(self)
	}
}

