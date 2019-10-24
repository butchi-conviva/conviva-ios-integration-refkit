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
    var avPlayerManager : CVAPlayerEventsManagerProtocol!
    
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
        
        //let videoURL = NSURL(string: Conviva.URLs.devimagesURL)
        
        avPlayer = AVPlayer(url: videoURL! as URL)
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
