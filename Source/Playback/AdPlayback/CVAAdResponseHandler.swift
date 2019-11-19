//
//  CVAAdPlayerResponseHandler.swift
//  ConvivaIntegrationRefKit
//
//  Created by Butchi peddi on 19/11/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

import Foundation


public protocol CVAAdResponseHandler : class {
  
  func onAdCommandComplete(command:CVAAdPlayerCommand,status:CVAPlayerStatus,info:[AnyHashable : Any]!);
  
  func onAdEvent(event:CVAPlayerEvent,info:[AnyHashable : Any]);
}
