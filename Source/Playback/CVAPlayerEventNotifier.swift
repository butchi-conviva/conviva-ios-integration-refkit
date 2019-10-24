//
//  CVAPlayerEventNotifier.swift
//  ConvivaIntegrationRefKit
//
//  Created by Butchi peddi on 04/09/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

import Foundation

public protocol CVAPlayerEventNotifier {
    func sendEvent(event: CVAPlayerEvent, info: [AnyHashable : Any]?)
}
