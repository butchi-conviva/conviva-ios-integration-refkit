//
//  CVAGoogleIMA+CommandHandler.swift
//  ConvivaIntegrationRefKit
//
//  Created by Gaurav Tiwari on 18/11/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

import Foundation
import AVKit

/// An extension of class CVAGoogleIMAHandler which is used to implement CVAAdCommandHandler functions.

extension CVAGoogleIMAHandler : CVAAdCommandHandler {
    
    public func startAdPlayback(adAsset:CVAAdAsset) -> CVAPlayerStatus {
        
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
    }
    
    /**
     Used to request ads from adsLoader for provided tag.
     - Parameters:
        - adTagUrl: The Google IMA ad tag URL
        - view: The CVAAdView instance on which ads will be rendered.
     */
    private func requestAds(_ adTagUrl: String!, view: CVAAdView) {
        // Create an ad request with Google IMA's ad tag, display container, and optional user context.
        if contentPlayer == self.contentPlayer {
            let request = IMAAdsRequest(
                adTagUrl: adTagUrl,
                adDisplayContainer: createAdDisplayContainer(view: view),
                avPlayerVideoDisplay: IMAAVPlayerVideoDisplay(avPlayer: self.contentPlayer),
                pictureInPictureProxy: pictureInPictureProxy,
                userContext: nil)
            adsLoader.requestAds(with: request)
        }
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
}
