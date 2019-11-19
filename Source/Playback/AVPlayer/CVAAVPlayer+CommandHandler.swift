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
            // avPlayer?.play()
        }
        
        startAdPlayback(asset: asset)
        
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
     This function is called when playback is rerequested after failure.
     - Parameters:
        - asset: An instance of CVAAsset.
     - Returns: An instance of CVAPlayerStatus.
     */
    public func retryAssetPlayback(asset:CVAAsset,info : [AnyHashable : Any]?) -> CVAPlayerStatus {
        
        destroyAVPlayer();
        return startAssetPlayback(asset: asset);
    }
    
    /**
    This function is called when user requested for replay.
    - Parameters:
     - asset: An instance of CVAAsset.
    - Returns: An instance of CVAPlayerStatus.
    */
    public func replayAsset(asset:CVAAsset, info : [AnyHashable : Any]?) -> CVAPlayerStatus {
        
        if let _ = avPlayer {
           
            seekplayer(avPlayer: avPlayer!, toTime: CMTime.zero)
            self.avPlayer!.play();
        }
        
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
     This function performs fast forward player by 10 secs.
     - Parameters:
        - asset: An instance of CVAAsset.
        - info: A dictionary containing seek information.
     - Returns: An instance of CVAPlayerStatus.
     */
    public func skipfwdAsset(asset:CVAAsset, info : [AnyHashable : Any]?) -> CVAPlayerStatus {
        
        if let _ = avPlayer, let _ = avPlayer!.currentItem{
            
            let duration = avPlayer!.currentItem!.currentTime()
            var totalSeconds = CMTimeGetSeconds(duration)
            totalSeconds += 10.0;
            
            let seekTime = CMTime(value: Int64(totalSeconds), timescale: 1)
            seekplayer(avPlayer: avPlayer!, toTime: seekTime)
        }
        
        return .success;
    }
    
    /**
     This function performs fast backward player by 10 secs.
     - Parameters:
        - asset: An instance of CVAAsset.
        - info: A dictionary containing seek information.
     - Returns: An instance of CVAPlayerStatus.
     */
    public func skipbwdAsset(asset:CVAAsset, info : [AnyHashable : Any]?) -> CVAPlayerStatus {
        
        if let _ = avPlayer, let _ = avPlayer!.currentItem{
            
            let duration = avPlayer!.currentItem!.currentTime()
            var totalSeconds = CMTimeGetSeconds(duration)
            totalSeconds -= 10.0;
            
            let seekTime = CMTime(value: Int64(totalSeconds), timescale: 1)
            seekplayer(avPlayer: avPlayer!, toTime: seekTime)
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
            
            seekplayer(avPlayer:avplayer,toTime: seekTime);
        }
    }
    
    /**
     This function is used to perform seek to desired time
     - Parameters:
        - avplayer: An instance of AVPlayer where content was seeked.
        - toTime: CMTime
     */
    private func seekplayer(avPlayer:AVPlayer,toTime:CMTime,completionHandler:(() -> Void)? = nil) {
        
        let seekTimeInSecs = CMTimeGetSeconds(toTime);
        playerEventManager.willSeekFrom(position: NSInteger(seekTimeInSecs));
        avPlayer.seek(to: toTime, completionHandler: { (completedSeek) in
            if true == completedSeek{
                self.playerEventManager.didSeekTo(position: NSInteger(seekTimeInSecs));
            }
            else {
                self.playerEventManager.didFailSeekTo(position: NSInteger(seekTimeInSecs));
            }
        })
    }
}


