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
/// This class is set as the delegate of Google IMA ad loader. This will be used to inject Conviva calls based on the callbacks recieved from Google IMA' ad loader.
/// This class is also set as the delegate of Google IMA ad manager. This will be used to inject Conviva calls based on the callbacks recieved from Google IMA' ad manager.

class CVAGoogleIMAIntegrationRef : CVAAVPlayerIntegrationRef {
    
    /**
     Following variable of type ConvivaLightSession will be used to execute all of the ad specific Conviva moniting.
     */
    var convivaAdSession : ConvivaLightSession?
    
    /**
     Following variable of type ConvivaLightSession will be used to execute all of the ad specific Conviva moniting.
     */
    var convivaVideoSession : ConvivaLightSession?

    /**
     Following variable of type CVAGoogleIMAHandler will be used to get the calls directly from Google IMA adsLoader, inject Conviva code and then return the call back to CVAGoogleIMAHandler for further processing related to ad/content playback based on Google IMA adsLoader callbacks.
     */
    var adsLoaderDelegate : CVAGoogleIMAHandler?
    
    /**
     Following variable of type CVAGoogleIMAHandler will be used to get the calls directly from Google IMA adsManager, inject Conviva code and then return the call back to CVAGoogleIMAHandler for further processing related to ad/content playback based on Google IMA adsManager callbacks.
     */
    var adsManagerDelegate : CVAGoogleIMAHandler?
    
    /**
     The instance of player which is used to play content.
     */
    var contentPlayer : Any?
    
    /**
     Following variable of type Int will be used to track Index of ads as reported by Google IMA's podInfo.
     */
    var adIndex : Int?
    
    /**
     Following variable of type Int will be used to track pod duration as reported by Google IMA's podInfo.
     */
    var podDuration : Int?
    
    /**
     Following variable of type Int will be used to track ad breaks.
     */
    var adBreak : Int = 0
    
    /**
     Following variable of type Int will be used to track pod position as reported by Google IMA's podInfo.
     */
    var podPosition : String?
    
    /**
     Following variable of type Int will be used to determine if content is paused or not, as reported by Google IMA's IMAAdsManager.
     */
    var isContentPaused : Bool?

    override init() {
        super.init()
        self.convivaVideoSession = getConvivaContentSession()
    }
    
    /**
     Following function set adsLoaderDelegate variable as CVAGoogleIMAHandler's instance.
     Will be called from CVAGoogleIMAHandler as part of ad loader setup.
     This is done to get the calls directly from Google IMA adsLoader, inject Conviva code and then return the call back to CVAGoogleIMAHandler for further processing related to ad/content playback based on Google IMA adsLoader callbacks.
     - Parameters:
        - delegate: Instance of type CVAGoogleIMAHandler
     - Returns: Return self variable which will be set as Google IMA's adsLoaderDelegate.
     */
    func setConvivaAdsLoaderDelegate(delegate : CVAGoogleIMAHandler) -> Any {
        self.adsLoaderDelegate = delegate
        return self
    }

