//
//  CVAGoogleIMA+CommandHandler.swift
//  ConvivaIntegrationRefKit
//
//  Created by Gaurav Tiwari on 18/11/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

import Foundation
import AVKit

/// An extension of class CVAAVPlayer which is used to implement CVAAdCommandHandler functions.

extension CVAGoogleIMAHandler : CVAAdCommandHandler {
    
    public func startAdPlayback(asset:CVAAdAsset) -> CVAPlayerStatus {
        
        setUpAdView()
        
        requestGoogleIMAAd(asset: asset)
        
        return .success;
    }
    
    public func stopAdPlayback(asset:CVAAdAsset) -> CVAPlayerStatus {
        
        return .success;
    }
    
    // Initialize CVAAdView
    func setUpAdView() {
        
        let screenRect = UIScreen.main.bounds
        self.adContainerView = CVAAdView()
        self.adContainerView?.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)
        self.adContainerView?.backgroundColor = UIColor.red
    }
    
    // Request ad from GoogleIMA
    func requestGoogleIMAAd(asset: CVAAdAsset) {
        
        let player = self.dataSource?.contentPlayer;
        
        if let _ = player , let avPlayer = player as? AVPlayer {
            self.requestAdsWithTag(Conviva.GoogleIMAAdTags.kPrerollTag, view: adContainerView!, avPlayer: avPlayer)
            self.responseHandler?.onAdEvent(event:.onAdLoading, info: [:])
        }
        
    }
}
