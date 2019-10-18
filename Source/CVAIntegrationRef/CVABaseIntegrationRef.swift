//
//  ConvivaBase.swift
//  ConvivaIntegrationRefKit
//
//  Created by Gaurav Tiwari on 25/09/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

import Foundation

protocol CVABaseIntegrationRef {
    
    // Conviva Setup
    static func setupConvivaMonitoring()
    static func cleanupConvivaMonitoring()
    var logLevel : Bool {get set}
    
    // Conviva Session
    func createSession(player: Any, metadata: [String : Any])
    func cleanupSession()
    func attachPlayer()
    func detachPlayer()
    
    // Conviva Advanced Metadata
    func sendCustomEvent()
    func sendCustomError()
    func sendCustomWarning()
    func updateContentMetadata()
    func seekStart(position:NSInteger)
    func seekEnd(position:NSInteger)
}

extension CVABaseIntegrationRef {
    var logLevel : Bool {
        set {
            logLevel = false
        }
        get {
            return false
        }
    }
}

protocol CVAAVPlayerEvents {
    
}
