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

private let kConviva_Key = Conviva.Credentials.customerKey
private let kConviva_Gateway_URL_Test = Conviva.Credentials.gatewayURLTest
private let kConviva_Gateway_URL_Prod = Conviva.Credentials.gatewayURLTest

class CVACustomPlayerIntegrationRef : CVABaseIntegrationRef {
    var client : CISClientProtocol!
    
    var videoSessionID : Int32!
    
    var playerStateManager : CISPlayerStateManagerProtocol!
    
    var customPlayer : CustomPlayer!
    
    var customPlayerInterface : CustomPlayerInterface!

    func initialize() {
        let systemInterFactory : CISSystemInterfaceProtocol = IOSSystemInterfaceFactory.initializeWithSystemInterface()
        let setting = CISSystemSettings.init()
        setting.logLevel = .LOGLEVEL_NONE
        let factory : CISSystemFactoryProtocol = CISSystemFactoryCreator.create(withCISSystemInterface: systemInterFactory, setting: setting)
        
        let settingError : Error? = nil
        let clientError : Error? = nil
        
        var clientSettings : CISClientSettingProtocol
        do {
            clientSettings = try CISClientSettingCreator.create(withCustomerKey: kConviva_Key)
            
            #if DEBUG
            clientSettings.setGatewayUrl(kConviva_Gateway_URL_Test)
            #else
            clientSetting.setGatewayUrl(kConviva_Gateway_URL_Prod)
            #endif
            
            do {
                client = try CISClientCreator.create(withClientSettings: clientSettings, factory: factory)
            }
                
            catch {
                print(clientError!)
            }
        }
            
        catch {
            print(settingError!)
        }
        
        if (clientError != nil) {
            print("[REFERENCE APP] [clientError] [ \(clientError!) ]")
        }
        else if (settingError != nil){
            NSLog("[REFERENCE APP] [settingError] [ \(settingError!) ]")
        }
        else{
            print("[REFERENCE APP] [SUCCESS] [INIT SUCCESS]")
        }
    }

    func cleanup() {
        
    }
    
    func createContentSession(player: Any, metadata: [String : Any]?) {
        guard self.client != nil else  {
            return
        }
        self.videoSessionID = self.client.createSession(with: self.createMetadataObject())
    }
    
    func cleanupContentSession() {
        if (videoSessionID != NO_SESSION_KEY) {
            client.cleanupSession(videoSessionID)
            videoSessionID = NO_SESSION_KEY
            customPlayerInterface.cleanupCustomPLayerInterface()
            customPlayerInterface = nil
            customPlayer.stop()
            customPlayer = nil
        }
    }
    
    func destroySession() {
        guard self.client != nil else {
            return
        }
        
        if self.videoSessionID != NO_SESSION_KEY {
            self.client.cleanupSession(self.videoSessionID)
            self.videoSessionID = NO_SESSION_KEY
        }
    }
    
    func attachPlayer(player: Any) {
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
    
    func detachPlayer() {
        
    }
    
    func sendCustomEvent(eventName: String, eventAttributes: [String : String]) {
        if (client != nil && videoSessionID != NO_SESSION_KEY) {
            let keys = ["test key 1", "test key 2", "test key 3"]
            let values = ["test value1", "test value2", "test value3"]
            let attributes : NSDictionary = [keys : values]
            client.sendCustomEvent(videoSessionID, eventname: "global event", withAttributes: attributes as? [AnyHashable : Any])
        }
    }
    
    func sendCustomError(error: Error) {
        if ((client) != nil){
            if ((playerStateManager != nil) && (customPlayerInterface != nil)) {
                customPlayerInterface.reportError()
            }
            else{
                if (videoSessionID != NO_SESSION_KEY){
                    client.reportError(videoSessionID, errorMessage: "Video start error", errorSeverity: ErrorSeverity.SEVERITY_FATAL)
                }
            }
        }
    }
    
    func sendCustomWarning(warning: Error) {
        if ((client) != nil){
            if ((playerStateManager != nil) && (customPlayerInterface != nil)) {
                customPlayerInterface.reportError()
            }
            else{
                if (videoSessionID != NO_SESSION_KEY){
                    client.reportError(videoSessionID, errorMessage: "Video start error", errorSeverity: ErrorSeverity.SEVERITY_WARNING)
                }
            }
        }
    }
    
    func updateContentMetadata() {
        
    }
    
    func seekStart(position: NSInteger) {
        customPlayerInterface.setSeekStart(seekToPosition: position)
    }
    
    func seekEnd(position: NSInteger) {
        customPlayerInterface.setSeekEnd(seekToPosition: position)
    }
}

// For creating objects and providing values
extension CVACustomPlayerIntegrationRef {
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
    
    func cleanupCustomPLayerInterface(){
        // CLEAN UP CustomPlayer IF REQUIRED
        // DEREGISTER NOTIFICATIONS
    }
    
    // Reusing a PlayerStateManager instance
    func resetPlayerStateManager(){
        playerStateManager.reset!()
    }
    
}

// For reporting additional custom values
extension CVACustomPlayerIntegrationRef {
    
    func setPlayerState(playerState: PlayerState?) {
        customPlayerInterface.setPlayerState(playerState: playerState!)
    }
    
    func setCDNServerIP(cdnServerIP : String) {
        customPlayerInterface.setCDNServerIP(cdnServerIP: cdnServerIP)
    }
    
    func setBitrateKbps(newBitrateKbps: Int) {
        customPlayerInterface.setBitrateKbps(newBitrateKbps: newBitrateKbps)
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
