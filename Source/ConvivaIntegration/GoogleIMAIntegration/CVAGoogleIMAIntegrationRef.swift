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
import GoogleInteractiveMediaAds

/// A class used to keep all methods used for Conviva Google IMA integration.
class CVAGoogleIMAIntegrationRef : IMAAdsLoaderDelegate, IMAAdsManagerDelegate {
    var contentSession : ConvivaLightSession?
    var adSession : ConvivaLightSession?
    var adsLoader : IMAAdsLoader?
    
    /// This will be used to get the calls directly from Google IMA adsLoader, inject Conviva code and then return the call back to CVAGoogleIMAHandler for further processing
    var adsLoaderDelegate : CVAGoogleIMAHandler?
    
    /// This will be used to get the calls directly from Google IMA adsManager, inject Conviva code and then return the call back to CVAGoogleIMAHandler for further processing
    var adsManagerDelegate : CVAGoogleIMAHandler?
    var contentPlayer : Any?
    var adIndex : Int?
    var podDuration : Int?
    var adBreak : Int?
    var podPosition : String?
    var isContentPaused : Bool?

    func setConvivaAdsLoaderDelegate(delegate : CVAGoogleIMAHandler) -> Any {
        self.adsLoaderDelegate = delegate
        return self
    }

    func setConvivaAdsManagerDelegate(delegate : CVAGoogleIMAHandler) -> Any {
        self.adsManagerDelegate = delegate
        return self
    }
    
    // This is will be called when Content Player is set up in CVAGoogleIMAHandler
    
    // TBD. Either to use folloing 3 methods or to use respective methods from CVAAVPlayerIntegrationRef.
    
    func createContentsession(streamer : Any, contentInfo : ConvivaContentInfo) {
        if(self.contentSession == nil) {
            self.contentPlayer = streamer
            self.contentSession = LivePass.createSession(withStreamer: streamer, andConvivaContentInfo: contentInfo)
        }
    }

    func attachPlayer(streamer : Any) {
        if(self.contentSession != nil && self.adIndex != -1){
            self.contentSession?.attachStreamer(streamer)
            LivePass.adEnd(self.contentSession)
        }
    }
    
