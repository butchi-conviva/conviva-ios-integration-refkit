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
    func willStartAdPlayback(adManager: Any?, contentInfo : ConvivaContentInfo)
    
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
    func didFailAdPlayback(adManager: Any?, error : String, contentInfo : ConvivaContentInfo)
    
    /**
     This function will be called when ad manager completes the playback of ad.
     This function is used to call CVAGoogleIMAIntegrationRef's cleanupSession function.
     */
    func didStopAdPlayback()
    
    /**
     This function will be called main content session needs to be cleaned up.
     This function is used to call CVAAVPlayerIntegrationRef's cleanupSession function.
     */
    func didStopContentPlayback()

    /**
     This function will be called when main content monitoring needs to be paused.
     This function is used to call CVAGoogleIMAIntegrationRef's detachStreamer function.
     */
    func didPauseContentMonitoring()
    
    /**
     This function will be called when main content monitoring needs to be resumed.
     This function is used to call CVAGoogleIMAIntegrationRef's attachStreamer function.
     - Parameters:
        - player: The player instance which needs to be attached for monitoring.
     */
    func didResumeContentMonitoring(player : Any)
    
    /**
     This function will be called post content monitoring is paused.
     This function is used to call CVAGoogleIMAIntegrationRef's adStart function.
     */
    func didNotifyAdStart()
    
    /**
     This function will be called before content monitoring is resumed.
     This function is used to call CVAGoogleIMAIntegrationRef's adStart function.
     */
    func didNotifyAdEnd()
    
    /**
     This function will be called to report ad playback state.
     This function is used to call CVAGoogleIMAIntegrationRef's setAdPlayerState function.
     - Parameters:
        - state: The ad player state.
     */
    func didReportAdPlaybackState(state : ConvivaAdPlayerState)
    
    /**
     This function will be called to report ad manager name.
     This function is used to call CVAGoogleIMAIntegrationRef's setAdPlayername function.
     - Parameters:
        - name: The ad manager name.
     */
    func didReportAdManagerName(name : String)
    
    /**
     This function will be called to report ad manager version.
     This function is used to call CVAGoogleIMAIntegrationRef's setAdManagerVersion function.
     - Parameters:
        - name: The ad manager version.
     */
    func didReportAdManagerVersion(version : String)
    
    /**
     This function will be called to report ad player buffer length.
     This function is used to call CVAGoogleIMAIntegrationRef's setAdPlayerBufferlength function.
     - Parameters:
        - bl: The value of buffer length.
     */
    func didReportAdPlayerBufferlength(bl : NSInteger)
    
    /**
     This function will be called to report ad player play head time.
     This function is used to call CVAGoogleIMAIntegrationRef's setAdPlayHeadTime function.
     - Parameters:
        - pht: The value of play head time.
     */
    func didReportAdPlayHeadTime(pht : NSInteger)
    
    /**
     This function will be called to report ad player width and height.
     This function is used to call CVAGoogleIMAIntegrationRef's setAdVideoResolution function.
     - Parameters:
        - width: The value of width.
        - height: The value of height.
     */
    func didReportAdVideoResolution(width : NSInteger, height: NSInteger)
    
    /**
     This function will be called to report ad player error.
     This function is used to call CVAGoogleIMAIntegrationRef's reportAdError function.
     - Parameters:
        - error: The error message.
     */
    func didReportAdError(error : String)
    
    /**
     This function will be called to report a custom event.
     This function is used to call CVAGoogleIMAIntegrationRef's sendEvent function.
     - Parameters:
        - eventName: The event name.
        - eventAttributes: The event dictionary
     */
    func didReportCustomEvent(eventName: String, eventAttributes : [String : Any])

}

/// A struct which is used to implement CVAAdsEventsManagerProtocol requirements for listening to callbacks from the ad Manager and making required Conviva calls.
/// This struct will contain the functional implementation for handling and calling Conviva APIs.
/// Ad manager classes like CVAGoogleIMAHandler etc will call these functions to interact with Conviva.

@objc(CVAAdsEventsManager)

public class CVAAdsEventsManager : NSObject, CVAAdsEventsManagerProtocol {
    /**
 
    */
    var convivaContentSession : ConvivaLightSession!

    /**
     The CVAGoogleIMAIntegrationRef instance which is used to call all of Conviva AVPlayer library's behaviour.
     */
    var convivaGoogleIMAIntegrationRef : CVAGoogleIMAIntegrationRef!
    
    /**
     The CVAAdsEventsManager class initializer.
     Initialization of integration reference classes like CVAGoogleIMAIntegrationRef etc should happen here.
     */
    public required override init() {
        convivaGoogleIMAIntegrationRef = CVAGoogleIMAIntegrationRef()
    }

