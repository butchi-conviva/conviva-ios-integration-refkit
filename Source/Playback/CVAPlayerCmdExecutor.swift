//
//  CVAPlayerCmdExecutor.swift
//  ConvivaIntegrationRefKit
//
//  Created by Butchi peddi on 04/09/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

import Foundation

@objc public protocol CVAPlayerCmdExecutor : class {
    
    func handleEvent(_ eventName: String!, info: [AnyHashable : Any]!);
    
}
