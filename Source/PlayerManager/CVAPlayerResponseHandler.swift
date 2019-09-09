//
//  CVAPlayerResponseHandler.swift
//  CVAReferenceApp
//
//  Created by Butchi peddi on 03/09/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

public protocol CVAPlayerResponseHandler : class {
  
  func onPlayerCommandComplete(command:CVAPlayerCommand,status:CVAPlayerStatus,info:[AnyHashable : Any]!);
  
  func onPlayerEvent(event:CVAPlayerEvent,info:[AnyHashable : Any]);
}
