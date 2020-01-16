//
//  CVAGoogleIMA.swift
//  ConvivaIntegrationRefKit
//
//  Created by Gaurav Tiwari on 12/11/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

import Foundation
import GoogleInteractiveMediaAds
import ConvivaCore

/// A class used to keep all methods required for Google IMA setup and notifications handling.
public class CVAGoogleIMAHandler : NSObject {
    /**
     The CVAAVPlayerManager instance which takes care of all Conviva implementation.
     */
    var adEventManager : CVAAdsEventsManager!

    /**
     Google IMA SDK handle for IMAAdsLoader.
     */
    var adsLoader: IMAAdsLoader!
    
    /**
     Playhead used by the SDK to track content video progress and insert mid-rolls..
     */
    var contentPlayhead: IMAAVPlayerContentPlayhead!

    /**
     Google IMA SDK handle for IMAAdsManager.
     */
    var adsManager: IMAAdsManager?
    
    /**
     Content player handles
     */
    var contentPlayer: AVPlayer?

    /**
     Following variable is used to track Ad's play/pause.
     */
    var isAdPlayback = false

    /**
     The CVAAdView instance
     */
    var adContainerView : CVAAdView? = nil;

    /**
     The CVAPlayerResponseHandler instance
     */
    public var responseHandler : CVAAdResponseHandler?;
    
    /**
     The CVAAdDataSource instance
     */
    public var dataSource : CVAAdDataSource?

    /**
     Following variable of type Int will be used to track pod duration as reported by Google IMA's podInfo.
     */
    var podDuration : Int = 0
    
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

    /**
     Following variable of type Int will be used to track Index of ads as reported by Google IMA's podInfo.
     */
    var adIndex : Int?

    #if os(iOS)
    /**
     PiP objects.
     */
    var pictureInPictureController: AVPictureInPictureController?
    var pictureInPictureProxy: IMAPictureInPictureProxy?
    #endif

    /**
     The CVAGoogleIMAHandler class initializer.
     Loading of Google IMA and initialization of the AdsLoader should happen here.
     */
    public override init() {
        super.init()
    }
    
    /**
     Following function initializes the AdsLoader instance.
     */
    func setUpIMA() {
        if (adsLoader != nil) {
            adsLoader = nil
        }

        if (adsManager != nil) {
            adsManager!.destroy()
        }
        
        let settings = IMASettings()
        settings.enableBackgroundPlayback = true;
        adsLoader = IMAAdsLoader(settings: settings)
        self.adBreak = 0;
        adsLoader.delegate = self

        #if os(iOS)
        setUpPiP()
        #endif
    }

}

/// An extension of class CVAGoogleIMAHandler which is used to implement IMAAdsLoaderDelegate functions.
extension CVAGoogleIMAHandler : IMAAdsLoaderDelegate {
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
        
        /// 2. Continue further processing related to ad/content playback.
        /// adsLoader is indicating successful load of ads.
        /// adsManager should be initialized here.
        
        /// Log the String containing IMAAdsLoadedData.
        print("#Conviva: loader adsLoadedWith: \(String(describing: adsLoadedData))")
        
        /// Grab the instance of the IMAAdsManager
        self.adsManager = adsLoadedData.adsManager;
        
        /// Set ads manager's delegate.
        self.adsManager?.delegate = self
        
        /// Initialize the ads manager.
        let adsRenderingSettings = IMAAdsRenderingSettings()
        adsManager!.initialize(with: adsRenderingSettings)
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
        /// Since adsLoader has failed and reported error, Create a Conviva session will nil streamer, report such error and cleanup the Conviva session.
        
        let error : IMAAdError = adErrorData.adError
        let errorString : String = "errorType : \(error.type.rawValue)  errorCode : \(error.code)  errorMessage : \(error.message ?? "") "
        let metadata : ConvivaContentInfo = ConvivaContentInfo.createInfoForLightSession(withAssetName: "Ad Loader Error") as! ConvivaContentInfo
        
        /// Following function creates a Conviva session will nil streamer and reports the error.
        adEventManager.didFailAdPlayback(adManager: nil, error: errorString, contentInfo: metadata)
        
        /// Following function cleans up the Conviva session.
        adEventManager.didStopAdPlayback()
        
        /// After ad session cleanup, resume the main content monitoring.
        if let contentPlayer = self.contentPlayer {
            adEventManager.didResumeContentMonitoring(player: contentPlayer)
            if (self.adIndex != -1) {
                adEventManager.didNotifyAdEnd()
            }
        }
        