    /**
     This function will be called when ad manager is going to start playback.
     This function is used to call CVAGoogleIMAIntegrationRef's createAdSession function.
     - Parameters:
        - adManager: The ad manager instance which is going to start the playback.
        - contentInfo: The ConvivaContentInfo instance which contains metadata information.
     */
    func willStartAdPlayback(adManager: Any?, contentInfo : ConvivaContentInfo) {
        convivaGoogleIMAIntegrationRef.createAdsession(streamer: adManager, contentInfo: contentInfo, contentSession: self.convivaContentSession)
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
        - error: The error string
        - contentInfo: The ConvivaContentInfo instance which contains metadata information.
     */
    func didFailAdPlayback(adManager: Any?, error : String, contentInfo : ConvivaContentInfo) {
        self.willStartAdPlayback(adManager: nil, contentInfo: contentInfo)
        self.didReportAdError(error: error)
    }
    
    /**
     This function will be called when ad manager completes the playback of ad.
     This function is used to call CVAGoogleIMAIntegrationRef's cleanupSession function.
     */
    func didStopAdPlayback() {
        convivaGoogleIMAIntegrationRef.cleanupAdsession()
    }
    
    /**
     This function is used to call CVAAVPlayerIntegrationRef's cleanupSession function.
     */
    func didStopContentPlayback() {
        convivaGoogleIMAIntegrationRef.cleanupContentSession()
    }

    /**
     This function will be called when main content monitoring needs to be paused.
     This function is used to call CVAGoogleIMAIntegrationRef's detachStreamer function.
     */
    func didPauseContentMonitoring() {
        convivaGoogleIMAIntegrationRef.detachPlayer()
    }
    
    /**
     This function will be called when main content monitoring needs to be resumed.
     This function is used to call CVAGoogleIMAIntegrationRef's attachStreamer function.
     - Parameters:
        - player: The player instance which needs to be attached for monitoring.
     */
    func didResumeContentMonitoring(player : Any) {
        convivaGoogleIMAIntegrationRef.attachPlayer(player: player)
    }
    
    /**
     This function will be called post content monitoring is paused.
     This function is used to call CVAGoogleIMAIntegrationRef's adStart function.
     */
    func didNotifyAdStart() {
        convivaGoogleIMAIntegrationRef.adStart()
    }
    
    /**
     This function will be called before content monitoring is resumed.
     This function is used to call CVAGoogleIMAIntegrationRef's adStart function.
     */
    func didNotifyAdEnd() {
        convivaGoogleIMAIntegrationRef.adEnd()
    }
    
    /**
     This function will be called to report ad playback state.
     This function is used to call CVAGoogleIMAIntegrationRef's setAdPlayerState function.
     - Parameters:
        - state: The ad player state.
     */
    func didReportAdPlaybackState(state : ConvivaAdPlayerState) {
        convivaGoogleIMAIntegrationRef.setAdPlayerState(state: state)
    }
    
    /**
     This function will be called to report ad manager name.
     This function is used to call CVAGoogleIMAIntegrationRef's setAdPlayername function.
     - Parameters:
        - name: The ad manager name.
     */
    func didReportAdManagerName(name : String) {
        convivaGoogleIMAIntegrationRef.setAdPlayername(name: name)
    }
    
    /**
     This function will be called to report ad manager version.
     This function is used to call CVAGoogleIMAIntegrationRef's setAdManagerVersion function.
     - Parameters:
        - name: The ad manager version.
     */
    func didReportAdManagerVersion(version : String) {
        convivaGoogleIMAIntegrationRef.setAdManagerVersion(version: version)
    }
    
    /**
     This function will be called to report ad player buffer length.
     This function is used to call CVAGoogleIMAIntegrationRef's setAdPlayerBufferlength function.
     - Parameters:
        - bl: The value of buffer length.
     */
    func didReportAdPlayerBufferlength(bl : NSInteger) {
        convivaGoogleIMAIntegrationRef.setAdPlayerBufferlength(bl: bl)
    }
    
    /**
     This function will be called to report ad player play head time.
     This function is used to call CVAGoogleIMAIntegrationRef's setAdPlayHeadTime function.
     - Parameters:
        - pht: The value of play head time.
     */
    func didReportAdPlayHeadTime(pht : NSInteger) {
        convivaGoogleIMAIntegrationRef.setAdPlayHeadTime(pht: pht)
    }
    
    /**
     This function will be called to report ad player width and height.
     This function is used to call CVAGoogleIMAIntegrationRef's setAdVideoResolution function.
     - Parameters:
        - width: The value of width.
        - height: The value of height.
     */
    func didReportAdVideoResolution(width : NSInteger, height: NSInteger) {
        convivaGoogleIMAIntegrationRef.setAdVideoResolution(width: width, height: height)
    }
    
    /**
     This function will be called to report ad player error.
     This function is used to call CVAGoogleIMAIntegrationRef's reportAdError function.
     - Parameters:
        - error: The error message.
     */
    func didReportAdError(error : String) {
        convivaGoogleIMAIntegrationRef.reportAdError(error: error)
    }
    
    /**
     This function will be called to report a custom event.
     This function is used to call CVAGoogleIMAIntegrationRef's sendEvent function.
     - Parameters:
     - event: The event object.
     */
    func didReportCustomEvent(eventName: String, eventAttributes : [String : Any]) {
        convivaGoogleIMAIntegrationRef.sendCustomEvent(eventName: eventName, eventAttributes: eventAttributes)

    }
}

