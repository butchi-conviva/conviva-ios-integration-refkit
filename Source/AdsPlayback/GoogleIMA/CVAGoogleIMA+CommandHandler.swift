//
//  CVAGoogleIMA+CommandHandler.swift
//  ConvivaIntegrationRefKit
//
//  Created by Gaurav Tiwari on 18/11/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

import Foundation

/// An extension of class CVAAVPlayer which is used to implement CVAAdCommandHandler functions.

extension CVAGoogleIMAHandler : CVAAdCommandHandler{
    public func startAdPlayback(asset: CVAAsset) {

    }
    
    public func stopAdPlayback(asset: CVAAsset) -> CVAPlayerStatus {
        return .success
    }
    
}
