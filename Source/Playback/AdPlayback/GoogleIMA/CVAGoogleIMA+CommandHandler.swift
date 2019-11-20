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
    
    public func startAdPlayback(asset: CVAAsset, adAsset:CVAAdAsset) -> CVAPlayerStatus {
        
        setUpAdView()
        
        startAdRequest(asset: asset, adAsset: adAsset)
        
        return .success;
    }
    
    public func stopAdPlayback(asset:CVAAdAsset) -> CVAPlayerStatus {
        
        return .success;
    }
    
    // Request ad from GoogleIMA
    func startAdRequest(asset: CVAAsset, adAsset: CVAAdAsset) {
        
        let player = self.dataSource?.contentPlayer;
                
        if let _ = player , let avPlayer = player as? AVPlayer {
            
            setUpContentPlayer(contentPlayer: player as! AVPlayer)

            var imaTag = ""
            
            switch adAsset.type {
            case .preroll :
                imaTag = Conviva.GoogleIMAAdTags.kPrerollTag
            case .postroll :
                imaTag = Conviva.GoogleIMAAdTags.kPostrollTag
            default :
                imaTag = Conviva.GoogleIMAAdTags.kPrerollTag
            }
            
            self.requestAds(imaTag, view: adContainerView!)
            self.responseHandler?.onAdEvent(event:.onAdLoading, info: [:])
        }
    }
}

extension CVAGoogleIMAHandler {
    // Initialize CVAAdView
    private func setUpAdView() {
        
        let screenRect = UIScreen.main.bounds
        self.adContainerView = CVAAdView()
        self.adContainerView?.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)
        self.adContainerView?.backgroundColor = UIColor.red
    }

    private func setUpContentPlayer(contentPlayer : AVPlayer) {
        self.contentPlayer = contentPlayer
    }
    
    // Request ads for provided tag.
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
    
    private func createAdDisplayContainer(view: CVAAdView) -> IMAAdDisplayContainer {
        return IMAAdDisplayContainer(adContainer: view, companionSlots: nil)
    }

}
