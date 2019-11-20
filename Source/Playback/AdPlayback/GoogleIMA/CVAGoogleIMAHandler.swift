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
    
    /**
     Google IMA SDK handle for IMAAdsLoader.
     */
    var adsLoader: IMAAdsLoader!
    
    /**
     Google IMA SDK handle for IMAAdsManager.
     */
    var adsManager: IMAAdsManager?
    
    /**
     PiP objects.
     */
    var pictureInPictureController: AVPictureInPictureController?
    var pictureInPictureProxy: IMAPictureInPictureProxy?

    /**
     Content player handles
     */
    var contentPlayer: AVPlayer?

    /**
     Following variable is used to track Ad's play/pause.
     */
    var isAdPlayback = false

    /**
     The CVAGoogleIMAIntegrationRef instance.
     */
    let cvaGoogleIMAIntegrationRef = CVAGoogleIMAIntegrationRef()

    /**
     The CVAAdView instance
     */
    var adContainerView : CVAAdView? = nil;

    /**
     The CVAPlayerResponseHandler instance
     */
    var responseHandler : CVAAdResponseHandler?;
    
    /**
     The CVAAdDataSource instance
     */
    public var dataSource : CVAAdDataSource?

    /**
     The CVAGoogleIMAHandler class initializer.
     Loading of Google IMA and initialization of the AdsLoader should happen here.
     */
    public override init() {
        super.init()
        setUpIMA()
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

        // adsLoader.contentComplete()

        /// Set Conviva as the ads loader delegate.
        adsLoader.delegate = cvaGoogleIMAIntegrationRef.setConvivaAdsLoaderDelegate(delegate: self) as? IMAAdsLoaderDelegate
        
        setUpPiP()
    }

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

/// An extension of class CVAGoogleIMAHandler which is used to implement IMAAdsLoaderDelegate functions.
extension CVAGoogleIMAHandler : IMAAdsLoaderDelegate {

    public func adsLoader(_ loader: IMAAdsLoader!, adsLoadedWith adsLoadedData: IMAAdsLoadedData!) {
        
        /// adsLoader is indicating successful load of ads.
        /// adsManager should be initialized here.
        /// Log the String containing IMAAdsLoadedData.

        print("#Conviva: loader adsLoadedWith: \(String(describing: adsLoadedData))")

        /// Grab the instance of the IMAAdsManager
        self.adsManager = adsLoadedData.adsManager;
        
        /// Set Conviva as the ads manager delegate.
        self.adsManager?.delegate = cvaGoogleIMAIntegrationRef.setConvivaAdsManagerDelegate(delegate: self) as? IMAAdsManagerDelegate & NSObjectProtocol
        
        let adsRenderingSettings = IMAAdsRenderingSettings()
        
        /// Initialize the ads manager.
        adsManager!.initialize(with: adsRenderingSettings)
    }
    
    public func adsLoader(_ loader: IMAAdsLoader!, failedWith adErrorData: IMAAdLoadingErrorData!) {
        /// Something went wrong loading ads.
        /// Log the error and play the content.
        
        print("#Conviva: Error loading ads: \(adErrorData.adError.message ?? "s")")
        isAdPlayback = false
        
        if let contentPlayer = contentPlayer {
            contentPlayer.play()
        }
    }
}

/// An extension of class CVAGoogleIMAHandler which is used to implement IMAAdsManagerDelegate functions.
extension CVAGoogleIMAHandler : IMAAdsManagerDelegate {

    public func adsManager(_ adsManager: IMAAdsManager!, didReceive event: IMAAdEvent!) {
        /// adsManager is sending the events based on status of ads playback. Act accordingly.
        /// Log the type of AdsManager event.

        print("#Conviva: AdsManager event \(event.typeString!)")
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
                cvaGoogleIMAIntegrationRef.attachPlayer(player: contentPlayer)
                cvaGoogleIMAIntegrationRef.adEnd()
            }

            print("Resume content")
        default:
            break
        }
    }
    
    public func adsManager(_ adsManager: IMAAdsManager!, didReceive error: IMAAdError!) {
        /// Something went wrong with the ads manager after ads were loaded.
        /// Log the error and play the content.
        
        print("#Conviva: AdsManager error: \(String(describing: error.message))")
        isAdPlayback = false
        
        if let contentPlayer = contentPlayer {
            contentPlayer.play()
            cvaGoogleIMAIntegrationRef.attachPlayer(player: contentPlayer)
            cvaGoogleIMAIntegrationRef.adEnd()
        }
        
    }
    
    public func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager!) {
        /// The SDK is going to play ads, so pause the content.
        isAdPlayback = true
        contentPlayer!.pause()
    }
    
    public func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager!) {
        /// The SDK is done playing ads (at least for now), so resume the content.
        isAdPlayback = false
        contentPlayer!.play()
    }
}
