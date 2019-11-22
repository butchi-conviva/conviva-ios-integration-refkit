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
     This function will be called when player  starts playback.
     - Parameters:
        - player: The player instance which has started the playback.
        - assetInfo: The CVAAsset instance which contains metadata information.
     */
    func didStartPlayback(player: Any, assetInfo : CVAAsset)
    
    /**
     This function will be called when player  failed to play the content.
     This function is used to call CVAAVPlayerIntegrationRef's cleanupSession function.
     - Parameters:
        - player: The player instance which has started the playback.
        - assetInfo: The CVAAsset instance which contains metadata information.
     */
    func didFailPlayback(player: Any,error:Error)

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
     This function will be called when player failed to seek.
     This function is used to call CVAAVPlayerIntegrationRef's seekEnd function.
     */
    func didFailSeekTo(position:NSInteger)
    
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

    /**
     This function will be called when AVPlayer receives an audio interruption.
     This function is used to call CVAAVPlayerIntegrationRef's cleanupSession function.
     */
    func didReceiveAudioInterruption()
    
    /**
     This function will be called when audio interruption is finished.
     This function is used to call CVAAVPlayerIntegrationRef's createSession function.
     - Parameters:
        - player: The player instance which has started the playback.
        - assetInfo: The CVAAsset instance which contains metadata information.
     */
    func didFinishAudioInterruption(player: Any, assetInfo : CVAAsset)
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
        convivaAVPlayerIntegrationRef.createContentSession(player: player, metadata: assetInfo.getMetadata(asset: assetInfo))
    }
    
    /**
     This function will be called when player  starts playback.
     - Parameters:
        - player: The player instance which has started the playback.
        - assetInfo: The CVAAsset instance which contains metadata information.
     */
    func didStartPlayback(player: Any, assetInfo : CVAAsset) {
        
    }
    
    /**
     This function will be called when player  failed to play the content.
     This function is used to call CVAAVPlayerIntegrationRef's cleanupSession function.
     - Parameters:
        - player: The player instance which has started the playback.
        - assetInfo: The CVAAsset instance which contains metadata information.
     */
    func didFailPlayback(player: Any,error:Error) {
        convivaAVPlayerIntegrationRef.sendCustomError(error: error)
        convivaAVPlayerIntegrationRef.cleanupContentSession()
    }

    /**
     This function is used to call CVAAVPlayerIntegrationRef's cleanupSession function.
     */
    func didStopPlayback() {
        convivaAVPlayerIntegrationRef.cleanupContentSession()
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
     This function will be called when player failed to seek.
     This function is used to call CVAAVPlayerIntegrationRef's seekEnd function.
     */
    func didFailSeekTo(position:NSInteger) {
        
    }
    
    /**
     This function will be called when application enters background.
     This function is used to call CVAAVPlayerIntegrationRef's cleanupSession function.
     */
    func didEnterBackground() {
        convivaAVPlayerIntegrationRef.cleanupContentSession()
    }

    /**
     This function will be called when application enters foreground.
     This function is used to call CVAAVPlayerIntegrationRef's createSession function.
     - Parameters:
        - player: The player instance which has started the playback.
        - assetInfo: The CVAAsset instance which contains metadata information.
     */
    func willEnterForeground(player: Any, assetInfo : CVAAsset) {
        convivaAVPlayerIntegrationRef.createContentSession(player: player, metadata: assetInfo.getMetadata(asset: assetInfo))
    }
    
    /**
     This function will be called when AVPlayer receives an audio interruption.
     This function is used to call CVAAVPlayerIntegrationRef's cleanupSession function.
     */
    func didReceiveAudioInterruption() {
        convivaAVPlayerIntegrationRef.cleanupContentSession()
    }
    
    /**
     This function will be called when audio interruption is finished.
     This function is used to call CVAAVPlayerIntegrationRef's createSession function.
     - Parameters:
        - player: The player instance which has started the playback.
        - assetInfo: The CVAAsset instance which contains metadata information.
     */
    func didFinishAudioInterruption(player: Any, assetInfo : CVAAsset) {
        convivaAVPlayerIntegrationRef.createContentSession(player: player, metadata: assetInfo.getMetadata(asset: assetInfo))
    }
}

