//
//  ConvivaSDKiOS.swift
//  ConvivaIntegrationRefKit
//
//  Created by Gaurav Tiwari on 25/09/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

import Foundation

import UIKit
import ConvivaSDK
import AVFoundation

class CVACustomSDKIntegrationRef {
//    var mainPlayer : OoyalaPlayer!
}

/*
class CVACustomSDKIntegrationRef : CVABaseIntegrationRef {
    var client : CISClientProtocol!
    var isInitalised : Bool = false
    var videoSessionID : Int32!
    
    var playerStateManager : CISPlayerStateManagerProtocol!
    
    var customPlayer : CustomPlayer!
    var customPlayerInterface : CustomPlayerInterface!
    
    func setupConvivaMonitoring() {
        if self.isInitalised == false {
            let systemInterface : CISSystemInterfaceProtocol = IOSSystemInterfaceFactory.initializeWithSystemInterface()
            
            let settings : CISSystemSettings = CISSystemSettings()
            
            if !logLevel {
                settings.logLevel = LogLevel.LOGLEVEL_NONE
            }
            
            let systemFactory : CISSystemFactoryProtocol = CISSystemFactoryCreator.create(withCISSystemInterface: systemInterface, setting: settings)
            do {
                let clientSettings : CISClientSettingProtocol  = try CISClientSettingCreator.create(withCustomerKey: customerKey)
                clientSettings.setGatewayUrl(gatewayURL)
                self.client = try CISClientCreator.create(withClientSettings: clientSettings, factory: systemFactory)
                self.isInitalised = true
            } catch let error as NSError{
                print("Error : \(error.description)")
            }
        }
    }
    
    func createConvivaSession(){
        if isInitalised == false || self.client == nil {
            return
        }
        self.videoSessionID = self.client.createSession(with: self.createMetadataObject())
    }
    
    func createMetadataObject() -> CISContentMetadata {
        let metadata : CISContentMetadata  = CISContentMetadata()
        
        // A unique identifier for the content, preferably human-readable.
        metadata.assetName = "Test Video"
        
        // The URL from which the video is loaded.
        metadata.streamUrl = "streamUrl"
        
        // required : CONVIVA_STREAM_LIVE OR CONVIVA_STREAM_VOD
        // use this instead of isLive
        metadata.streamType = StreamType.CONVIVA_STREAM_VOD
        
        let tags : NSDictionary = ["value1":"tag1","value2" : "tag2"]
        // highly recommended: dictionary of your custom metadata key/value string pairs
        metadata.custom = tags as? NSMutableDictionary
        
        // Duration of the video content, in seconds.
        metadata.duration = 1080
        
        // required for Viewers Module: e.g. "john@doe.com" or "12345"
        metadata.viewerId = "Sample ViewerID"
        
        // e.g. "iOS App", preferably human-readable
        // use this instead of playerName
        metadata.applicationName = "Sample Player Name"
        
        // optional: needed when the content's stream URL patterns
        // are not sufficient to identify the CDN
        metadata.defaultResource = "AKAMAI_FREE"
        
        return metadata
    }
    
    func destroySession() {
        if isInitalised == false || self.client == nil {
            return
        }
        
        if self.videoSessionID != NO_SESSION_KEY {
            self.client.cleanupSession(self.videoSessionID)
            self.videoSessionID = NO_SESSION_KEY
        }
    }
    
    // Create Player Instance
    func createPlayerInstance(){
        if (customPlayer == nil) {
            customPlayer = CustomPlayer.init(videoURL: URL(string: "SAMPLE_VIDEO_URL")!)
        }
    }
    
    // Create PlayerStateManager Instance
    func createPlayerStateManagerInstance(){
        if (playerStateManager == nil){
            playerStateManager = client.getPlayerStateManager()
        }
    }
    
    func attachPlayer(player: Any?) {
        if (client != nil){
            // createPlayerInstance() // this player will be passed from outside
            createPlayerStateManagerInstance()
            
            // Create Player Interface Instance
            if (customPlayerInterface == nil){
                customPlayerInterface = CustomPlayerInterface.init(playerStateManager: playerStateManager, customPlayer: customPlayer)
            }
            
            // Assign the CustomPlayer instance to PlayerStateManager
            playerStateManager.setCISIClientMeasureInterface!(customPlayerInterface as? CISIClientMeasureInterface)
            
            // Attach PlayerStateManager to Conviva session
            if ((playerStateManager != nil) && videoSessionID != NO_SESSION_KEY){
                client.attachPlayer(videoSessionID, playerStateManager: playerStateManager)
            }
        }
    }
    
    func setPlayerState(playerState: PlayerState?) {
        customPlayerInterface.setPlayerState(playerState: playerState!)
    }
    
    func setSeekStart(seekToPosition : Int64) {
        customPlayerInterface.setSeekStart(seekToPosition: seekToPosition)
    }
    
    func setSeekEnd(seekToPosition : Int64) {
        customPlayerInterface.setSeekEnd(seekToPosition: seekToPosition)
    }
    
    func setCDNServerIP(cdnServerIP : String) {
        customPlayerInterface.setCDNServerIP(cdnServerIP: cdnServerIP)
    }
    
    func setBitrateKbps(newBitrateKbps: Int) {
        customPlayerInterface.setBitrateKbps(newBitrateKbps: newBitrateKbps)
    }
    
    // Reusing a PlayerStateManager instance
    func resetPlayerStateManager(){
        playerStateManager.reset!()
    }
    
    // Clean up the CustomPlayer Interface
    func cleanupCustomPlayerInterface(){
        customPlayerInterface = nil
        customPlayer = nil
        customPlayerInterface.cleanupCustomPLayerInterface()
        customPlayer.stop()
    }
    
    // Release PlayerStateManager
    func cleanupPlayerStateManager(){
        if (playerStateManager != nil) {
            client.releasePlayerStateManager(playerStateManager)
            playerStateManager = nil;
        }
    }
    
    // Clean up the session
    func cleanupSession(){
        if (videoSessionID != NO_SESSION_KEY) {
            client.cleanupSession(videoSessionID)
            videoSessionID = NO_SESSION_KEY
            customPlayerInterface.cleanupCustomPLayerInterface()
            customPlayerInterface = nil
            customPlayer.stop()
            customPlayer = nil
        }
    }
    
    func cleanupCustomPLayerInterface(){
        // CLEAN UP CustomPlayer IF REQUIRED
        // DEREGISTER NOTIFICATIONS
    }
    
    func reportError() {
        if ((client) != nil){
            if ((playerStateManager != nil) && (customPlayerInterface != nil)) {
                customPlayerInterface.reportError()
            }
            else{
                if (videoSessionID != NO_SESSION_KEY){
                    client.reportError(videoSessionID, errorMessage: "Video start error", errorSeverity: .ERROR_FATAL)
                }
            }
        }
    }
    
    func sendCustomEvent() {
        if (client != nil && videoSessionID != NO_SESSION_KEY) {
            let keys = ["test key 1", "test key 2", "test key 3"]
            let values = ["test value1", "test value2", "test value3"]
            let attributes : NSDictionary = [keys : values]
            client.sendCustomEvent(videoSessionID, eventname: "global event", withAttributes: attributes as? [AnyHashable : Any])
        }
    }
    
    // Player State can be reported as following. It must be done when player reports a state change event
    func reportPlayerState(playerState : PlayerState){
        if (playerStateManager != nil) {
            playerStateManager.setPlayerState!(playerState)
        }
    }
    
    // Bitrate can be reported as following. It must be done when player reports a bitrate change event
    func reportPlayerBitrate(bitrate : Int){
        if (playerStateManager != nil && bitrate > 0) {
            playerStateManager.setBitrateKbps!(bitrate)
        }
    }
}
*/
