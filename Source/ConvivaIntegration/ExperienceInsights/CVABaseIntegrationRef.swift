//
//  ConvivaBase.swift
//  ConvivaIntegrationRefKit
//
//  Created by Gaurav Tiwari on 25/09/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

import Foundation
import ConvivaCore

private let kConviva_Key = Conviva.Credentials.customerKey
private let kConviva_Gateway_URL_Test = Conviva.Credentials.gatewayURLTest
private let kConviva_Gateway_URL_Prod = Conviva.Credentials.gatewayURLProd

/// A protocol used to keep all methods used for Conviva library's integration.
protocol CVABaseIntegrationRefProtocol {
    
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

/// A class which is used to implements all methods declated in CVABaseIntegrationRefProtocol which are used for Conviva library's integration.
class CVABaseIntegrationRef: CVABaseIntegrationRefProtocol {

    /**
     Following variable of type ConvivaLightSession will be used to execute all of the ad specific Conviva moniting.
     The main content session is also used for ad session creation.
     */
    var convivaContentSession : ConvivaLightSession!
    
    /**
     The ConvivaContentInfo instance.
     */
    var convivaMetadata : ConvivaContentInfo!

    // MARK: Conviva Setup - Functions/variables responsible for Conviva monitoring setup.

    /**
     Used to setup Conviva monitoring.
     */
    static func initialize() {
        saveConvivaCredentials()
        var clientSettings = Dictionary <String, Any>()
        
        #if DEBUG
        clientSettings[Conviva.Credentials.gatewayURLKey] = kConviva_Gateway_URL_Test
        LivePass.toggleTraces(true)
        #else
        clientSettings[Conviva.Credentials.gatewayURLKey] = kConviva_Gateway_URL_Prod
        LivePass.toggleTraces(true)
        #endif
        LivePass.initWithCustomerKey(kConviva_Key, andSettings: clientSettings)
    }

    /**
     Used to cleanup Conviva monitoring.
     */
    static func cleanup() {
        LivePass.cleanup()
    }

    // MARK: Conviva session management - Functions/variables responsible for Conviva session management.
    
    /**
     Used to attach a streamer instance which can be monitored.
     - Parameters:
     - player: The streamer instance which needs to be monitored. For ConvivaAVFounation integration, player must be an AVPlayer instance
     */
    func attachPlayer(player: Any) {
        if player is AVPlayer {
            if(self.convivaContentSession != nil){
                self.convivaContentSession.attachStreamer(player)
            }
        }
        else {
            print(Conviva.Errors.typeNotAVPlayer)
        }
    }
    
    /**
     Used to detach the earlier attached streamer instance.
     It should be called when a streamer object has been attached using attachPlayer earlier.
     */
    func detachPlayer() {
        if(self.convivaContentSession != nil){
            self.convivaContentSession.pauseMonitor()
        }
    }

    // MARK: Conviva advanced metadata - Functions/variables responsible for managing advanced metadata & events.
    
    /**
     Used to send a custom event e.g. PodStart or PodEnd events to Conviva.
     You may send a custom Player Insight event that is or is not associated with a monitoring session.
     - Parameters:
     - eventName: Event name of type String
     - eventAttributes: Event Attributes of type Dictionary
     */
    func sendCustomEvent(eventName: String, eventAttributes : [String : String]) {
        if (self.convivaContentSession != nil){
            self.convivaContentSession.sendEvent(eventName, withAttributes: eventAttributes)
        }
        
        /*
         Example:
         eventName: "Conviva.PodStart"
         eventAttributes: [
         "podDuration" : "60",
         "podPosition" : "Pre-roll",
         "podIndex" : "1",
         "absoluteIndex" :  "1"
         ]
         */
    }
    
    /**
     Used to send a custom error to Conviva.
     - Parameters:
        - error: An error instance of type Error. The localizedDescription of this error is sent to Conviva.
     */
    func sendCustomError(error : Error) {
        if (self.convivaContentSession != nil){
            self.convivaContentSession.reportError(error.localizedDescription, errorType: ErrorSeverity.SEVERITY_FATAL)
        }
    }
    
    /**
     Used to send a custom warning to Conviva.
     - Parameters:
        - warning: An error instance of type Error. The localizedDescription of this error is sent to Conviva.
     */
    func sendCustomWarning(warning : Error) {
        if (self.convivaContentSession != nil){
            self.convivaContentSession.reportError(warning.localizedDescription, errorType: ErrorSeverity.SEVERITY_WARNING)
        }
    }
    
    /**
     Used to update the earlier set ConvivaContentInfo values.
     */
    func updateContentMetadata() {
        if (self.convivaContentSession != nil){
            self.convivaContentSession.updateContentMetadata(getUpdatedContentMetadata())
        }
    }

    /**
     Used to report start of seek event.
     - Parameters:
        - position: seek start position
     */
    func seekStart(position:NSInteger) {
        if (self.convivaContentSession != nil){
            self.convivaContentSession.setSeekStart(position);
        }
    }
    
    /**
     Used to report end of seek event.
     - Parameters:
        - position: seek end position
     */
    func seekEnd(position:NSInteger) {
        if (self.convivaContentSession != nil){
            self.convivaContentSession.setSeekEnd(position);
        }
    }
}

/// An extension of CVABaseIntegrationRefProtocol protocol which provides default functionality [Empty implementation] of session creation and cleanup methods.
/// These session creation and cleanup methods methods will be implemented by respective Conviva integration reference classes.
extension CVABaseIntegrationRefProtocol {
    // MARK: Conviva session management - Functions/variables responsible for Conviva session management.
    
    func createContentSession(player: Any, metadata: [String : Any]?) {
        
    }
    
    func cleanupContentSession() {
        
    }
}

/// An extension of CVABaseIntegrationRef class which provides the functionality using private methods.
extension CVABaseIntegrationRef {
    
    // MARK: - Private methods - Conviva content metadata
    
    /**
     Used to save Conviva credentials (gateway URL and customer key) to UserDefaults.
     */
    static private func saveConvivaCredentials() {
        #if DEBUG
        UserDefaults.setConvivaGatewayURL(gatewayURL: Conviva.Credentials.gatewayURLTest)
        #else
        UserDefaults.setConvivaGatewayURL(gatewayURL: Conviva.Credentials.gatewayURLProd)
        #endif
        UserDefaults.setConvivaCustomerKey(customerKey: Conviva.Credentials.customerKey)
    }
    
    /**
     Used to update earlier provided metadata values to ConvivaContentInfo instance.
     - Returns: ConvivaContentInfo instance
     */
    private func getUpdatedContentMetadata() -> ConvivaContentInfo {
        convivaMetadata.viewerId = "20119032"
        convivaMetadata.playerName = "Redbox iOS New"
        convivaMetadata.isLive = false
        convivaMetadata.resource = CDN_NAME_FASTLY
        convivaMetadata.tags = getUpdatedCustomTags()
        return convivaMetadata;
    }
    
    private func getUpdatedCustomTags() -> NSMutableDictionary {
        let updatedCustomTags = NSMutableDictionary()
        updatedCustomTags["product"] = "Redbox+"
        updatedCustomTags["assetID"] = "21342"
        return updatedCustomTags
    }

    var logLevel : Bool {
        set {
            logLevel = false
        }
        get {
            return false
        }
    }
}
