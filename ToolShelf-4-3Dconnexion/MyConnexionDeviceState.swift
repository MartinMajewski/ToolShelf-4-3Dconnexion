//
//  ConnexionDeviceState.swift
//  3DconnexionStatsUtility
//
//  Created by Martin Majewski on 25.10.15.
//  Copyright © 2015 MartinMajewski.net. All rights reserved.
//

struct MyConnexionDeviceState{
    
    // header
    var version  : UInt16 = 0    // kConnexionDeviceStateVers
    var client   : UInt16 = 0   // identifier of the target client when sending a state message to all user clients
    
    // command
    var command  : UInt16 = 0   // command for the user-space client
    var param    : Int16 = 0    // optional parameter for the specified command
    var value    : Int32 = 0    // optional value for the specified command
    
    var time     : UInt64 = 0xFFFFFFFF // timestamp for this message (clock_get_uptime)
    
    // raw report
	let report   = [UInt8] (count: 8, repeatedValue: 0)// raw USB report from the device
    
    // process data
    var buttons8 : UInt16 = 0   // buttons (first 8 buttons only, for backwards binary compatibility- use "buttons" field instead)
    
    let axis     : (tx:Int16, ty:Int16, tz:Int16, rx:Int16, ry:Int16, rz:Int16)  // x, y, z, rx, ry, rz
    
    var address  : UInt16 = 0   // USB device address, used to tell one device from the other
    var buttons  : UInt32 = 0   // buttons
}