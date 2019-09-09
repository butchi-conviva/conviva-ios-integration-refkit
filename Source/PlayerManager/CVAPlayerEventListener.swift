//
//  CVAPlayerEventListener.swift
//  CVAReferenceApp
//
//  Created by Butchi peddi on 03/09/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

protocol CVAPlayerEventListener : class {
  func onPlayerEvent(event:CVAPlayerEvent,info:[AnyHashable : Any]?);
}
