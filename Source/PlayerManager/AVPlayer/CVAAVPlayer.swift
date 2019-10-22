//
//  CVAAVPlayer.swift
//  ConvivaIntegrationRefKit
//
//  Created by Gaurav Tiwari on 22/10/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

import Foundation
import AVFoundation

public class CVAAVPlayer: NSObject {
    
    /**
     The AVPlayer instance which will be passed to Conviva API for monitoring.
     */
    var avPlayer : AVPlayer?
    
    /**
     The AVPlayerLayer instance will be passed to application UI.
     */
    var avPlayerLayer : AVPlayerLayer?
    
    /**
     The CVAAVPlayerIntegrationRef instance which takes care of all Conviva implementation.
     */
    var convivaAVPlayerIntegrationRef : CVAAVPlayerIntegrationRef!
    
    /**
     The CVAAsset instance which is used to fetch asset info.
     */
    var asset : CVAAsset!
    
    /**
     The CVAPlayerResponseHandler instance
     */
    var responseHandler : CVAPlayerResponseHandler?;
    
    /**
     The timeObserverToken instance
     */
    var timeObserverToken: Any?
    
    /**
     The CVAAVPlayer class initializer. Conviva initialization should happen here.
     */
    public override init() {
        super.init()
        CVAAVPlayerIntegrationRef.initialize()
    }
}