        /// 2. Continue further processing related to ad/content playback.
        
        /// Log the error.
        print("#Conviva: Error loading ads: \(adErrorData.adError.message ?? "s")")
        
        /// Resume the content.
        isAdPlayback = false
        if let contentPlayer = contentPlayer {
            contentPlayer.play()
        }
    }
}

/// An extension of class CVAGoogleIMAHandler which is used to implement IMAAdsManagerDelegate functions.
extension CVAGoogleIMAHandler : IMAAdsManagerDelegate {
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
        
        guard event != nil else {
            return
        }
        
        guard event.type != IMAAdEventType.ALL_ADS_COMPLETED else {
            return
        }
        
        /// 1. Insert Conviva related code.
        
        guard event.ad != nil else {
            return
        }

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
            dict["c3.ad.sequence"] = String(podInfo.adPosition)
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
            
            adEventManager.willStartAdPlayback(adManager: adsManager, contentInfo: metadata)

            adEventManager.didReportAdPlaybackState(state: .CONVIVA_AD_BUFFERING)
            adEventManager.didReportAdManagerVersion(version: IMAAdsLoader.sdkVersion())
            adEventManager.didReportAdManagerName(name: "Google-IMA")
            
            
            self.responseHandler?.onAdCommandComplete(command: .start, status: .success, info: [kGoogleIMAAdView : self.adContainerView as Any]);
            self.responseHandler?.onAdEvent(event: .onAdPlayDidStart,info: [:]);
            adsManager.start()

        case IMAAdEventType.PAUSE:
            
            /// Once adsManager has recieved the PAUSE event, report relavant values to Conviva.
            
            adEventManager.didReportAdPlaybackState(state: .CONVIVA_AD_PAUSED)
            adEventManager.didReportAdPlayHeadTime(pht: NSInteger(adsManager.adPlaybackInfo?.currentMediaTime ?? 0))
            adEventManager.didReportAdPlayerBufferlength(bl: NSInteger(adsManager.adPlaybackInfo?.bufferedMediaTime ?? 0))
            
        case IMAAdEventType.RESUME:
            
            /// Once adsManager has recieved the RESUME event, report relavant values to Conviva.
            
            adEventManager.didReportAdPlaybackState(state: .CONVIVA_AD_PLAYING)
            adEventManager.didReportAdPlayHeadTime(pht: NSInteger(adsManager.adPlaybackInfo?.currentMediaTime ?? 0) )
            adEventManager.didReportAdPlayerBufferlength(bl: NSInteger( adsManager.adPlaybackInfo?.bufferedMediaTime ?? 0) )
            adEventManager.didReportAdVideoResolution(width: adInfo.width, height: adInfo.height)
            
        case IMAAdEventType.STARTED:
            
            /// Once adsManager has recieved the STARTED event, report relavant values to Conviva.
            
            adEventManager.didReportAdPlaybackState(state: .CONVIVA_AD_PLAYING)
            adEventManager.didReportAdPlayHeadTime(pht: NSInteger( adsManager.adPlaybackInfo?.currentMediaTime ?? 0) )
            adEventManager.didReportAdPlayerBufferlength(bl: NSInteger(adsManager.adPlaybackInfo?.bufferedMediaTime ?? 0) )
            adEventManager.didReportAdVideoResolution(width: adInfo.width, height: adInfo.height)
            
        case IMAAdEventType.COMPLETE:
            
            /// Once adsManager has recieved the COMPLETE event, cleanup the Conviva Ad session.
            adEventManager.didStopAdPlayback()
            
            /// Resume the main content monitoring.
            if let contentPlayer = contentPlayer {
                contentPlayer.play()
                adEventManager.didResumeContentMonitoring(player: contentPlayer)
                
                if (self.adIndex != -1) {
                    adEventManager.didNotifyAdEnd()
                }
            }
            self.responseHandler?.onAdEvent(event: .onAdPlayDidFinish,info: [:]);
            

            
        case IMAAdEventType.ALL_ADS_COMPLETED:
            
            /// Once adsManager has recieved the ALL_ADS_COMPLETED event, cleanup the Conviva Ad session.
            
            adEventManager.didStopAdPlayback()

            if(podInfo.podIndex == -1){
                self.adBreak = 0;
                adEventManager.didStopContentPlayback()
            }
            
        case IMAAdEventType.SKIPPED:
            
            /// Once adsManager has recieved the SKIPPED event, cleanup the Conviva Ad session.
            adEventManager.didStopAdPlayback()
            
