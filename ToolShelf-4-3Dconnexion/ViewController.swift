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
	
	@IBOutlet var WtfCurrentPref: NSTextFieldCell!
	
    
    private var clientID : UInt16?
    
//    var ClientID : UInt16 {
//        get{
//            if clientID == nil{
//                return 0;
//            }else{
//                return clientID!
//            }
//        }
//        set{
//            clientID! = newValue
//        }
//    }
	
    func start3DMouse() -> OSErr{
        
        if clientID == 0{
            return 0
        }
        
        /** TODO - weak importing for handling a not installed driver */
        let result : OSErr = SetConnexionHandlers(myMessageHandler, myAddedHandler, myRemovedHandler, false)
        
        if(result != 0){
            return result
        }
        
        if let appSignature = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleSignature") as? String{
            clientID = RegisterConnexionClient(ConnexionClient.GetOSTypeCodeFrom(appSignature), nil, ConnexionClient.ClientMode.TakeOver, ConnexionClient.Mask.All)
            
            if clientID == nil{
                return -1
            }
            
            SetConnexionClientButtonMask(clientID!, (UInt32)(ConnexionClient.Mask.AllButtons));
			SetConnexionClientMask(clientID!, ConnexionClient.Mask.All)
            print("ClientID: \(clientID!)")
            
        }else{
            return -1;
        }
        
        return result
    }
    
    func stop3DMouse(){
        print("Stopping 3D Mouse for client ID \(clientID!) and cleaning up")
        UnregisterConnexionClient(clientID!)
        CleanupConnexionHandlers()
        
        clientID = nil
    }
    
    let myMessageHandler : ConnexionMessageHandlerProc = { (deviceID : UInt32, msgType : UInt32, var msgArgPtr : UnsafeMutablePointer<Void>) -> Void in
        
//        let clientID = ViewController.appInstance.mainVC?.ClientID
//        
//        if (clientID == nil) || clientID! == 0{
//            return
//        }
		
		let clientID = ViewController.appInstance.mainVC?.clientID
		
		if clientID == nil {
			return
		}
		
        switch(msgType){
        case ConnexionClient.Msg.DeviceState:

            let state = (UnsafeMutablePointer<ConnexionDeviceState>(msgArgPtr)).memory
				
            if state.client == clientID!{
                
                switch(state.command){
                case ConnexionClient.Cmd.HandleAxis:
                    
                    ViewController.appInstance.mainVC.lblTranslateX.stringValue = String(state.axis.0)
                    ViewController.appInstance.mainVC.lblTranslateY.stringValue = String(state.axis.1)
                    ViewController.appInstance.mainVC.lblTranslateZ.stringValue = String(state.axis.2)
                    ViewController.appInstance.mainVC.lblRotateX.stringValue = String(state.axis.3)
                    ViewController.appInstance.mainVC.lblRotateY.stringValue = String(state.axis.4)
                    ViewController.appInstance.mainVC.lblRotateZ.stringValue = String(state.axis.5)

                    break;
                    
                case ConnexionClient.Cmd.HandleButtons:
                    
                    var outputString : String = ""
                    
                    for idx in 1...32{
                        if(ConnexionClient.IsButtonActive(withId: UInt32(idx), inside: state.buttons)){
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
			
			
			ViewController.appInstance.mainVC.printDevicePrefs(deviceID)
			
            break;
        case ConnexionClient.Msg.CalibrateDevice:
            print("Inside ConnexionClient.Msg.CalibrateDevice")
			
            ViewController.appInstance.mainVC.printDevicePrefs(deviceID)
            
            break;
        default:
            // Ignoring other message types
            break;
        }
    }
    
    let myAddedHandler : ConnexionAddedHandlerProc = {(deviceID : UInt32) -> Void in
        print("Device added with ID \(deviceID)");
		
		ViewController.appInstance.mainVC.printDevicePrefs(deviceID)
    }
    
    let myRemovedHandler : ConnexionRemovedHandlerProc = {(deviceID : UInt32) -> Void in
        print("Device removed with ID \(deviceID)");
		
		ViewController.appInstance.mainVC.printDevicePrefs(deviceID)
    }
	
	public func printDevicePrefs(deviceID : UInt32) -> Void{
		WtfCurrentPref.stringValue = ""
		
		var prefs : ConnexionDevicePrefs = ConnexionDevicePrefs();
		
		let result = ConnexionGetCurrentDevicePrefs(deviceID, &prefs)
		
		let prefString : String = "" +
			"deviceID: \(deviceID)\n" +
			"result: \(result)\n" +
			"prefs.deviceID: \(prefs.deviceID)\n" +
			"Type: \(prefs.type)\n" +
			"Version: \(prefs.version)\n" +
			"AppSignature: \(prefs.appSignature)\n" +
			//			"AppName: \(prefs.appName)\n" +
			"MainSpeed: \(prefs.mainSpeed)\n" +
			"ZoomOnY: \(prefs.zoomOnY)\n" +
			"Dominant: \(prefs.dominant)\n" +
			"MapV: \(prefs.mapV)\n" +
			"MapH: \(prefs.mapH)\n" +
			"Axis enabled: \(prefs.enabled)\n" +
			"Speed: \(prefs.speed)\n" +
			"Sensivity: \(prefs.sensitivity)\n" +
			"Scale: \(prefs.scale)\n" +
			"Gama: \(prefs.gamma)\n" +
			"Intersect: \(prefs.intersect)";
		
		WtfCurrentPref.stringValue = prefString
	}
	
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        ViewController.appInstance.mainVC = self
    }
    
    override public func viewDidAppear() {
        start3DMouse()
    }
    
    override public func viewDidDisappear() {
        stop3DMouse()
        
        NSApplication.sharedApplication().terminate(self)
    }
    
    
}

