//
//  File.swift
//  ConvivaIntegrationRefKit
//
//  Created by Gaurav Tiwari on 23/10/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

import Foundation
import AVFoundation

/// A protocol which is used to declare requirements for listening to callbacks from the player and making required Conviva calls.
/// Player manager classes like CVAAVPlayer etc will call these functions to interact with Conviva.

protocol CVAPlayerEventsManagerProtocol {
    /**
     The CVAAVPlayerManager class initializer.
     Initialization of Integration Reference classes like CVAAVPlayerIntegrationRef etc should happen here.
     */
    init()
    
    /**
     This function will be called when player is going to start playback.
     This function is used to call CVAAVPlayerIntegrationRef's createSession function.
     - Parameters:
        - player: The player instance which has started the playback.
        - assetInfo: The CVAAsset instance which contains metadata information.
     */
    func willStartPlayback(player: Any, assetInfo : CVAAsset)

    /**
     This function will be called when player stops playback.
     This function is used to call CVAAVPlayerIntegrationRef's cleanupSession function.
     */
    func didStopPlayback()

    /**
     This function will be called when player starts seeking.
     This function is used to call CVAAVPlayerIntegrationRef's seekStart function.
     */
    func willSeekFrom(position:NSInteger)
    
    /**
     This function will be called when player stops seeking.
     This function is used to call CVAAVPlayerIntegrationRef's seekEnd function.
     */
    func didSeekTo(position:NSInteger)
    
    /**
     This function will be called when application enters background.
     This function is used to call CVAAVPlayerIntegrationRef's cleanupSession function.
     */
    func didEnterBackground()

    /**
     This function will be called when application enters foreground.
     This function is used to call CVAAVPlayerIntegrationRef's createSession function.
     - Parameters:
        - player: The player instance which has started the playback.
        - assetInfo: The CVAAsset instance which contains metadata information.
     */
    func willEnterForeground(player: Any, assetInfo : CVAAsset)

}

/// A class which is used to implement CVAPlayerManagerProtocol requirements for listening to callbacks from the player and making required Conviva calls.
/// This class will contain the functional implementation for handling and calling Conviva APIs.
/// Player manager classes like CVAAVPlayer etc will call these functions to interact with Conviva.

struct CVAPlayerEventsManager : CVAPlayerEventsManagerProtocol {
    
    /**
     The CVAAVPlayerIntegrationRef instance which is used to call all of Conviva AVPlayer library's behaviour.
     */
    var convivaAVPlayerIntegrationRef : CVAAVPlayerIntegrationRef!

    /**
     The CVAAVPlayerManager class initializer.
     Initialization of Integration Reference classes like CVAAVPlayerIntegrationRef etc should happen here.
     */
    init() {
        CVAAVPlayerIntegrationRef.initialize()
        convivaAVPlayerIntegrationRef = CVAAVPlayerIntegrationRef()
    }
    
    /**
     This function will be called when player is going to start playback.
     This function is used to call CVAAVPlayerIntegrationRef's createSession function.
     - Parameters:
        - player: The player instance which has started the playback
        - assetInfo: The CVAAsset instance which contains metadata information.
     */
    func willStartPlayback(player: Any, assetInfo : CVAAsset) {
        convivaAVPlayerIntegrationRef.createSession(player: player, metadata: getMetadata(asset: assetInfo))
    }

    /**
     This function is used to call CVAAVPlayerIntegrationRef's cleanupSession function.
     */
    func didStopPlayback() {
        convivaAVPlayerIntegrationRef.cleanupSession()
    }
    
    /**
     This function is used to call CVAAVPlayerIntegrationRef's seekStart function.
     */
    func willSeekFrom(position:NSInteger) {
        convivaAVPlayerIntegrationRef.seekStart(position: position);
    }
    
    /**
     This function is used to call CVAAVPlayerIntegrationRef's seekEnd function.
     */
    func didSeekTo(position:NSInteger) {
        convivaAVPlayerIntegrationRef.seekEnd(position: position);
    }
    
    /**
     This function will be called when application enters background.
     This function is used to call CVAAVPlayerIntegrationRef's cleanupSession function.
     */
    func didEnterBackground() {
        convivaAVPlayerIntegrationRef.cleanupSession()
    }

    /**
     This function will be called when application enters foreground.
     This function is used to call CVAAVPlayerIntegrationRef's createSession function.
     - Parameters:
        - player: The player instance which has started the playback.
        - assetInfo: The CVAAsset instance which contains metadata information.
     */
    func willEnterForeground(player: Any, assetInfo : CVAAsset) {
        convivaAVPlayerIntegrationRef.createSession(player: player, metadata: getMetadata(asset: assetInfo))
    }
}

/// An extension of class CVAAVPlayerManager which is used to provide basic objects which are used in Conviva calls.
extension CVAPlayerEventsManager {
    /**
     This function prepares the Metadata values which will be lated passed to Conviva.
     */
    func getMetadata(asset : CVAAsset) -> [String : Any] {
        return [Conviva.Keys.Metadata.title : asset.title ?? "Default Asset",
                Conviva.Keys.Metadata.userId : Conviva.Values.Metadata.userId,
                Conviva.Keys.Metadata.playerName : Conviva.Values.Metadata.playerName,
                Conviva.Keys.Metadata.live : asset.islive,
                Conviva.Keys.Metadata.duration : asset.duration,
                Conviva.Keys.Metadata.efps : asset.efps,
                Conviva.Keys.Metadata.tags : getCustomTags() as NSMutableDictionary] as [String : Any]
    }
    
    /**
     This function prepares the Metadata's tags values which will be lated passed to Conviva.
     */
    func getCustomTags() -> NSMutableDictionary {
        return [Conviva.Keys.Metadata.matchId : Conviva.Values.Metadata.matchId,
                Conviva.Keys.Metadata.productType : Conviva.Values.Metadata.productType,
                Conviva.Keys.Metadata.playerVendor : Conviva.Values.Metadata.playerVendor,
                Conviva.Keys.Metadata.playerVersion : Conviva.Values.Metadata.playerVersion,
                Conviva.Keys.Metadata.product : Conviva.Values.Metadata.product,
                Conviva.Keys.Metadata.assetID : Conviva.Values.Metadata.assetID,
                Conviva.Keys.Metadata.carrier : Conviva.Values.Metadata.carrier,
                Conviva.Keys.Metadata.deviceID : UIDevice.current.identifierForVendor?.uuidString as Any,
                Conviva.Keys.Metadata.appBuild : Bundle.main.object(forInfoDictionaryKey: Conviva.Keys.infoDictionary) as Any,
                Conviva.Keys.Metadata.favouriteTeam : UserDefaults.getFavouriteTeamName() as Any]
    }
}
