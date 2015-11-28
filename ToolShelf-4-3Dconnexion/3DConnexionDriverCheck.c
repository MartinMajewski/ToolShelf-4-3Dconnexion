//
//  weak_link.cpp
//  ToolShelf-4-3Dconnexion
//
//  Created by Martin Majewski on 24.11.15.
//  Copyright © 2015 MartinMajewski.net. All rights reserved.
//

#include "3Dconnexion-Bridging-Header.h"

extern int16_t SetConnexionHandlers(
									ConnexionMessageHandlerProc messageHandler,
									ConnexionAddedHandlerProc addedHandler,
									ConnexionRemovedHandlerProc removedHandler,
									bool useSeparateThread) __attribute__((weak_import));



bool isConnexionDriverAvailable(){

	return (SetConnexionHandlers != NULL);
	
}