    func detachPlayer() {
        if(self.contentSession != nil){
            self.contentSession!.pauseMonitor()
            LivePass.adStart(self.contentSession)
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
    func createAdsession(streamer : Any?, contentInfo : ConvivaContentInfo) {
        if(self.adSession == nil){
            self.adSession = LivePass.createAdSession(streamer, contentSession: self.contentSession, convivaContentInfo: contentInfo, options: nil)
        }
    }
    
    /**
     Used to cleanup a Conviva monitoring session for content.
     */
    func cleanupContentsession() {
        self.adBreak = 0;
        if(self.contentSession != nil){
            LivePass.cleanupSession(self.contentSession)
            self.contentSession = nil;
        }
    }

    /**
     Used to cleanup a Conviva monitoring session for ad.
     */
    func cleanupAdsession() {
        if(self.adSession != nil){
            LivePass.cleanupSession(self.adSession)
            self.adSession = nil;
        }
    }

    /**
     Used to set Ad Player State.
     - Parameters:
        - state: The play state of ad.
     */
    func setAdPlayerState(state : ConvivaAdPlayerState) {
        if(self.adSession != nil){
            self.adSession?.setAdPlayerState(state)
        }
    }
    
    /**
     Used to set Ad Player manager name.
     - Parameters:
        - name: The name of ad player manager.
     */
    func setAdPlayername(name : String) {
        if(self.adSession != nil){
            self.adSession?.setAdPlayerName(name)
        }
    }

    /**
     Used to set Ad Player manager version.
     - Parameters:
        - version: The version of ad player manager.
     */
    func setAdManagerVersion(version : String) {
        if(self.adSession != nil){
            self.adSession?.setAdPlayerVersion(version)
        }
    }

    /**
     Used to report Ad Playback errors.
     - Parameters:
        - error: The playback error string.
     */
    func reportAdError(error : String) {
        if(self.adSession != nil){
            self.adSession?.reportError(error, errorType: ErrorSeverity.SEVERITY_FATAL)
        }
    }
    
    /**
     Used to report Ad playback buffer length.
     - Parameters:
        - bl: The buffer length value.
     */
    func setAdPlayerBufferlength(bl : NSInteger) {
        if(self.adSession != nil){
            self.adSession?.setAdBufferLength(bl)
        }
    }
    
    /**
     Used to report Ad playback play head time.
     - Parameters:
        - pht: The play head time value.
     */
    func setAdPlayHeadTime(pht : NSInteger) {
        if(self.adSession != nil){
            self.adSession?.setAdPlayHeadTime(pht)
        }
    }

    /**
     Used to report Ad playback resolution.
     - Parameters:
        - width: The resolution width value.
        - height: The resolution height value.
     */
    func setAdVideoResolution(width : NSInteger, height: NSInteger) {
        if(self.adSession != nil){
            self.adSession?.setAdVideoResolutionWidth(width, andHeight: height)
        }
    }
    
    // MARK:- IMAAdsLoaderDelegate methods
    /**
     *  Called when ads are successfully loaded from the ad servers by the loader.
     *
     *  @param loader        the IMAAdsLoader that received the loaded ad data
     *  @param adsLoadedData the IMAAdsLoadedData instance containing ad data
     */
    public func adsLoader(_ loader: IMAAdsLoader!, adsLoadedWith adsLoadedData: IMAAdsLoadedData!) {
        
        /// 1. Insert Conviva related code.
        /// No Conviva action required at this step.
        
        /// 2. Return the call back to CVAGoogleIMAHandler for further processing.
        if(self.adsLoaderDelegate != nil){
            self.adsLoaderDelegate?.adsLoader(loader, adsLoadedWith: adsLoadedData)
        }
    }
    
    /**
     *  Error reported by the ads loader when loading or requesting an ad fails.
     *
     *  @param loader      the IMAAdsLoader that received the error
     *  @param adErrorData the IMAAdLoadingErrorData instance with error information
     */
    public func adsLoader(_ loader: IMAAdsLoader!, failedWith adErrorData: IMAAdLoadingErrorData!) {
        
        /// 1. Insert Conviva related code.
        
        let error : IMAAdError = adErrorData.adError
        let errorString : String = "errorType : \(error.type.rawValue)  errorCode : \(error.code)  errorMessage : \(error.message ?? "") "
        let metadata : ConvivaContentInfo = ConvivaContentInfo.createInfoForLightSession(withAssetName: "Ad Loader Error") as! ConvivaContentInfo
        createAdsession(streamer: nil, contentInfo: metadata)
        reportAdError(error: errorString)
        cleanupAdsession()
        
        if let contentPlayer = self.contentPlayer {
            attachPlayer(streamer: contentPlayer)
        }
        
        /// 2. Return the call back to CVAGoogleIMAHandler for further processing.
        
        if(self.adsLoaderDelegate != nil){
            self.adsLoaderDelegate?.adsLoader(loader, failedWith: adErrorData)
        }
    }
    
    // MARK:- IMAAdsManagerDelegate methods
    /**
     *  Called when there is an IMAAdEvent.
     *
     *  @param adsManager the IMAAdsManager receiving the event
     *  @param event      the IMAAdEvent received
     */
    public func adsManager(_ adsManager: IMAAdsManager!, didReceive event: IMAAdEvent!) {
        
        /// 1. Insert Conviva related code.
        
        let adInfo : IMAAd = event.ad
        let podInfo : IMAAdPodInfo = adInfo.adPodInfo
        
        switch event.type {
        case IMAAdEventType.LOADED:
            print("")
            self.adIndex = podInfo.podIndex
            self.podDuration = Int(podInfo.maxDuration)
            if(!podInfo.isBumper){
                self.podPosition = podInfo.podIndex == 0 ? "Pre-roll" : (podInfo.podIndex == -1 ? "Post-roll": "Mid-roll");
            }
            
            var dict : [String : Any] = [:]
            dict["c3.ad.id"] = adInfo.adId
            dict["c3.ad.system"] = adInfo.adSystem
            
            dict["c3.ad.id"] = adInfo.adId
            
            if (adInfo.advertiserName.count > 0) {
                dict["c3.ad.advertiser"] = adInfo.advertiserName
            }
            else {
                dict["c3.ad.advertiser"] = "NA"
            }
            
            dict["c3.ad.creativeId"] = adInfo.creativeID
            dict["c3.ad.sequence"] = podInfo.adPosition
            dict["c3.ad.technology"] = "Client Side"
            dict["c3.ad.position"] = self.podPosition
            dict["c3.ad.mediaFileApiFramework"] = "NA"
            dict["c3.ad.type"] = "NA"
            dict["c3.ad.adManagerName"] = "Google IMA SDK"
            dict["c3.ad.adManagerVersion"] = IMAAdsLoader.sdkVersion()
            dict["c3.ad.unitName"] = "NA"
            dict["c3.ad.creativeName"] = "NA"
            dict["c3.ad.breakId"] = "NA"
            dict["c3.ad.category"] = "NA"
            dict["c3.ad.classification"] = "NA"
            dict["c3.ad.advertiserCategory"] = "NA"
            dict["c3.ad.advertiserId"] = "NA"
            dict["c3.ad.campaignName"] = "NA"
            dict["c3.ad.dayPart"] = "NA"
            dict["c3.ad.isSlate"] = "false"
            
            let metadata : ConvivaContentInfo = ConvivaContentInfo.createInfoForLightSession(withAssetName: adInfo.adTitle) as! ConvivaContentInfo
            metadata.contentLength = Int(adInfo.duration)
            metadata.streamUrl = "adtag_url"
            
            if(adInfo.wrapperAdIDs.count > 0){
                dict["c3.ad.firstAdId"] = adInfo.wrapperAdIDs.last
            }
            else {
                dict["c3.ad.firstAdId"] = adInfo.adId
            }
            
            if(adInfo.wrapperSystems.count > 0){
                dict["c3.ad.firstAdSystem"] = adInfo.wrapperSystems.last
            }
            else{
                dict["c3.ad.firstAdSystem"] = adInfo.adSystem
            }
            
            if(adInfo.wrapperCreativeIDs.count > 0){
                dict["c3.ad.firstCreativeId"] = adInfo.wrapperCreativeIDs.last
            }
            else{
                dict["c3.ad.firstCreativeId"] = adInfo.creativeID
            }
            
            metadata.tags = dict as? NSMutableDictionary
            createAdsession(streamer: adsManager, contentInfo: metadata)
            setAdPlayerState(state: .CONVIVA_AD_BUFFERING)
            setAdManagerVersion(version: IMAAdsLoader.sdkVersion())
            setAdPlayername(name: "Google-IMA")
            
        case IMAAdEventType.PAUSE:
            setAdPlayerState(state: .CONVIVA_AD_PAUSED)
            setAdPlayHeadTime(pht: NSInteger(adsManager.adPlaybackInfo?.currentMediaTime ?? 0))
            setAdPlayerBufferlength(bl: NSInteger(adsManager.adPlaybackInfo?.bufferedMediaTime ?? 0))
            
        case IMAAdEventType.RESUME:
            setAdPlayerState(state: .CONVIVA_AD_PLAYING)
            
            setAdPlayHeadTime(pht: NSInteger(adsManager.adPlaybackInfo?.currentMediaTime ?? 0) )
            setAdPlayerBufferlength(bl: NSInteger( adsManager.adPlaybackInfo?.bufferedMediaTime ?? 0) )
            setAdVideoResolution(width: adInfo.width, height: adInfo.height)
            
        case IMAAdEventType.STARTED:
            setAdPlayerState(state: .CONVIVA_AD_PLAYING)
            setAdPlayHeadTime(pht: NSInteger( adsManager.adPlaybackInfo?.currentMediaTime ?? 0) )
            setAdPlayerBufferlength(bl: NSInteger(adsManager.adPlaybackInfo?.bufferedMediaTime ?? 0) )
            setAdVideoResolution(width: adInfo.width, height: adInfo.height)
            
        case IMAAdEventType.COMPLETE:
            cleanupAdsession()
            
        case IMAAdEventType.ALL_ADS_COMPLETED:
            cleanupAdsession()
            if(podInfo.podIndex == -1){
                cleanupContentsession()
            }
            
        case IMAAdEventType.SKIPPED:
            cleanupAdsession()
            
        case IMAAdEventType.LOG:
            let dict : [String : Any]? = event.adData?["logData"] as? [String : Any]
            
            if let dict = dict {
                if dict.count > 0 {
                    let errorType : String = dict["type"] as! String
                    let errorCode : String = dict["errorCode"] as! String
                    let errorMsg : String = dict["errorMessage"] as! String
                    
                    let errorString : String = "type: \(errorType) code: \(errorCode) msg: \(errorMsg)"
                    reportAdError(error: errorString)
                    cleanupAdsession()
                }
            }
            
        default:
            print("")
        }
        
        /// 2. Return the call back to CVAGoogleIMAHandler for further processing.

        if(self.adsManagerDelegate != nil) {
            self.adsManagerDelegate?.adsManager(adsManager, didReceive: event)
        }
    }
    
    /**
     *  Called when there was an error playing the ad.
     *  Log the error and resume playing content.
     *
     *  @param adsManager the IMAAdsManager that errored
     *  @param error      the IMAAdError received
     */
    public func adsManager(_ adsManager: IMAAdsManager!, didReceive error: IMAAdError!) {
        
        /// 1. Insert Conviva related code.

        let errorType = error.type
        let errorCode = error.code
        let errorString : String = "type: \(errorType) code: \(errorCode) message: \(String(describing: error.message))"
        
        let metadata : ConvivaContentInfo = ConvivaContentInfo.createInfoForLightSession(withAssetName: "Ad Manager Error") as! ConvivaContentInfo
        createAdsession(streamer: adsManager, contentInfo: metadata)
        reportAdError(error: errorString)
        cleanupAdsession()
        
        /// 2. Return the call back to CVAGoogleIMAHandler for further processing.

        if(self.adsManagerDelegate != nil) {
            self.adsManagerDelegate?.adsManager(adsManager, didReceive: error)
        }
    }
    
    /**
     *  Called when an ad is ready to play.
     *  The implementing code should pause the content playback and prepare the UI
     *  for ad playback.
     *
     *  @param adsManager the IMAAdsManager requesting content pause
     */
    public func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager!) {
        
        /// 1. Insert Conviva related code.

        detachPlayer()
        self.adBreak = self.adBreak! + 1;
        self.isContentPaused = true;
        if(self.contentSession != nil) {
            var podStartAttributes : [String : Any] = [:]
            podStartAttributes["podIndex"] = self.adBreak
            podStartAttributes["podDuration"] = self.podDuration
            podStartAttributes["podPosition"] = self.podPosition
            self.contentSession?.sendEvent("Conviva.PodStart", withAttributes: podStartAttributes)
        }
        
        /// 2. Return the call back to CVAGoogleIMAHandler for further processing.

        if(self.adsManagerDelegate != nil) {
            self.adsManagerDelegate?.adsManagerDidRequestContentPause(adsManager)
        }
    }
    
    /**
     *  Called when an ad has finished or an error occurred during the playback.
     *  The implementing code should resume the content playback.
     *
     *  @param adsManager the IMAAdsManager requesting content resume
     */
    public func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager!) {
        
        /// 1. Insert Conviva related code.

        if let streamer = self.contentPlayer {
            attachPlayer(streamer: streamer)
        }
        if(self.contentSession != nil && self.isContentPaused ?? false){
            self.isContentPaused = false;
            
            var podEndAttributes : [String : Any] = [:]
            podEndAttributes["podIndex"] = self.adBreak
            podEndAttributes["podDuration"] = self.podDuration
            podEndAttributes["podPosition"] = self.podPosition
            self.contentSession?.sendEvent("Conviva.PodEnd", withAttributes: podEndAttributes)
        }

        /// 2. Return the call back to CVAGoogleIMAHandler for further processing.

        if(self.adsManagerDelegate != nil) {
            self.adsManagerDelegate?.adsManagerDidRequestContentResume(adsManager)
        }
    }
}
