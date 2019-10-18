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
    
    /**
     Used to setup Conviva monitoring.
     */
    static func setupConvivaMonitoring()
    
    /**
     Used to cleanup Conviva monitoring.
     */
    static func cleanupConvivaMonitoring()
    
    /**
     Used to define the level of logs to be printed.
     - Value:
        - set either True or False
     */
    var logLevel : Bool {get set}
    
    // Conviva Session
    
    /**
     Used to create a Conviva monitoring session.
     
     - Parameters:
        - player: The streamer instance which needs to be monitored
        - metadata: The initial set of metadata values related to a video playback
     */
    func createSession(player: Any, metadata: [String : Any])
    
    /**
     Used to cleanup a Conviva monitoring session.
     */
    func cleanupSession()
    
    /**
     Used to attach a streamer instance which can be monitored.
     */
    func attachPlayer()
    
    /**
     Used to detach the earlier attached streamer instance.
     */
    func detachPlayer()
    
    // Conviva Advanced Metadata
    
    /**
     Used to send a custom event e.g. PodStart or PodEnd events to Conviva.
     */
    func sendCustomEvent()
    
    /**
     Used to send a custom error to Conviva.
     */
    func sendCustomError()
    
    /**
     Used to send a custom warning to Conviva.
     */
    func sendCustomWarning()
    
    /**
     Used to update the earlier set ConvivaContentInfo values.
     */
    func updateContentMetadata()
    
    /**
     Used to report start of seek event.
     - Parameters:
        - position: seek start position
     */
    func seekStart(position:NSInteger)
    
    /**
     Used to report end of seek event.
     - Parameters:
     - position: seek end position
     */
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
