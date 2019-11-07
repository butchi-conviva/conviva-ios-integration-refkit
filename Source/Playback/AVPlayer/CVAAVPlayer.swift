//
//  CVAAVPlayer.swift
//  ConvivaIntegrationRefKit
//
//  Created by Gaurav Tiwari on 22/10/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

import Foundation
import AVFoundation

/// A class which is used to implement AVPlayer behaviour. Ideally, this class will not have any Conviva funnctionality in itself and will depend on CVAPlayerManager for the same.

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
     The CVAAVPlayerManager instance which takes care of all Conviva implementation.
     */
    var playerEventManager : CVAPlayerEventsManagerProtocol!
    
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
     The CVAAVPlayer class initializer. CVAAVPlayerManager's implementation responsible for Conviva initialization should happen here.
     */
    public override init() {
        super.init()

    }
    
    /**
     This function initializes the AVPlayer.
     */
    func initializeAVPlayer() {
        
        guard nil != self.asset else {
            Swift.print("Empty asset info");
            return;
        }
        
        guard nil != self.asset?.playbackURI else {
            Swift.print("Empty asset url");
            return;
        }
        
        let videoURL = self.asset?.playbackURI;
        //  avPlayer = AVPlayer(url: videoURL! as URL)

        /// The AVAssetResourceLoader's delegate is set to use methods that allow us to handle resource loading requests.
        /// This will be useful to capture scenarios like DRM and processing/parsing m3u8 files.
        let asset = AVURLAsset(url: videoURL! as URL)
        let queue = DispatchQueue(label: "com.conviva.queue")
        asset.resourceLoader.setDelegate(self as AVAssetResourceLoaderDelegate , queue: queue)
        let playerItem = AVPlayerItem(asset: asset)
        
        avPlayer = AVPlayer(playerItem: playerItem)

        print(#function, videoURL as Any)

        self.avPlayerLayer = AVPlayerLayer(player: avPlayer)
        
        addPeriodicTimeObserver();
        registerAppStateChangeNotifications()
        
        if let avPlayer = avPlayer {
            registerPlayerNotification(avPlayer)
        }
        
        DispatchQueue.main.async {
            self.responseHandler?.onPlayerCommandComplete(command: .play, status: .success, info: [kAVPlayerLayer:self.avPlayerLayer as Any]);
        }
    }
}
