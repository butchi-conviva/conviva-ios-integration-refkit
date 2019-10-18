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
private let kConviva_Gateway_URL = Conviva.Credentials.gatewayURL

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
     The ConvivaLightSession instance.
     */
    private var convivaVideoSession : ConvivaLightSession!
    
    /**
     The ConvivaContentInfo instance.
     */
    private var convivaMetadata : ConvivaContentInfo!
    
    // MARK: - Conviva setup
    
    /**
     Used to setup Conviva monitoring.
     */
    static func setupConvivaMonitoring() {
        saveConvivaCredentials()
        var clientSettings = Dictionary <String, Any>()
        clientSettings["gatewayUrl"] = kConviva_Gateway_URL
        LivePass.toggleTraces(true)
        LivePass.initWithCustomerKey(kConviva_Key, andSettings: clientSettings)
    }
    
    /**
     Used to cleanup Conviva monitoring.
     */
    static func cleanupConvivaMonitoring() {
        LivePass.cleanup()
    }
    
    // MARK: - ConvivaBase : Session lifecycle functions
    
    /**
     Used to create a Conviva monitoring session.
     
     - Parameters:
        - player: The streamer instance which needs to be monitored
        - metadata: The initial set of metadata values related to a video playback
     */
    func createSession(player: Any, metadata: [String : Any]) {
        self.videoPlayer = player as? AVPlayer
        self.metadataDict = metadata

        let metadata : [String : Any] = [Conviva.Keys.ConvivaContentInfo.assetName : self.metadataDict[Conviva.Keys.Metadata.title] as Any,
                                                Conviva.Keys.ConvivaContentInfo.viewerId : self.metadataDict[Conviva.Keys.Metadata.userId] as Any,
                                                Conviva.Keys.ConvivaContentInfo.playerName : self.metadataDict[Conviva.Keys.Metadata.playerName] as Any,
                                                Conviva.Keys.ConvivaContentInfo.isLive : self.metadataDict[Conviva.Keys.Metadata.live] as Any,
                                                Conviva.Keys.ConvivaContentInfo.contentLength : self.metadataDict[Conviva.Keys.Metadata.duration] as Any,
                                                Conviva.Keys.ConvivaContentInfo.encodedFramerate : self.metadataDict[Conviva.Keys.Metadata.efps] as Any,
                                                Conviva.Keys.ConvivaContentInfo.tags: self.metadataDict[Conviva.Keys.Metadata.tags] as Any]
        
        if let session = LivePass.createSession(withStreamer: self.videoPlayer, andConvivaContentInfo: getConvivaContentInfoFromMetadata(metadata)) {
            self.convivaVideoSession = session
        }
        else{
            print("Conviva Error : failed to create session")
        }
    }

    /**
     Used to cleanup a Conviva monitoring session.
     */
    func cleanupSession() {
        if  self.convivaVideoSession != nil {
            LivePass.cleanupSession(self.convivaVideoSession)
            self.convivaVideoSession = nil
        }
    }
    
    /**
     Used to attach a streamer instance which can be monitored.
     */
    func attachPlayer() {
        if(self.videoPlayer != nil && convivaVideoSession != nil){
            convivaVideoSession.attachStreamer(self.videoPlayer)
        }
    }
    
    /**
     Used to detach the earlier attached streamer instance.
     */
    func detachPlayer() {
        if(convivaVideoSession != nil){
            convivaVideoSession.pauseMonitor()
        }
    }
    
    // MARK: - ConvivaBase : Conviva advanced metadata and events functions
    
    /**
     Used to send a custom event e.g. PodStart or PodEnd events to Conviva.
     */
    func sendCustomEvent() {
        if (convivaVideoSession != nil){
            self.convivaVideoSession.sendEvent( "Conviva.PodStart", withAttributes: [
                "podDuration" : "60",
                "podPosition" : "Pre-roll",
                "podIndex" : "1",
                "absoluteIndex" :  "1"
                ]
            )
        }
    }
    
    /**
     Used to send a custom error to Conviva.
     */
    func sendCustomError() {
        if (convivaVideoSession != nil){
            convivaVideoSession.reportError("Fatal Error", errorType: ErrorSeverity.SEVERITY_FATAL)
        }
    }
    
    /**
     Used to send a custom warning to Conviva.
     */
    func sendCustomWarning() {
        if (convivaVideoSession != nil){
            convivaVideoSession.reportError("Warning", errorType: ErrorSeverity.SEVERITY_WARNING)
        }
    }
    
    /**
     Used to update the earlier set ConvivaContentInfo values.
     */
    func updateContentMetadata() {
        if (convivaVideoSession != nil){
            convivaVideoSession.updateContentMetadata(getUpdatedContentMetadata())
        }
    }
    
    /**
     Used to report start of seek event.
     - Parameters:
        - position: seek start position
     */
    func seekStart(position:NSInteger) {
        if (convivaVideoSession != nil){
            convivaVideoSession.setSeekStart(position);
        }
    }
    
    /**
     Used to report end of seek event.
     - Parameters:
        - position: seek end position
     */
    func seekEnd(position:NSInteger) {
        if (convivaVideoSession != nil){
            convivaVideoSession.setSeekEnd(position);
        }
    }

    // MARK: - Private methods - Conviva content metadata
    static private func saveConvivaCredentials() {
        UserDefaults.setConvivaGatewayURL(gatewayURL: Conviva.Credentials.gatewayURL)
        UserDefaults.setConvivaCustomerKey(customerKey: Conviva.Credentials.customerKey)
    }

    /**
     Used to map customer provided metadata values to ConvivaContentInfo instance.
     - Parameters:
        - metadata: A Disctionary containing customer provided metadata
     
     - Returns: Metadata values mapped to ConvivaContentInfo instance
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