        case IMAAdEventType.LOG:
            
            /// Once adsManager has recieved the LOG event, report an error and cleanup the Conviva Ad session.
            
            let dict : [String : Any]? = event.adData?["logData"] as? [String : Any]
            
            if let dict = dict {
                if dict.count > 0 {
                    let errorType : String = dict["type"] as! String
                    let errorCode : String = dict["errorCode"] as! String
                    let errorMsg : String = dict["errorMessage"] as! String
                    
                    let errorString : String = "type: \(errorType) code: \(errorCode) msg: \(errorMsg)"
                    adEventManager.didReportAdError(error: errorString)
                    
                    adEventManager.didStopAdPlayback()
                }
            }
            
        default:
            print("")
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
        /// Something went wrong with the ads manager after ads were loaded
        /// Since adsManager has failed and reported error, Create a Conviva session will nil streamer, report such error and cleanup the Conviva session.
        
        let errorType = error.type
        let errorCode = error.code
        let errorString : String = "type: \(errorType) code: \(errorCode) message: \(String(describing: error.message))"
        
        let metadata : ConvivaContentInfo = ConvivaContentInfo.createInfoForLightSession(withAssetName: "Ad Manager Error") as! ConvivaContentInfo

        /// Following function creates a Conviva session will nil streamer and reports the error.
        adEventManager.didFailAdPlayback(adManager: nil, error: errorString, contentInfo: metadata)

        /// Following function cleans up the Conviva session.
        adEventManager.didStopAdPlayback()
        
        /// 2. Continue further processing related to ad/content playback.
        
        /// Log the error.
        print("#Conviva: AdsManager error: \(String(describing: error.message))")
        
        /// Resume the content.
        isAdPlayback = false
        
        if let contentPlayer = contentPlayer {
            contentPlayer.play()
            
            /// After ad session cleanup, resume the main content monitoring.
            adEventManager.didResumeContentMonitoring(player: contentPlayer)
            if (self.adIndex != -1) {
                adEventManager.didNotifyAdEnd()
            }
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
        adEventManager.didPauseContentMonitoring()
        adEventManager.didNotifyAdStart()
        
        self.adBreak = self.adBreak + 1;
        self.isContentPaused = true;

        var podStartAttributes : [String : String] = [:]
        podStartAttributes["podIndex"] = String(self.adBreak)
        podStartAttributes["podDuration"] = String(self.podDuration)
        podStartAttributes["podPosition"] = self.podPosition
        
        /// Report custom PodStart evennt to Conviva.
        adEventManager.didReportCustomEvent(eventName: "Conviva.PodStart", eventAttributes: podStartAttributes)

        /// 2. Continue further processing related to ad/content playback.
        
        /// The SDK is going to play ads, so pause the content.
        isAdPlayback = true
        contentPlayer!.pause()
        self.responseHandler?.onAdEvent(event: .onAdPlayDidStart,info: [:]);
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
            adEventManager.didResumeContentMonitoring(player: streamer)
            if (self.adIndex != -1) {
                adEventManager.didNotifyAdEnd()
            }
        }
        
        if(self.isContentPaused ?? false){
            self.isContentPaused = false;
            
            var podEndAttributes : [String : String] = [:]
            podEndAttributes["podIndex"] = String(self.adBreak)
            podEndAttributes["podDuration"] = String(self.podDuration)
            podEndAttributes["podPosition"] = self.podPosition
            
            /// Report custom PodEnd evennt to Conviva.
            adEventManager.didReportCustomEvent(eventName: "Conviva.PodEnd", eventAttributes: podEndAttributes)
        }
        
        /// 2. Continue further processing related to ad/content playback.
        
        /// The SDK is done playing ads (at least for now), so resume the content.
        isAdPlayback = false
        contentPlayer!.play()
        self.responseHandler?.onAdEvent(event: .onAdPlayDidFinish,info: [:]);
    }
}

#if os(iOS)
extension CVAGoogleIMAHandler : AVPictureInPictureControllerDelegate {

    /**
     Following function initializes the PiP required to request ads from Google IMA.
     */
    func setUpPiP() {
        // Set ourselves up for PiP.
        pictureInPictureProxy = IMAPictureInPictureProxy(avPictureInPictureControllerDelegate: self);
        pictureInPictureController = AVPictureInPictureController(playerLayer: AVPlayerLayer());
        if (pictureInPictureController != nil) {
            pictureInPictureController!.delegate = pictureInPictureProxy;
        }
    }

}
#endif

