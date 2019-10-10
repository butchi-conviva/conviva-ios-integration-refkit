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
    
    private let kNOT_APPLICABLE = "N/A"
    
    private var mainPlayer : AVPlayer!
    private var environment : Environment!
    private var metadata : [String : Any] = [:]
    private var convivaVideoSession : ConvivaLightSession!
    private var convivaMetadata : ConvivaContentInfo!
    
    // MARK: - Conviva setup
    
    func setupConvivaMonitoring(player: Any, metadata: [String : Any], environment : Environment) {
        saveConvivaCredentials ()
        
        var clientSettings = Dictionary <String, Any>()
        clientSettings["gatewayUrl"] = kConviva_Gateway_URL
        
        #if DEBUG
        LivePass.toggleTraces(true)
        #else
        LivePass.toggleTraces(false)
        #endif
        
        LivePass.initWithCustomerKey(kConviva_Key, andSettings: clientSettings)
        
        self.mainPlayer = player as? AVPlayer
        self.environment = environment
        self.metadata = metadata
    }
    
    func cleanupConvivaMonitoring() {
        LivePass.cleanup()
    }
    
    // MARK: - ConvivaBase : Session lifecycle functions
    func createSession() {
        let customMetadata : [String : Any] = [Conviva.MetadataTagsKeys.matchId : metadata["matchId"] as Any, Conviva.MetadataTagsKeys.premium : metadata["premium"] as Any]
        
        let convivaMetadata : [String : Any] = [Conviva.MetadataKeys.title : metadata["title"] as Any,
                                                Conviva.MetadataKeys.useruuid : metadata["useruuid"] as Any,
                                                Conviva.MetadataKeys.isLive : metadata["isLive"] as Any,
                                         Conviva.MetadataKeys.customMetadata: customMetadata]
        
        if let session = LivePass.createSession(withStreamer: self.mainPlayer, andConvivaContentInfo: getContentMetadata(metadata: convivaMetadata)) {
            self.convivaVideoSession = session
        }
        else{
            print("Conviva Error : fail to create session")
        }
    }

    func cleanupSession() {
        if  self.convivaVideoSession != nil {
            LivePass.cleanupSession(self.convivaVideoSession)
            self.convivaVideoSession = nil
        }
    }
    
    func attachPlayer() {
        if(mainPlayer != nil && convivaVideoSession != nil){
            convivaVideoSession.attachStreamer(mainPlayer)
        }
    }
    
    func detachPlayer() {
        if(convivaVideoSession != nil){
            convivaVideoSession.pauseMonitor()
        }
    }
    
    // MARK: - ConvivaBase : Conviva advanced metadata and events functions

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
    
    func sendCustomError() {
        if (convivaVideoSession != nil){
            convivaVideoSession.reportError("Fatal Error", errorType: ErrorSeverity.SEVERITY_FATAL)
        }
    }
    
    func sendCustomWarning() {
        if (convivaVideoSession != nil){
            convivaVideoSession.reportError("Warning", errorType: ErrorSeverity.SEVERITY_WARNING)
        }
    }
    
    func updateContentMetadata() {
        if (convivaVideoSession != nil){
            convivaVideoSession.updateContentMetadata(getUpdatedContentMetadata())
        }
    }
    
    func seekStart(position:NSInteger) {
        if (convivaVideoSession != nil){
            convivaVideoSession.setSeekStart(position);
        }
    }
    
    func seekEnd(position:NSInteger) {
        if (convivaVideoSession != nil){
            convivaVideoSession.setSeekEnd(position);
        }
    }

    // MARK: - :Private methods - Conviva content metadata 
    private func saveConvivaCredentials() {
        UserDefaults.setConvivaGatewayURL(gatewayURL: Conviva.Credentials.gatewayURL)
        UserDefaults.setConvivaCustomerKey(customerKey: Conviva.Credentials.customerKey)
    }

    private func getContentMetadata(metadata : Dictionary<String, Any>) -> ConvivaContentInfo {
        convivaMetadata = ConvivaContentInfo.createInfoForLightSession(withAssetName: metadata[Conviva.MetadataKeys.title] as? String ) as? ConvivaContentInfo
        convivaMetadata.viewerId = metadata[Conviva.MetadataKeys.useruuid] as? String
        convivaMetadata.playerName = "Redbox iOS"
        convivaMetadata.isLive = (metadata[Conviva.MetadataKeys.isLive] != nil) ? true : false
        convivaMetadata.resource = CDN_NAME_AKAMAI
        convivaMetadata.encodedFramerate = 60
        
        let metadata : [String : Any] = metadata[Conviva.MetadataKeys.customMetadata] as! [String : Any]
        convivaMetadata.tags = getCustomTags(metadata: metadata)
        
        return convivaMetadata
    }
    
    private func getCustomTags(metadata : Dictionary<String, Any>) -> NSMutableDictionary{
        let customTags = NSMutableDictionary()
        
        customTags["productID"] = (metadata[Conviva.MetadataTagsKeys.premium] != nil) ? "Premium" : "non Premium"
        customTags["matchId"] = metadata[Conviva.MetadataTagsKeys.matchId]
        customTags["playerVendor"] = "Apple"
        customTags["playerVersion"] = metadata["playerVersion"] ?? kNOT_APPLICABLE
        customTags["product"] = "Internal"
        customTags["assetID"] = "87623"
        customTags["carrier"] = metadata["carrier"] ?? kNOT_APPLICABLE
        
        if let identifier = UIDevice.current.identifierForVendor?.uuidString {
            customTags["deviceID"] = identifier
        }
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            customTags["appBuild"] = version
        }
        if let favouriteTeam = UserDefaults.getFavouriteTeamName() {
            customTags["favouriteTeam"] = favouriteTeam
        }
        
        return customTags
    }
    
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
