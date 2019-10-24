//
//  CVAAVPlayer.swift
//  CVAReferenceApp
//
//  Created by Butchi peddi on 03/09/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import AVFoundation

/// An extension of class CVAAVPlayer which is used to implement CVAPlayerCommandHandler functions.

extension CVAAVPlayer : CVAPlayerCommandHandler {
    public var playerResponseHandler: CVAPlayerResponseHandler? {
        get {
            return responseHandler;
        }
        set {
            responseHandler = newValue;
        }
    }
    
    /**
     This function is called when player is initially loaded.
     - Parameters:
        - asset: An instance of CVAAsset.
     - Returns: An instance of CVAPlayerStatus.
     */
    public func startAssetPlayback(asset : CVAAsset) -> CVAPlayerStatus {
        self.asset = asset
        initializeAVPlayer()
        
        playerEventManager = CVAPlayerEventsManager()

        if avPlayer != nil {
            playerEventManager.willStartPlayback(player: avPlayer as Any, assetInfo: self.asset)
            avPlayer?.play()
        }

        return .success;
    }
    
    /**
     This function is called when playback is started.
     - Parameters:
        - asset: An instance of CVAAsset.
     - Returns: An instance of CVAPlayerStatus.
     */
    public func playAsset(asset:CVAAsset) -> CVAPlayerStatus {
        avPlayer!.play()
        return .success;
    }
    
    /**
     This function is called when playback is paused.
     - Parameters:
        - asset: An instance of CVAAsset.
     - Returns: An instance of CVAPlayerStatus.
     */
    public func pauseAsset(asset:CVAAsset) -> CVAPlayerStatus {
        avPlayer!.pause()
        return .success;
    }
    
    /**
     This function is called when playback is stopped.
     - Parameters:
        - asset: An instance of CVAAsset.
     - Returns: An instance of CVAPlayerStatus.
     */
    public func stopAssetPlayback(asset:CVAAsset) -> CVAPlayerStatus {
        stopPlayback();
        playerEventManager.didStopPlayback()
        return .success;
    }
    
    /**
     This function is called when player's seekbar is seeked.
     - Parameters:
        - asset: An instance of CVAAsset.
        - info: A dictionary containing seek information.
     - Returns: An instance of CVAPlayerStatus.
     */
    public func seekAsset(asset:CVAAsset, info : [AnyHashable : Any]) -> CVAPlayerStatus {
        let seekTimeScale = info["value"]
        
        if let time = seekTimeScale {
            seek(avplayer: avPlayer!, value: time as! Float)
        }
        
        return .success;
    }
    
    /**
     This function is used to translate player provided seek value.
     - Parameters:
        - avplayer: An instance of AVPlayer where content was seeked.
        - value: Value of seek in Float
     */
    private func seek (avplayer : AVPlayer, value: Float) {
        
        if let duration = avplayer.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            
            let value = Float64(value) * totalSeconds
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            
            playerEventManager.willSeekFrom(position: NSInteger(value));
            avplayer.seek(to: seekTime, completionHandler: { (completedSeek) in
                if true == completedSeek{
                    self.playerEventManager.didSeekTo(position: NSInteger(value));
                }
                else {
                    self.playerEventManager.didFailSeekTo(position: NSInteger(value));
                }
            })
        }
    }
}


