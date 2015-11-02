//
//  ConnexionAuxiliaries.swift
//  3DconnexionStatsUtility
//
//  Created by Martin Majewski on 01.11.15.
//  Copyright © 2015 MartinMajewski.net. All rights reserved.
//

import Foundation

struct ConnexionAuxiliaries{
	
	static func GetStringFrom(DeviceState ds: ConnexionDeviceState) -> String!{
		return "--------------------------\n" +
			"Version:\t\(ds.version)\n" +
			"Client:\t\(ds.client)\n" +
			"Command:\t\(ds.command)\n" +
			"Param:\t\(ds.param)\n" +
			"Value:\t\(ds.value)\n" +
			"Time:\t\(ds.time)\n" +
			"Report:\t\(ds.report)\n" +
			"Buttons8:\t\(ds.buttons8)\n" +
			"Axis:\t\(ds.axis)\n" +
			"Address:\t\(ds.address)\n" +
		"Buttons:\t\(ds.buttons)"
	}

}