    /**
     Following function set adsManagerDelegate variable as CVAGoogleIMAHandler's instance.
     Will be called from CVAGoogleIMAHandler as part of ad manager setup.
     This is done to get the calls directly from Google IMA adsManager, inject Conviva code and then return the call back to CVAGoogleIMAHandler for further processing related to ad/content playback based on Google IMA adsManager callbacks.
     - Parameters:
        - delegate: Instance of type CVAGoogleIMAHandler
     - Returns: Return self variable which will be set as Google IMA's adsManagerDelegate.
     */
    func setConvivaAdsManagerDelegate(delegate : CVAGoogleIMAHandler) -> Any {
        self.adsManagerDelegate = delegate
        return self
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
        if(self.convivaVideoSession != nil && self.adIndex != -1){
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
    func createAdsession(streamer : Any?, contentInfo : ConvivaContentInfo) {
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
}

/// An extension of class CVAGoogleIMAIntegrationRef which is used to implement IMAAdsLoaderDelegate functions.
extension CVAGoogleIMAIntegrationRef : IMAAdsLoaderDelegate {
    /**
     *  Called when ads are successfully loaded from the ad servers by the loader.
     *
     *  @param loader        the IMAAdsLoader that received the loaded ad data
     *  @param adsLoadedData the IMAAdsLoadedData instance containing ad data
     */
    public func adsLoader(_ loader: IMAAdsLoader!, adsLoadedWith adsLoadedData: IMAAdsLoadedData!) {
        print("#Conviva : adsLoader adsLoadedWith")
        /// 1. Insert Conviva related code.
        /// No Conviva action required at this step.
        
        /// 2. Return the call back to CVAGoogleIMAHandler for further processing related to ad/content playback.
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
        print("#Conviva : adsLoader adErrorData \(String(describing: adErrorData.adError.message))")
        
        /// 1. Insert Conviva related code.
        /// If adsLoader has failed, Create a Conviva session, report such error and cleanup the Conviva session.
        
        let error : IMAAdError = adErrorData.adError
        let errorString : String = "errorType : \(error.type.rawValue)  errorCode : \(error.code)  errorMessage : \(error.message ?? "") "
        let metadata : ConvivaContentInfo = ConvivaContentInfo.createInfoForLightSession(withAssetName: "Ad Loader Error") as! ConvivaContentInfo
        createAdsession(streamer: nil, contentInfo: metadata)
        reportAdError(error: errorString)
        cleanupAdsession()
        
        if let contentPlayer = self.contentPlayer {
            attachPlayer(player: contentPlayer)
            adEnd()
        }
        
        /// 2. Return the call back to CVAGoogleIMAHandler for further processing related to ad/content playback.
        
        if(self.adsLoaderDelegate != nil){
            self.adsLoaderDelegate?.adsLoader(loader, failedWith: adErrorData)
        }
    }
}

/// An extension of class CVAGoogleIMAIntegrationRef which is used to implement IMAAdsManagerDelegate functions.
extension CVAGoogleIMAIntegrationRef : IMAAdsManagerDelegate {
    /**
     *  Called when there is an IMAAdEvent.
     *
     *  @param adsManager the IMAAdsManager receiving the event
     *  @param event      the IMAAdEvent received
     */
    public func adsManager(_ adsManager: IMAAdsManager!, didReceive event: IMAAdEvent!) {
        print("#Conviva : adsManager didReceive event : \(String(describing: event.typeString!))")
        
        // When IMAAdEventType.ALL_ADS_COMPLETED, event.ad is coming nil.
        // Following guard condition is done to avoid a crash.
        guard event.type != IMAAdEventType.ALL_ADS_COMPLETED else {
            return
        }
        
        /// 1. Insert Conviva related code.

        let adInfo : IMAAd = event.ad
        
        let podInfo : IMAAdPodInfo = adInfo.adPodInfo
        
        switch event.type {
            
        case IMAAdEventType.LOADED:
            
            /// Once adsManager has recieved the LOADED event, capture the metadata information from event and create a Conviva session for ad monitoring.

            self.adIndex = podInfo.podIndex
            self.podDuration = Int(podInfo.maxDuration)
            if(!podInfo.isBumper){
                self.podPosition = podInfo.podIndex == 0 ? "Pre-roll" : (podInfo.podIndex == -1 ? "Post-roll": "Mid-roll");
            }
            
            let dict : NSMutableDictionary = [:]
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
            
            print("#Conviva : Conviva Asset Name : \(adInfo.adTitle ?? "Conviva Google IMA Session")")
            
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
            
            metadata.tags = dict
            createAdsession(streamer: adsManager, contentInfo: metadata)
            setAdPlayerState(state: .CONVIVA_AD_BUFFERING)
            setAdManagerVersion(version: IMAAdsLoader.sdkVersion())
            setAdPlayername(name: "Google-IMA")
            
        case IMAAdEventType.PAUSE:
            
            /// Once adsManager has recieved the PAUSE event, report relavant values to Conviva.

            setAdPlayerState(state: .CONVIVA_AD_PAUSED)
            setAdPlayHeadTime(pht: NSInteger(adsManager.adPlaybackInfo?.currentMediaTime ?? 0))
            setAdPlayerBufferlength(bl: NSInteger(adsManager.adPlaybackInfo?.bufferedMediaTime ?? 0))
            
        case IMAAdEventType.RESUME:
            
            /// Once adsManager has recieved the RESUME event, report relavant values to Conviva.

            setAdPlayerState(state: .CONVIVA_AD_PLAYING)
            setAdPlayHeadTime(pht: NSInteger(adsManager.adPlaybackInfo?.currentMediaTime ?? 0) )
            setAdPlayerBufferlength(bl: NSInteger( adsManager.adPlaybackInfo?.bufferedMediaTime ?? 0) )
            setAdVideoResolution(width: adInfo.width, height: adInfo.height)
            
        case IMAAdEventType.STARTED:
            
            /// Once adsManager has recieved the STARTED event, report relavant values to Conviva.
            
            setAdPlayerState(state: .CONVIVA_AD_PLAYING)
            setAdPlayHeadTime(pht: NSInteger( adsManager.adPlaybackInfo?.currentMediaTime ?? 0) )
            setAdPlayerBufferlength(bl: NSInteger(adsManager.adPlaybackInfo?.bufferedMediaTime ?? 0) )
            setAdVideoResolution(width: adInfo.width, height: adInfo.height)
            
        case IMAAdEventType.COMPLETE:
            
            /// Once adsManager has recieved the COMPLETE event, cleanup the Conviva Ad session.

            cleanupAdsession()
            
        case IMAAdEventType.ALL_ADS_COMPLETED:
            
            /// Once adsManager has recieved the ALL_ADS_COMPLETED event, cleanup the Conviva Ad session.

            cleanupAdsession()
            if(podInfo.podIndex == -1){
                self.adBreak = 0;
                cleanupContentSession()
            }
            
        case IMAAdEventType.SKIPPED:
            
            /// Once adsManager has recieved the SKIPPED event, cleanup the Conviva Ad session.

            cleanupAdsession()
            
        case IMAAdEventType.LOG:
            
            /// Once adsManager has recieved the LOG event, report an error and cleanup the Conviva Ad session.

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
        
        /// 2. Return the call back to CVAGoogleIMAHandler for further processing related to ad/content playback.
        
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
        print("#Conviva : adsManager didReceive error")
        
        /// 1. Insert Conviva related code.
        /// If adsManager has failed, Create a Conviva session, report such error and cleanup the Conviva session.

        let errorType = error.type
        let errorCode = error.code
        let errorString : String = "type: \(errorType) code: \(errorCode) message: \(String(describing: error.message))"
        
        let metadata : ConvivaContentInfo = ConvivaContentInfo.createInfoForLightSession(withAssetName: "Ad Manager Error") as! ConvivaContentInfo
        createAdsession(streamer: adsManager, contentInfo: metadata)
        reportAdError(error: errorString)
        cleanupAdsession()
        
        /// 2. Return the call back to CVAGoogleIMAHandler for further processing related to ad/content playback.
        
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
        /// Since adsManager has notified ContentPause, pause main content monitoring using detachPlayer() and notify start of ad using adStart().
        detachPlayer()
        adStart()
        self.adBreak = self.adBreak + 1;
        self.isContentPaused = true;
        if(self.convivaVideoSession != nil) {
            var podStartAttributes : [String : Any] = [:]
            podStartAttributes["podIndex"] = self.adBreak
            podStartAttributes["podDuration"] = self.podDuration
            podStartAttributes["podPosition"] = self.podPosition
            self.convivaVideoSession?.sendEvent("Conviva.PodStart", withAttributes: podStartAttributes)
        }
        
        /// 2. Return the call back to CVAGoogleIMAHandler for further processing related to ad/content playback.
        
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
        /// Since adsManager has notified ContentResume, resume main content monitoring using attachPlayer() and notify end of ad using adEnd().

        if let streamer = self.contentPlayer {
            attachPlayer(player: streamer)
            adEnd()
        }
        if(self.convivaVideoSession != nil && self.isContentPaused ?? false){
            self.isContentPaused = false;
            
            var podEndAttributes : [String : Any] = [:]
            podEndAttributes["podIndex"] = self.adBreak
            podEndAttributes["podDuration"] = self.podDuration
            podEndAttributes["podPosition"] = self.podPosition
            self.convivaVideoSession?.sendEvent("Conviva.PodEnd", withAttributes: podEndAttributes)
        }
        
        /// 2. Return the call back to CVAGoogleIMAHandler for further processing related to ad/content playback.
        
        if(self.adsManagerDelegate != nil) {
            self.adsManagerDelegate?.adsManagerDidRequestContentResume(adsManager)
        }
    }
}
