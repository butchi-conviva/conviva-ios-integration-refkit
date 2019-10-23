//
//  File.swift
//  ConvivaIntegrationRefKit
//
//  Created by Gaurav Tiwari on 23/10/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

import Foundation
import AVFoundation

/// A protocol which is used to implement a bridge between AVPlayer and Conviva.
/// This protocol will contain the function requirements for handling and calling Conviva APIs.
/// CVAAVPlayer will call these funcitons to interact with Conviva.

protocol CVAAVPlayerManagerProtocol {
    /**
     The CVAAVPlayerManager class initializer.
     Initialization of CVAAVPlayerIntegrationRef should happen here.
     */
    init()

    /**
     The CVAAVPlayerIntegrationRef instance which is used to call all of Conviva's behaviour.
     */
    var convivaAVPlayerIntegrationRef : CVAAVPlayerIntegrationRef! {get}
    
    /**
     This function calls CVAAVPlayerIntegrationRef's createSession function.
     */
    func createSession(player: AVPlayer?, asset : CVAAsset)

    /**
     This function calls CVAAVPlayerIntegrationRef's cleanupSession function.
     */
    func cleanupSession()

    /**
     This function calls CVAAVPlayerIntegrationRef's seekStart function.
     */
    func seekStart(position:NSInteger)
    
    /**
     This function calls CVAAVPlayerIntegrationRef's seekEnd function.
     */
    func seekEnd(position:NSInteger)
}

/// A class which is used to implement CVAPlayerManagerProtocol functions.

struct CVAAVPlayerManager : CVAAVPlayerManagerProtocol {
    
    var convivaAVPlayerIntegrationRef: CVAAVPlayerIntegrationRef!

    public init() {
        CVAAVPlayerIntegrationRef.initialize()
        convivaAVPlayerIntegrationRef = CVAAVPlayerIntegrationRef()
    }
    
    func createSession(player: AVPlayer?, asset : CVAAsset) {
        convivaAVPlayerIntegrationRef.createSession(player: player as Any, metadata: getMetadata(asset: asset))
    }

    func cleanupSession() {
        convivaAVPlayerIntegrationRef.cleanupSession()
    }

    func seekStart(position:NSInteger) {
        convivaAVPlayerIntegrationRef.seekStart(position: position);
    }
    
    func seekEnd(position:NSInteger) {
        convivaAVPlayerIntegrationRef.seekEnd(position: position);
    }
}

/// An extension of class CVAAVPlayerManager which is used to provide basic objects which are used in Conviva calls.
extension CVAAVPlayerManager {
    /**
     This function prepares the Metadata values which will be lated passed to Conviva.
     */
    func getMetadata(asset : CVAAsset) -> [String : Any] {
        return [Conviva.Keys.Metadata.title : Conviva.Values.Metadata.title,
                Conviva.Keys.Metadata.userId : Conviva.Values.Metadata.userId,
                Conviva.Keys.Metadata.playerName : Conviva.Values.Metadata.playerName,
                Conviva.Keys.Metadata.live : Conviva.Values.Metadata.live,
                Conviva.Keys.Metadata.duration : Conviva.Values.Metadata.duration,
                Conviva.Keys.Metadata.efps : Conviva.Values.Metadata.efps,
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
                Conviva.Keys.Metadata.appBuild : Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as Any,
                Conviva.Keys.Metadata.favouriteTeam : UserDefaults.getFavouriteTeamName() as Any]
    }
}
