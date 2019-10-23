//
//  CVAPlayerEventManager.swift
//  CVAReferenceApp
//
//  Created by Butchi peddi on 03/09/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

public class CVAPlayerEventManager : NSObject {
  
  private var eventEmitter:CVAPlayerEventNotifier;
  
  public init(eventEmitter:CVAPlayerEventNotifier) {
    
    self.eventEmitter = eventEmitter;
    
    super.init()
  }
}

extension CVAPlayerEventManager : CVAPlayerEventListener {
  func onPlayerEvent(event: CVAPlayerEvent, info: [AnyHashable : Any]?) {
    self.eventEmitter.sendEvent(event: event, info: info);
  }
}
