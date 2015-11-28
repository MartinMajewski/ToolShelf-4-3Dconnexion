//
//  ViewController.swift
//  ToolShelf-4-3Dconnexion
//
//  Created by Martin Majewski on 21.10.15.
//  Copyright © 2015 MartinMajewski.net. All rights reserved.
//

import Cocoa

public class VCMainView: NSViewController {
	@IBOutlet var lblTranslateX: NSTextField!
	@IBOutlet var lblTranslateY: NSTextField!
	@IBOutlet var lblTranslateZ: NSTextField!
	
	@IBOutlet var lblRotateX: NSTextField!
	@IBOutlet var lblRotateY: NSTextField!
	@IBOutlet var lblRotateZ: NSTextField!
	
	@IBOutlet var lblActiveBtns: NSTextField!
	
	@IBOutlet var tfActiveDevice: NSTextField!
	@IBOutlet var tfConnectedDevices: NSTextFieldCell!
	
	private let connexionCH = CCH.Instance
	
	lazy var vcDriverNotInstalled: NSViewController = {
		return self.storyboard!.instantiateControllerWithIdentifier("StrbrdIdDriverError") as! NSViewController
	}()
	
	func printConnectedDevicesFrom(Dictonary cdd : [UInt32: String], sorted: Bool = false) -> Void {
		var output : String = ""
		
		func appendLineFrom(deviceId id: UInt32, DeviceName value: String) -> Void{
			output.appendContentsOf("\(id) - \(value)\n")
		}
		
		if sorted{
			let sortedConnectedDevices = cdd.sort({$0.0 < $1.0})
			
			for (id, name) in sortedConnectedDevices {
				appendLineFrom(deviceId: id, DeviceName: name)
			}
		}else{
			for (id, name) in cdd {
				appendLineFrom(deviceId: id, DeviceName: name)
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
					connexionCH.set(AxisMode: CCH.AxisMode.DominantMode, On: true)
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
		
		AppInstance.mainVC = self
	}
	
	override public func viewDidAppear() {
		
		do{
			try connexionCH.start(MsgHandlerClosure: messageHandler, AddedHandlerClosure: addedHandler, RemovedHandlerClosure: removedHandler)
		}catch(ConnexionClientError.OSErr(let osErrCode)){
			print("OSErr code: \(osErrCode)")
		}catch ConnexionClientError.ClientIdInvalid(let clientId){
			print("ClientId is not valid \(clientId)")
		}catch ConnexionClientError.ClientIdAlreadySet{
			print("ClientId is already set")
		}catch ConnexionClientError.CFBundleSignatureNotValid{
			print("App Bundle Signature not valid")
		}catch ConnexionClientError.DriverNotFound{
			print("3Dconnexion driver not found!")
			self.presentViewControllerAsSheet(vcDriverNotInstalled)
		}catch{
			print("An unknownerror occured")
		}
	}
	
	override public func viewDidDisappear() {
		do{
			try connexionCH.stop()
		}catch{
			print("ViewController disappears without ConnexionClient cleanup. There was probably a problem with the driver!")
		}
	}
}

