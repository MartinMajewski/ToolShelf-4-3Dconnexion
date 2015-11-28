//
//  ConnexionClientErrors.swift
//  ToolShelf-4-3Dconnexion
//
//  Created by Martin Majewski on 13.11.15.
//  Copyright © 2015 MartinMajewski.net. All rights reserved.
//

enum ConnexionClientError : ErrorType{
	case CFBundleSignatureNotValid
	case ClientIdAlreadySet
	case ClientIdInvalid(clientId : UInt16)
	case DriverNotFound
	case OSErr(osErrCode : Int16)
}