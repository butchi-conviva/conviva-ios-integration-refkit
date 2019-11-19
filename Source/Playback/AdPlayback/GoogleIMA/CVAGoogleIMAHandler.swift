//
//  CVAGoogleIMA.swift
//  ConvivaIntegrationRefKit
//
//  Created by Gaurav Tiwari on 12/11/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

import Foundation
import GoogleInteractiveMediaAds

/// A class used to keep all methods required for Google IMA setup and notifications handling.

public class CVAGoogleIMAHandler : NSObject, AVPictureInPictureControllerDelegate {
    
    // IMA SDK handles.
    var adsLoader: IMAAdsLoader!
    var adsManager: IMAAdsManager?
    
    // PiP objects.
    var pictureInPictureController: AVPictureInPictureController?
    var pictureInPictureProxy: IMAPictureInPictureProxy?

    // Content player handles.
    var contentPlayer: AVPlayer? ;

    // Tracking for play/pause.
    var isAdPlayback = false

    // CVAGoogleIMAIntegrationRef instance
    let cvaGoogleIMAIntegrationRef = CVAGoogleIMAIntegrationRef()

    var adContainerView:CVAAdView? = nil;
    /**
     The CVAPlayerResponseHandler instance
     */
    var responseHandler : CVAAdResponseHandler?;
    
    public var dataSource:CVAAdDataSource?

    public override init() {
        super.init()
        setUpIMA()
    }
    
    // Initialize AdsLoader.
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

        // adsLoader.contentComplete()

        // Set Conviva as the ads loader delegate.
        adsLoader.delegate = cvaGoogleIMAIntegrationRef.setConvivaAdsLoaderDelegate(delegate: self) as? IMAAdsLoaderDelegate
        
        setUpPiP()
    }

    // Initialize the content player and load content.
    func setUpPiP() {
        // Set ourselves up for PiP.
        pictureInPictureProxy = IMAPictureInPictureProxy(avPictureInPictureControllerDelegate: self);
        pictureInPictureController = AVPictureInPictureController(playerLayer: AVPlayerLayer());
        if (pictureInPictureController != nil) {
            pictureInPictureController!.delegate = pictureInPictureProxy;
        }
    }
    
    // Request ads for provided tag.
    func requestAdsWithTag(_ adTagUrl: String!, view: CVAAdView, avPlayer : AVPlayer) {
        // Create an ad request with our ad tag, display container, and optional user context.
        
        contentPlayer = avPlayer
        let request = IMAAdsRequest(
            adTagUrl: adTagUrl,
            adDisplayContainer: createAdDisplayContainer(view: view),
            avPlayerVideoDisplay: IMAAVPlayerVideoDisplay(avPlayer: avPlayer),
            pictureInPictureProxy: pictureInPictureProxy,
            userContext: nil)
        adsLoader.requestAds(with: request)
    }

    func createAdDisplayContainer(view: CVAAdView) -> IMAAdDisplayContainer {
        return IMAAdDisplayContainer(adContainer: view, companionSlots: nil)
    }
}

extension CVAGoogleIMAHandler : IMAAdsLoaderDelegate {
    // IMAAdsLoaderDelegate methods
    public func adsLoader(_ loader: IMAAdsLoader!, adsLoadedWith adsLoadedData: IMAAdsLoadedData!) {
        // Grab the instance of the IMAAdsManager
        self.adsManager = adsLoadedData.adsManager;
        
        // Set Conviva as the ads manager delegate.
        self.adsManager?.delegate = cvaGoogleIMAIntegrationRef.setConvivaAdsManagerDelegate(delegate: self) as? IMAAdsManagerDelegate & NSObjectProtocol
        
        let adsRenderingSettings = IMAAdsRenderingSettings()
        
        // Initialize the ads manager.
        adsManager!.initialize(with: adsRenderingSettings)
    }
    
    public func adsLoader(_ loader: IMAAdsLoader!, failedWith adErrorData: IMAAdLoadingErrorData!) {
        // Something went wrong loading ads. Log the error and play the content.
        
        print("Error loading ads: \(adErrorData.adError.message ?? "s")")
        isAdPlayback = false
         contentPlayer!.play()
    }
}

extension CVAGoogleIMAHandler : IMAAdsManagerDelegate {
    // IMAAdsManagerDelegate methods
    public func adsManager(_ adsManager: IMAAdsManager!, didReceive event: IMAAdEvent!) {
        print("AdsManager event \(event.typeString!)")
        switch (event.type) {
        case IMAAdEventType.LOADED:
            self.responseHandler?.onAdCommandComplete(command: .start, status: .success, info: [kGoogleIMAAdView : self.adContainerView as Any]);
            
            self.responseHandler?.onAdEvent(event: .onAdPlayDidStart,info: [:]);
            adsManager.start()
            break
        case IMAAdEventType.PAUSE:
            print("Paused. Show play button")
            break
        case IMAAdEventType.RESUME:
            print("Resumed. Show pause button")
            break
        case IMAAdEventType.COMPLETE:
            
            if let contentPlayer = contentPlayer {
                contentPlayer.play()
                cvaGoogleIMAIntegrationRef.attachPlayer(streamer: contentPlayer)
            }

            print("Resume content")
        default:
            break
        }
    }
    
    public func adsManager(_ adsManager: IMAAdsManager!, didReceive error: IMAAdError!) {
        // Something went wrong with the ads manager after ads were loaded. Log the error and play the
        // content.
        print("AdsManager error: \(String(describing: error.message))")
        isAdPlayback = false
        
        // TBD
        if let contentPlayer = contentPlayer {
            contentPlayer.play()
            cvaGoogleIMAIntegrationRef.attachPlayer(streamer: contentPlayer)
        }
        
    }
    
    public func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager!) {
        // The SDK is going to play ads, so pause the content.
        isAdPlayback = true
        contentPlayer!.pause()
    }
    
    public func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager!) {
        // The SDK is done playing ads (at least for now), so resume the content.
        isAdPlayback = false
        contentPlayer!.play()
    }
}
