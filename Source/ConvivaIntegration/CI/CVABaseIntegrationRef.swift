//
//  ConvivaBase.swift
//  ConvivaIntegrationRefKit
//
//  Created by Gaurav Tiwari on 25/09/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

import Foundation
import ConvivaCore

/// A protocol used to keep all methods used for Conviva AVPlayer integration.
protocol CVABaseIntegrationRef {
    
    // MARK: Conviva Setup - Functions/variables responsible for Conviva monitoring setup.
    
    /**
     Used to initialize Conviva monitoring.
     */
    static func initialize()
    
    /**
     Used to cleanup Conviva monitoring.
     */
    static func cleanup()
    
    /**
     Used to define the level of logs to be printed. Set either True or False
     */
    var logLevel : Bool {get set}
    
    // MARK: Conviva session management - Functions/variables responsible for Conviva session management.

    /**
     Used to create a Conviva monitoring session.
     - Parameters:
        - player: The streamer instance which needs to be monitored
        - metadata: The initial set of metadata values related to a video playback.
                    If the initial values are not available, this paramter can be nil as well.
                    If the values need to be updated later, please use updateContentMetadata.
     */
    func createContentSession(player: Any, metadata: [String : Any]?)
    
    /**
     Used to cleanup a Conviva monitoring session.
     */
    func cleanupContentSession()

    /**
     Used to attach a streamer instance which can be monitored.
     - Parameters:
        - player: The streamer instance which needs to be monitored.
     */
    func attachPlayer(player: Any)

    /**
     Used to detach the earlier attached streamer instance.
     It should be called when a streamer object has been attached using attachPlayer earlier.
     */
    func detachPlayer()
    
    // MARK: Conviva advanced metadata - Functions/variables responsible for managing advanced metadata & events.
    
    /**
     Used to send a custom event e.g. PodStart or PodEnd events to Conviva.
     You may send a custom Player Insight event that is or is not associated with a monitoring session.
     - Parameters:
        - eventName: Event name of type String
        - eventAttributes: Event Attributes of type Dictionary
     */
    func sendCustomEvent(eventName: String, eventAttributes : [String : String])

    /**
     Used to send a custom error to Conviva.
     - Parameters:
        - error: An error instance of type Error. The localizedDescription of this error is sent to Conviva.
     */
    func sendCustomError(error : Error)

    /**
     Used to send a custom warning to Conviva.
     - Parameters:
        - warning: An error instance of type Error. The localizedDescription of this error is sent to Conviva.
     */
    func sendCustomWarning(warning : Error)
    
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
