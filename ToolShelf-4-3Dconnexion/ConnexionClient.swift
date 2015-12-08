//
//  ConnexionClient.swift
//  ToolShelf-4-3Dconnexion
//
//  Created by Martin Majewski on 24.10.15.
//  Copyright © 2015 MartinMajewski.net. All rights reserved.
//

import Foundation

struct ConnexionClient{
    
    struct ClientMode{
        static let TakeOver : UInt16 = 1 // take over device completely, driver no longer executes assignments
        static let Plugin   : UInt16 = 2 // receive plugin assignments only, let driver take care of its own
    };
    
    //==============================================================================
    // Client commands
    
    // The following assignments must be executed by the client:
    struct Cmd{
        static let None             : UInt16 = 0
        static let HandleRawData    : UInt16 = 1
        static let HandleButtons    : UInt16 = 2
        static let HandleAxis       : UInt16 = 3
        static let AppSpecific      : UInt16 = 10
    };
    
    //==============================================================================
    // Messages
    
    // The following messages are forwarded to user space clients:
    struct Msg{
        static let DeviceState      : UInt32 = 862212946 // '3dSR' forwarded device state data
        static let PrefsChanged     : UInt32 = 862212163 // '3dPC' notify clients that the current app prefs have changed
        static let CalibrateDevice  : UInt32 = 862212931 // '3dSC' device state data to be used for calibration
    }
    
    // Control messages for the driver sent via the ConnexionControl API:
    struct Ctrl{
        static let SetLEDState  : UInt32 = 862221164 // '3dsl' set the LED state, param = (uint8_t)ledState
        static let GetDeviceID  : UInt32 = 862218596 // '3did' get vendorID and productID in the high and low words of the result
        static let Calibrate    : UInt32 = 862217057 // '3dca'calibrate the device with the current axes values (same as executing the calibrate assignment)
        static let Uncalibrate  : UInt32 = 862217317 // '3dde' uncalibrate the device (i.e. reset calibration to 0,0,0,0,0,0)
        static let OpenPrefPane : UInt32 = 862220144 // '3dop' open the 3dconnexion preference pane in System Preferences
        static let SetSwitches  : UInt32 = 862221171 // '3dss' set the current state of the client-controlled feature switches (bitmap, see masks below)
    }
    // Client capability mask constants (this mask defines which buttons and controls should be sent to clients, the others are handled by the driver)
    
    struct Mask{
        static let Button1    : UInt32 = 0x0001
        static let Button2    : UInt32 = 0x0002
        static let Button3    : UInt32 = 0x0004
        static let Button4    : UInt32 = 0x0008
        static let Button5    : UInt32 = 0x0010
        static let Button6    : UInt32 = 0x0020
        static let Button7    : UInt32 = 0x0040
        static let Button8    : UInt32 = 0x0080
        
        static let Axis1      : UInt32 = 0x0100
        static let Axis2      : UInt32 = 0x0200
        static let Axis3      : UInt32 = 0x0400
        static let Axis4      : UInt32 = 0x0800
        static let Axis5      : UInt32 = 0x1000
        static let Axis6      : UInt32 = 0x2000
        
        static let Buttons    : UInt32 = 0x00FF // note: this only specifies the first 8 buttons, kept for backwards compatibility
        static let AxisTrans  : UInt32 = 0x0700
        static let AxisRot    : UInt32 = 0x3800
        static let Axis       : UInt32 = 0x3F00
        static let All        : UInt32 = 0x3FFF
        
        // Added in version 10:0 to support all 32 buttons on the SpacePilot Pro, use with the new SetConnexionClientButtonMask API
        // Although being a 64bit value 3Dconnexion uses a uint32_t type. Bug?
		
        static let Button9      : UInt64 = 0x00000100
        static let Button10     : UInt64 = 0x00000200
        static let Button11     : UInt64 = 0x00000400
        static let Button12     : UInt64 = 0x00000800
        static let Button13     : UInt64 = 0x00001000
        static let Button14     : UInt64 = 0x00002000
        static let Button15     : UInt64 = 0x00004000
        static let Button16     : UInt64 = 0x00008000
        
        static let Button17     : UInt64 = 0x00010000
        static let Button18     : UInt64 = 0x00020000
        static let Button19     : UInt64 = 0x00040000
        static let Button20     : UInt64 = 0x00080000
        static let Button21     : UInt64 = 0x00100000
        static let Button22     : UInt64 = 0x00200000
        static let Button23     : UInt64 = 0x00400000
        static let Button24     : UInt64 = 0x00800000
        
        static let Button25     : UInt64 = 0x01000000
        static let Button26     : UInt64 = 0x02000000
        static let Button27     : UInt64 = 0x04000000
        static let Button28     : UInt64 = 0x08000000
        static let Button29     : UInt64 = 0x10000000
        static let Button30     : UInt64 = 0x20000000
        static let Button31     : UInt64 = 0x40000000
        static let Button32     : UInt64 = 0x80000000
		
		// Have to cast this UInt64 value to UIn32... This is weird!!!
        
        static let AllButtons   : UInt64 = 0xFFFFFFFF
    }
    
    // Masks for client-controlled feature switches
	/*
		Driver uses a 32 bit-mask to (de-)activate axis and the dominant mode
		
		Only the first 16 bits from the lsb upwards are used so far
		
		Dominant: 0000 0010
		
		Translation Axis:
			Axis 1 (Tx): 0000 0100
			Axis 2 (Ty): 0000 1000
			Axis 3 (Tz): 0001 0000
	
		Rotatio  Axis:
			Axis 4 (Rx): 0010 0000
			Axis 5 (Ry): 0100 0000
			Axis 6 (Rz): 1000 0000
	
		EnableTrans, EnableRot and EnableAll are simply accumulated bit-masks of the above patterns
	
		EnableTrans:	 0001 1100
		EnableRot:		 1110 0000
		EnableAll:		 1111 1100
	
		The AllDisabled field is a little bit odd, because it is actually an 64bit integer value with the msb set to 1.
		The msb inside a signed integer variable is the sign bit. The current value stands for the
	*/
    struct Switch{
        static let Dominant       : Int32 = 0x0002
        static let EnableAxis1    : Int32 = 0x0004
        static let EnableAxis2    : Int32 = 0x0008
        static let EnableAxis3    : Int32 = 0x0010
        static let EnableAxis4    : Int32 = 0x0020
        static let EnableAxis5    : Int32 = 0x0040
        static let EnableAxis6    : Int32 = 0x0080
        
        static let EnableTrans    : Int32 = 0x001C
        static let EnableRot      : Int32 = 0x00E0
        static let EnableAll      : Int32 = 0x00FC
        
        static let AllDisabled     : Int64 = 0x80000000 // use driver defaults instead of client-controlled switches
    }
	
	//==============================================================================
	// Device state record
	
	// Structure type and current version:
	static let DeviceStateType : UInt32 = 0x4D53 // 'MS' (Connexion State)
	static let DeviceStateVers : UInt32 = 0x6D33 // 'm3' (version 3 includes 32-bit button data in previously unused field, binary compatible with version 2)
	
	//==============================================================================
	// Device prefs record
	
	// Structure type and current version:
	static let DevicePrefsType : UInt32 = 0x4D50 // 'MP' (Connexion Prefs)
	static let DevicePrefsVers : UInt32 = 0x7031 // 'p1' (version 1)
	
	//==============================================================================
	
}

