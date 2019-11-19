//
//  GoogleIMACommandHandler.swift
//  ConvivaIntegrationRefKit
//
//  Created by Gaurav Tiwari on 13/11/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

import Foundation

public protocol CVAAdCommandHandler : class {
    // var adResponseHandler:CVAPlayerResponseHandler? { get set };
    
    var dataSource:CVAAdDataSource? { get set }
    
    func startAdPlayback(asset:CVAAdAsset) -> CVAPlayerStatus
    
    func stopAdPlayback(asset:CVAAdAsset) -> CVAPlayerStatus
    
}
