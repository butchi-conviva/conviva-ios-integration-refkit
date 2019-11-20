//
//  ConvivaAVPlayer.swift
//  ConvivaIntegrationRefKit
//
//  Created by Gaurav Tiwari on 25/09/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit
import ConvivaCore
import ConvivaAVFoundation

private let kConviva_Key = Conviva.Credentials.customerKey
private let kConviva_Gateway_URL_Test = Conviva.Credentials.gatewayURLTest
private let kConviva_Gateway_URL_Prod = Conviva.Credentials.gatewayURLProd

/// A class used to keep all methods used for Conviva AVPlayer integration.
class CVAAVPlayerIntegrationRef : CVABaseIntegrationRef {
    
    /**
     The AVPlayer instance which needs to be monitored using Conviva monitoring.
     */
    private var videoPlayer : AVPlayer!
    
    /**
     The set of metadata values provided by customer will be contained using this. And then, values from metadataDict are mapped to ConvivaContentInfo.
     */
    private var metadataDict : [String : Any] = [:]
    
    /**
     Following variable of type ConvivaLightSession will be used to execute all of the ad specific Conviva moniting.
     */
    var convivaContentSession : ConvivaLightSession!
    
    /**
     The ConvivaContentInfo instance.
     */
    private var convivaMetadata : ConvivaContentInfo!
    
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
     Used to create a Conviva monitoring session.
     - Parameters:
        - player: The streamer instance which needs to be monitored.
        - metadata: The initial set of metadata values related to a video playback.
                    If the initial values are not available, this paramter can be nil as well.
                    If the values need to be updated later, please use updateContentMetadata.
                    Visit https://community.conviva.com/site/global/platforms/ios/av_player/index.gsp#updateContentMetadata
     */
    func createContentSession(player: Any, metadata: [String : Any]?) {
        self.videoPlayer = player as? AVPlayer
        self.metadataDict = metadata ?? ["" : ""]

        let metadata : [String : Any] = [
            Conviva.Keys.ConvivaContentInfo.assetName : self.metadataDict[Conviva.Keys.Metadata.title] as Any,
            Conviva.Keys.ConvivaContentInfo.viewerId : self.metadataDict[Conviva.Keys.Metadata.userId] as Any,
            Conviva.Keys.ConvivaContentInfo.playerName : self.metadataDict[Conviva.Keys.Metadata.playerName] as Any,
            Conviva.Keys.ConvivaContentInfo.isLive : self.metadataDict[Conviva.Keys.Metadata.live] as Any,
            Conviva.Keys.ConvivaContentInfo.contentLength : self.metadataDict[Conviva.Keys.Metadata.duration] as Any,
            Conviva.Keys.ConvivaContentInfo.encodedFramerate : self.metadataDict[Conviva.Keys.Metadata.efps] as Any,
            Conviva.Keys.ConvivaContentInfo.tags: self.metadataDict[Conviva.Keys.Metadata.tags] as Any]
        
        if let session = LivePass.createSession(withStreamer: self.videoPlayer, andConvivaContentInfo: getConvivaContentInfoFromMetadata(metadata)) {
            self.convivaContentSession = session
        }
        else{
            print(Conviva.Errors.initializationError)
        }
    }

    /**
     Used to cleanup a Conviva monitoring session.
     */
    func cleanupContentSession() {
        if  self.convivaContentSession != nil {
            LivePass.cleanupSession(self.convivaContentSession)
            self.convivaContentSession = nil
        }
    }
    
    /**
     Used to attach a streamer instance which can be monitored.
     - Parameters:
        - player: The streamer instance which needs to be monitored. For ConvivaAVFounation integration, player must be an AVPlayer instance
     */
    func attachPlayer(player: Any) {
        if player is AVPlayer {
            if(self.videoPlayer != nil && convivaContentSession != nil){
                convivaContentSession.attachStreamer(self.videoPlayer)
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
        if(convivaContentSession != nil){
            convivaContentSession.pauseMonitor()
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
        if (convivaContentSession != nil){
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
        if (convivaContentSession != nil){
            convivaContentSession.reportError(error.localizedDescription, errorType: ErrorSeverity.SEVERITY_FATAL)
        }
    }
    
    /**
     Used to send a custom warning to Conviva.
     - Parameters:
        - warning: An error instance of type Error. The localizedDescription of this error is sent to Conviva.
     */
    func sendCustomWarning(warning : Error) {
        if (convivaContentSession != nil){
            convivaContentSession.reportError(warning.localizedDescription, errorType: ErrorSeverity.SEVERITY_WARNING)
        }
    }
    
    /**
     Used to update the earlier set ConvivaContentInfo values.
     */
    func updateContentMetadata() {
        if (convivaContentSession != nil){
            convivaContentSession.updateContentMetadata(getUpdatedContentMetadata())
        }
    }
    
    /**
     Used to report start of seek event.
     - Parameters:
        - position: seek start position
     */
    func seekStart(position:NSInteger) {
        if (convivaContentSession != nil){
            convivaContentSession.setSeekStart(position);
        }
    }
    
    /**
     Used to report end of seek event.
     - Parameters:
        - position: seek end position
     */
    func seekEnd(position:NSInteger) {
        if (convivaContentSession != nil){
            convivaContentSession.setSeekEnd(position);
        }
    }

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
     Used to map customer provided metadata values to ConvivaContentInfo instance.
     - Parameters:
        - metadata: A Dictionary containing customer provided metadata
     
     - Returns: A ConvivaContentInfo instance which has mapped customer provided metadata values.
     */
    private func getConvivaContentInfoFromMetadata(_ metadata : Dictionary<String, Any>) -> ConvivaContentInfo {
        convivaMetadata = ConvivaContentInfo.createInfoForLightSession(withAssetName: metadataDict[Conviva.Keys.ConvivaContentInfo.assetName] as? String ) as? ConvivaContentInfo
        
        convivaMetadata.viewerId = metadataDict[Conviva.Keys.ConvivaContentInfo.viewerId] as? String
        convivaMetadata.playerName = metadataDict[Conviva.Keys.ConvivaContentInfo.playerName] as? String 
        convivaMetadata.isLive = (metadataDict[Conviva.Keys.ConvivaContentInfo.isLive] != nil) ? true : false
        convivaMetadata.resource = CDN_NAME_AKAMAI
        convivaMetadata.encodedFramerate = metadataDict[Conviva.Keys.ConvivaContentInfo.encodedFramerate] as! Int
        convivaMetadata.contentLength = metadataDict[Conviva.Keys.ConvivaContentInfo.contentLength] as! Int
        convivaMetadata.tags = metadataDict[Conviva.Keys.ConvivaContentInfo.tags] as? NSMutableDictionary
        return convivaMetadata
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
    
}
