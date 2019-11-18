//
//  CVAAVPlayer+GoogleIMAHandler.swift
//  ConvivaIntegrationRefKit
//
//  Created by Gaurav Tiwari on 15/11/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

import Foundation

extension CVAAVPlayer : CVAAdCommandHandler {
    
    public func startAdPlayback(asset: CVAAsset) {
        setUpAdView()
        
        setUpGoogleIMA()
        
        requestGoogleIMAAd(asset: asset)
    }
    
    public func stopAdPlayback(asset: CVAAsset) -> CVAPlayerStatus {
        return .success
    }
}

extension CVAAVPlayer {
    // Initialize CVAAdView
    func setUpAdView() {
        let screenRect = UIScreen.main.bounds
        cvaAdView = CVAAdView()
        cvaAdView?.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)
        cvaAdView?.backgroundColor = UIColor.white
    }
    
    // Initialize GoogleIMA
    func setUpGoogleIMA() {
        cvaGoogleIMA = CVAGoogleIMAHandler()
    }
    
    // Request ad from GoogleIMA
    func requestGoogleIMAAd(asset: CVAAsset) {
        if let cvaGoogleIMA = cvaGoogleIMA,
            let avPlayer = avPlayer {
            cvaGoogleIMA.requestAdsWithTag(Conviva.GoogleIMAAdTags.kSkippableTag, view: cvaAdView!, avPlayer: avPlayer)
        }
        
        self.responseHandler?.onPlayerEvent(event:.onAdLoading, info: [:])
    }
}
