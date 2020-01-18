//
//  CVAGoogleIMAIntegrationRef.swift
//  ConvivaIntegrationRefKit
//
//  Created by Gaurav Tiwari on 15/11/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

import Foundation
import ConvivaCore
import ConvivaAVFoundation

/// A class used to keep all methods used for Conviva Google IMA integration.
/// This class is set as the delegate of Google IMA ad loader. This will be used to inject Conviva calls based on the callbacks recieved from Google IMA' ad loader.
/// This class is also set as the delegate of Google IMA ad manager. This will be used to inject Conviva calls based on the callbacks recieved from Google IMA' ad manager.

class CVAGoogleIMAIntegrationRef : CVABaseIntegrationRef {
    
    /**
     Following variable of type ConvivaLightSession will be used to execute all of the ad specific Conviva moniting.
     */
    var convivaAdSession : ConvivaLightSession?
    
    /**
     Following variable of type ConvivaLightSession will be used to create convivaAdSession.
     Used for creating ad session and other API calls like adStart and adEnd.
     */
    var convivaVideoSession : ConvivaLightSession?        

    /**
     The CVAGoogleIMAIntegrationRef class initializer.
     */
    override init() {
        super.init()
    }
    
    /**
     Used to attach a streamer instance which can be monitored.
     - Parameters:
        - player: The streamer instance which needs to be monitored. For ConvivaAVFounation integration, player must be an AVPlayer instance
     */
    override func attachPlayer(player: Any) {
        if player is AVPlayer {
            if let session = self.convivaVideoSession {
                session.attachStreamer(player)
            }
            else {
                print(Conviva.Errors.typeNotAVPlayer)
            }
        }
    }
    
    /**
     Used to detach the earlier attached streamer instance.
     It should be called when a streamer object has been attached using attachPlayer earlier.
     */
    override func detachPlayer() {
        if let session = self.convivaVideoSession {
            session.pauseMonitor()
        }
    }

    /**
     This function should be called when main content's monitoring is paused.
     i.e. Call adStart(), post calling detachPlayer().
     */
    func adStart() {
        if(self.convivaVideoSession != nil){
            LivePass.adStart(self.convivaVideoSession)
        }
    }

    /**
     This function should be called when main content's monitoring is resumed.
     i.e. Call adEnd(), post calling attachPlayer().
     */
    func adEnd() {
        if(self.convivaVideoSession != nil){
            LivePass.adEnd(self.convivaVideoSession)
        }
    }
    
    /**
     Used to create a Conviva monitoring session for ads.
     - Parameters:
        - streamer: The streamer instance which needs to be monitored.
        - contentInfo: The initial set of metadata values related to a ad playback.
     If the initial values are not available, this paramter can be nil as well.
     If the values need to be updated later, please use updateContentMetadata.
     Visit https://community.conviva.com/site/global/platforms/ios/av_player/index.gsp#updateContentMetadata
     */
    func createAdsession(streamer : Any?, contentInfo : ConvivaContentInfo, contentSession : ConvivaLightSession) {
        self.convivaVideoSession = contentSession
        
        if(self.convivaAdSession == nil){
            self.convivaAdSession = LivePass.createAdSession(streamer, contentSession: self.convivaVideoSession, convivaContentInfo: contentInfo, options: nil)
        }
    }
    
    /**
     Used to cleanup a Conviva monitoring session for ad.
     */
    func cleanupAdsession() {
        if(self.convivaAdSession != nil){
            LivePass.cleanupSession(self.convivaAdSession)
            self.convivaAdSession = nil;
        }
    }

    /**
     Used to cleanup a Conviva monitoring session.
     */
    func cleanupContentSession() {
        if  self.convivaVideoSession != nil {
            LivePass.cleanupSession(self.convivaVideoSession)
            self.convivaVideoSession = nil
        }
    }

    /**
     Used to set Ad Player State.
     - Parameters:
        - state: The play state of ad.
     */
    func setAdPlayerState(state : ConvivaAdPlayerState) {
        if(self.convivaAdSession != nil){
            self.convivaAdSession?.setAdPlayerState(state)
        }
    }
    
    /**
     Used to set Ad Player manager name.
     - Parameters:
        - name: The name of ad player manager.
     */
    func setAdPlayername(name : String) {
        if(self.convivaAdSession != nil){
            self.convivaAdSession?.setAdPlayerName(name)
        }
    }

    /**
     Used to set Ad Player manager version.
     - Parameters:
        - version: The version of ad player manager.
     */
    func setAdManagerVersion(version : String) {
        if(self.convivaAdSession != nil){
            self.convivaAdSession?.setAdPlayerVersion(version)
        }
    }

    /**
     Used to report Ad Playback errors.
     - Parameters:
        - error: The playback error string.
     */
    func reportAdError(error : String) {
        if(self.convivaAdSession != nil){
            self.convivaAdSession?.reportError(error, errorType: ErrorSeverity.SEVERITY_FATAL)
        }
    }
    
    /**
     Used to report Ad playback buffer length.
     - Parameters:
        - bl: The buffer length value.
     */
    func setAdPlayerBufferlength(bl : NSInteger) {
        if(self.convivaAdSession != nil){
            self.convivaAdSession?.setAdBufferLength(bl)
        }
    }
    
    /**
     Used to report Ad playback play head time.
     - Parameters:
        - pht: The play head time value.
     */
    func setAdPlayHeadTime(pht : NSInteger) {
        if(self.convivaAdSession != nil){
            self.convivaAdSession?.setAdPlayHeadTime(pht)
        }
    }

    /**
     Used to report Ad playback resolution.
     - Parameters:
        - width: The resolution width value.
        - height: The resolution height value.
     */
    func setAdVideoResolution(width : NSInteger, height: NSInteger) {
        if(self.convivaAdSession != nil){
            self.convivaAdSession?.setAdVideoResolutionWidth(width, andHeight: height)
        }
    }
    
    /**
     Used to send a custom event e.g. PodStart or PodEnd events to Conviva.
     You may send a custom Player Insight event that is or is not associated with a monitoring session.
     - Parameters:
        - eventName: Event name of type String
        - eventAttributes: Event Attributes of type Dictionary
     */

    override func sendCustomEvent(eventName: String, eventAttributes : [String : String]) {
        if (self.convivaVideoSession != nil){
            self.convivaVideoSession!.sendEvent(eventName, withAttributes: eventAttributes)
        }
    }
}
