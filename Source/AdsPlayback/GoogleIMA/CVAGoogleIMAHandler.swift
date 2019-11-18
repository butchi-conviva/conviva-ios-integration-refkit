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

public class CVAGoogleIMAHandler : NSObject {
    
    // IMA SDK handles.
    var adsLoader: IMAAdsLoader!
    var adsManager: IMAAdsManager?
    
    // Tracking for play/pause.
    var isAdPlayback = false

    // CVAGoogleIMAIntegrationRef instance
    let cvaGoogleIMAIntegrationRef = CVAGoogleIMAIntegrationRef()

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
    }

    // Request ads for provided tag.
    func requestAdsWithTag(_ adTagUrl: String!, view: CVAAdView) {
        // Create an ad request with our ad tag, display container, and optional user context.
        let request = IMAAdsRequest(
            adTagUrl: adTagUrl,
            adDisplayContainer: createAdDisplayContainer(view: view),
            avPlayerVideoDisplay: nil,
            pictureInPictureProxy: nil,
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
        self.adsManager?.delegate = cvaGoogleIMAIntegrationRef.setConvivaAdsLoaderDelegate(delegate: self) as? IMAAdsManagerDelegate & NSObjectProtocol
        
        let adsRenderingSettings = IMAAdsRenderingSettings()
        // adsRenderingSettings.webOpenerPresentingController = self
        
        // Initialize the ads manager.
        adsManager!.initialize(with: adsRenderingSettings)
    }
    
    public func adsLoader(_ loader: IMAAdsLoader!, failedWith adErrorData: IMAAdLoadingErrorData!) {
        // Something went wrong loading ads. Log the error and play the content.
        
        print("Error loading ads: \(adErrorData.adError.message ?? "s")")
        isAdPlayback = false
        // contentPlayer!.play()
    }
}

extension CVAGoogleIMAHandler : IMAAdsManagerDelegate {
    // IMAAdsManagerDelegate methods
    public func adsManager(_ adsManager: IMAAdsManager!, didReceive event: IMAAdEvent!) {
        print("AdsManager event \(event.typeString!)")
        switch (event.type) {
        case IMAAdEventType.LOADED:
            adsManager.start()
            break
        case IMAAdEventType.PAUSE:
            print("Paused. Show play button")
            break
        case IMAAdEventType.RESUME:
            print("Resumed. Show pause button")
            break
        default:
            break
        }
    }
    
    public func adsManager(_ adsManager: IMAAdsManager!, didReceive error: IMAAdError!) {
        // Something went wrong with the ads manager after ads were loaded. Log the error and play the
        // content.
        print("AdsManager error: \(String(describing: error.message))")
        isAdPlayback = false
        
        /* TBD
        if let contentPlayer = contentPlayer {
            contentPlayer.play()
            cvaGoogleIMAIntegrationRef.attachPlayer(streamer: contentPlayer)
        }
        */
    }
    
    public func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager!) {
        // The SDK is going to play ads, so pause the content.
        isAdPlayback = true
        // contentPlayer!.pause()
    }
    
    public func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager!) {
        // The SDK is done playing ads (at least for now), so resume the content.
        isAdPlayback = false
        // contentPlayer!.play()
    }
}
