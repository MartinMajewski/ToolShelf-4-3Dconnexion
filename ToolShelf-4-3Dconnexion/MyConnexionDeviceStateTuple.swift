//
//  MyConnexionDeviceStateTuple.swift
//  3DconnexionStatsUtility
//
//  Created by Martin Majewski on 29.10.15.
//  Copyright © 2015 MartinMajewski.net. All rights reserved.
//

import Foundation

typealias MyConnexionDeviceStateTuple = (
	version:	UInt16,
	client:		UInt16,
	
	command:	UInt16,
	param:		Int16,
	value:		Int32,
	time:		UInt64,
	
	report:		(UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8),
	
	buttons8:	UInt16,
	axis:		(tx:Int16, ty:Int16, tz:Int16, rx:Int16, ry:Int16, rz:Int16),
	address:	UInt16,
	buttons:	UInt32);