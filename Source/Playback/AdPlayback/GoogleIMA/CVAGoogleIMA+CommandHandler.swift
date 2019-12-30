//
//  CVAGoogleIMA+CommandHandler.swift
//  ConvivaIntegrationRefKit
//
//  Created by Gaurav Tiwari on 18/11/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

import Foundation
import AVKit
import GoogleInteractiveMediaAds

/// An extension of class CVAGoogleIMAHandler which is used to implement CVAAdCommandHandler functions.

extension CVAGoogleIMAHandler : CVAAdCommandHandler {
    public func startAdPlayback(adEventManager: CVAAdsEventsManager, adAsset: CVAAdAsset) -> CVAPlayerStatus {
        self.adEventManager = adEventManager
        
        setUpIMA()
        setUpAdView()
        
        startAdRequest(adAsset: adAsset)
        
        return .success;
    }
    
    public func stopAdPlayback(asset:CVAAdAsset) -> CVAPlayerStatus {
        
        if (adsLoader != nil) {
            adsLoader = nil
        }
        
        if (adsManager != nil) {
            adsManager!.destroy()
        }
        
        adEventManager.didStopAdPlayback()
        
        return .success;
    }
    
    /**
     Used to request ad from GoogleIMA.
     - Parameters:
        - asset: The CVAAsset instance. Contains information about content.
        - adAsset: The CVAAdAsset instance. Contains information about ad.
     */
    func startAdRequest(adAsset: CVAAdAsset) {
        
        let player = self.dataSource?.contentPlayer;
                
        if let _ = player , let avPlayer = player as? AVPlayer {
            
            setUpContentPlayer(contentPlayer: player as! AVPlayer)

            var imaTag = ""
            
            switch adAsset.type {
            case .preroll :
                imaTag = Conviva.GoogleIMAAdTags.kPrerollTag
            case .skippable :
                imaTag = Conviva.GoogleIMAAdTags.kSkippableTag
            case .postroll :
                imaTag = Conviva.GoogleIMAAdTags.kPostrollTag
            case .adRules :
                imaTag = Conviva.GoogleIMAAdTags.kAdRulesTag
            case .adRulesPods :
                imaTag = Conviva.GoogleIMAAdTags.kAdRulesPodsTag
            case .vmapPods :
                imaTag = Conviva.GoogleIMAAdTags.kVMAPPodsTag
            case .wrapper :
                imaTag = Conviva.GoogleIMAAdTags.kWrapperTag
            case .adSense :
                imaTag = Conviva.GoogleIMAAdTags.kAdSenseTag
            }
            
            self.requestAds(imaTag, view: adContainerView!)
            self.responseHandler?.onAdEvent(event:.onAdLoading, info: [:])
        }
    }
}

/// An extension of class CVAGoogleIMAHandler which is used to keep some private utility functions.
extension CVAGoogleIMAHandler {

    /**
     Used to initialize CVAAdView.
     */
    private func setUpAdView() {
        let screenRect = UIScreen.main.bounds
        self.adContainerView = CVAAdView()
        self.adContainerView?.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)
        self.adContainerView?.backgroundColor = UIColor.red
        self.dataSource?.contentView?.addSubview(self.adContainerView!);
    }

    /**
     Used to set Content player.
     - Parameters:
        - contentPlayer: An AVPlayer instance.
     */
    private func setUpContentPlayer(contentPlayer : AVPlayer) {
        self.contentPlayer = contentPlayer
        // Set up our content playhead and contentComplete callback.
        self.contentPlayhead = IMAAVPlayerContentPlayhead(avPlayer: self.contentPlayer!)
        NotificationCenter.default.addObserver(self, selector:#selector(contentDidFinishPlaying(_:)) , name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:self.contentPlayer?.currentItem)
    }
    
    /**
     Used to request ads from adsLoader for provided tag.
     - Parameters:
        - adTagUrl: The Google IMA ad tag URL
        - view: The CVAAdView instance on which ads will be rendered.
     */
    private func requestAds(_ adTagUrl: String!, view: CVAAdView) {
        
        #if os(iOS)
        // Create an ad request with Google IMA's ad tag, display container, and optional user context.
        if contentPlayer == self.contentPlayer {
//            let request = IMAAdsRequest(
//                adTagUrl: adTagUrl,
//                adDisplayContainer: createAdDisplayContainer(view: view),
//                avPlayerVideoDisplay: IMAAVPlayerVideoDisplay(avPlayer: self.contentPlayer),
//                pictureInPictureProxy: pictureInPictureProxy,
//                userContext: nil)
            let request = IMAAdsRequest(
                adTagUrl: adTagUrl,
                adDisplayContainer: createAdDisplayContainer(view: view),
                contentPlayhead: self.contentPlayhead,
                userContext: nil)
            adsLoader.requestAds(with: request)
        }

        #else
        // Create an ad request with Google IMA's ad tag, display container, and optional user context.
        if contentPlayer == self.contentPlayer {
            let request = IMAAdsRequest(
                adTagUrl: adTagUrl,
                adDisplayContainer: createAdDisplayContainer(view: view),
                contentPlayhead: self.contentPlayhead,
                userContext: nil)
            adsLoader.requestAds(with: request)
        }

        #endif
    }
    
    /**
     Used to provide an ad container to Google IMA.
     - Parameters:
        - view: The CVAAdView instance on which ads will be rendered.
     - Returns: An instance of type IMAAdDisplayContainer.
     */
    private func createAdDisplayContainer(view: CVAAdView) -> IMAAdDisplayContainer {
        return IMAAdDisplayContainer(adContainer: view, companionSlots: nil)
    }
    
    //  MARK: - Notifications
    
    @objc func contentDidFinishPlaying(_ sender: Notification) -> Void {
        if let currentItem = sender.object as? AVPlayerItem {
            if currentItem == self.contentPlayer?.currentItem {
                self.adsLoader.contentComplete()
            }
        }
    }
}
