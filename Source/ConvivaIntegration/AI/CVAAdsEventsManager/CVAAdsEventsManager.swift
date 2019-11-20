//
//  CVAAdsEventsManager.swift
//  ConvivaIntegrationRefKit
//
//  Created by Gaurav Tiwari on 20/11/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

import Foundation
import AVFoundation
import ConvivaCore

/// A protocol which is used to declare requirements for listening to callbacks from the ad mamager and making required Conviva calls.
/// Ad manager classes like CVAGoogleIMAHandler etc will call these functions to interact with Conviva.

protocol CVAAdsEventsManagerProtocol {
    /**
     The CVAAdsEventsManager struct initializer.
     Initialization of Ad Integration Reference classes like CVAGoogleIMAIntegrationRef etc should happen here.
     */
    init()
    
    /**
     This function will be called when ad manager is going to start playback.
     This function is used to call CVAGoogleIMAIntegrationRef's createAdSession function.
     - Parameters:
        - adManager: The ad manager instance which is going to start the playback.
        - contentInfo: The ConvivaContentInfo instance which contains metadata information.
     */
    func willStartAdPlayback(adManager: Any, contentInfo : ConvivaContentInfo)
    
    /**
     This function will be called when ad manager starts playback.
     - Parameters:
        - adManager: The ad manager instance which has started the playback.
        - contentInfo: The ConvivaContentInfo instance which contains metadata information.
     */
    func didStartPlayback(adManager: Any, contentInfo : ConvivaContentInfo)
    
    /**
     This function will be called when ad manager failed to play the ad.
     This function is used to call CVAGoogleIMAIntegrationRef's cleanupSession function.
     - Parameters:
        - adManager: The ad manager instance which has attempted the playback.
        - contentInfo: The ConvivaContentInfo instance which contains metadata information.
     */
    func didFailAdPlayback(adManager: Any, error : Error, contentInfo : ConvivaContentInfo)
    
    /**
     This function will be called when ad manager completes the playback of ad.
     This function is used to call CVAGoogleIMAIntegrationRef's cleanupSession function.
     */
    func didStopAdPlayback()

}

/// A struct which is used to implement CVAAdsEventsManagerProtocol requirements for listening to callbacks from the ad Manager and making required Conviva calls.
/// This struct will contain the functional implementation for handling and calling Conviva APIs.
/// Ad manager classes like CVAGoogleIMAHandler etc will call these functions to interact with Conviva.

struct CVAAdsEventsManager : CVAAdsEventsManagerProtocol {
    
    /**
     The CVAGoogleIMAIntegrationRef instance which is used to call all of Conviva AVPlayer library's behaviour.
     */
    var convivaGoogleIMAIntegrationRef : CVAGoogleIMAIntegrationRef!
    
    /**
     The CVAAdsEventsManager class initializer.
     Initialization of integration reference classes like CVAGoogleIMAIntegrationRef etc should happen here.
     */
    init() {
        convivaGoogleIMAIntegrationRef = CVAGoogleIMAIntegrationRef()
    }

    /**
     This function will be called when ad manager is going to start playback.
     This function is used to call CVAGoogleIMAIntegrationRef's createAdSession function.
     - Parameters:
        - adManager: The ad manager instance which is going to start the playback.
        - contentInfo: The ConvivaContentInfo instance which contains metadata information.
     */
    func willStartAdPlayback(adManager: Any, contentInfo : ConvivaContentInfo) {
        convivaGoogleIMAIntegrationRef.createAdsession(streamer: adManager, contentInfo: contentInfo)
    }
    
    /**
     This function will be called when ad manager starts playback.
     - Parameters:
        - adManager: The ad manager instance which has started the playback.
        - contentInfo: The ConvivaContentInfo instance which contains metadata information.
     */
    func didStartPlayback(adManager: Any, contentInfo : ConvivaContentInfo) {
        
    }
    
    /**
     This function will be called when ad manager failed to play the ad.
     This function is used to call CVAGoogleIMAIntegrationRef's cleanupSession function.
     - Parameters:
        - adManager: The ad manager instance which has attempted the playback.
        - contentInfo: The ConvivaContentInfo instance which contains metadata information.
     */
    func didFailAdPlayback(adManager: Any, error : Error, contentInfo : ConvivaContentInfo) {
        convivaGoogleIMAIntegrationRef.cleanupAdsession()
    }
    
    /**
     This function will be called when ad manager completes the playback of ad.
     This function is used to call CVAGoogleIMAIntegrationRef's cleanupSession function.
     */
    func didStopAdPlayback() {
        convivaGoogleIMAIntegrationRef.cleanupAdsession()
    }
}

