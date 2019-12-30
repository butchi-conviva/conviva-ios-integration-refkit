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
    
    public var contentPlayer: Any? {
        get {
            return self.avPlayer;
        }
    }
    
    /**
     This function is called when player is initially loaded.
     - Parameters:
        - asset: An instance of CVAAsset.
     - Returns: An instance of CVAPlayerStatus.
     */
    public func startAssetPlayback(playerEventManager : CVAPlayerEventsManager, asset : CVAAsset) -> CVAPlayerStatus {
        self.asset = asset
        initializeAVPlayer()
        
        self.playerEventManager = playerEventManager
        
        if avPlayer != nil {
            if asset.isEncrypted {  //  DRM Protected/Encrypted Content
                self.playerEventManager.willStartEncryptedAssetLoading(player: avPlayer as Any, assetInfo: self.asset)
            }
            else {  // Non DRM
                self.playerEventManager.willStartPlayback(player: avPlayer as Any, assetInfo: self.asset)
            }
            avPlayer?.play()
        }
        
        return .success;
    }
    
    
    /**
     This function is called when player is initially loaded.
     - Parameters:
        - asset: An instance of CVAAsset.
     - Returns: An instance of CVAPlayerStatus.
     */
    public func resumeAssetPlayback(playerEventManager : CVAPlayerEventsManager, asset : CVAAsset) -> CVAPlayerStatus {
        self.asset = asset
        initializeAVPlayer()
        
        self.playerEventManager = playerEventManager
        
        if avPlayer != nil {
            if asset.isEncrypted {  //  DRM Protected/Encrypted Content
                self.playerEventManager.willStartEncryptedAssetLoading(player: avPlayer as Any, assetInfo: self.asset)
            }
            else {  // Non DRM
                self.playerEventManager.willStartPlayback(player: avPlayer as Any, assetInfo: self.asset)
            }
            
            let seekTime = CMTimeMakeWithSeconds(self.asset.watchedDuration, preferredTimescale: 1)
            seekplayer(avPlayer: avPlayer!, toTime: seekTime, callConvivaSeekEvents: false)
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
     This function is called when playback is rerequested after failure.
     - Parameters:
        - asset: An instance of CVAAsset.
     - Returns: An instance of CVAPlayerStatus.
     */
    public func retryAssetPlayback(asset:CVAAsset,info : [AnyHashable : Any]?) -> CVAPlayerStatus {
        
        destroyAVPlayer();
        return startAssetPlayback(playerEventManager: self.playerEventManager, asset: asset)
        // return startAssetPlayback(asset: asset);
    }
    
    /**
    This function is called when user requested for replay.
    - Parameters:
     - asset: An instance of CVAAsset.
    - Returns: An instance of CVAPlayerStatus.
    */
    public func replayAsset(asset:CVAAsset, info : [AnyHashable : Any]?) -> CVAPlayerStatus {
        
        if let _ = avPlayer {
           
            seekplayer(avPlayer: avPlayer!, toTime: CMTime.zero, callConvivaSeekEvents: false)
            self.avPlayer!.play();
        }
        
        return .success;
    }
    
    /**
     This function is called when player's seekbar started seeking.
     - Parameters:
        - asset: An instance of CVAAsset.
        - info: A dictionary containing seek information.
     - Returns: An instance of CVAPlayerStatus.
     */
    public func seekStartAsset(asset:CVAAsset, info : [AnyHashable : Any]) -> CVAPlayerStatus {
        let seekTimeScale = info["value"]
                
        if let time = seekTimeScale {
            let seekTime = getSeekPosition(avplayer: avPlayer!, value: time as! Float)
            let seekTimeInSecs = CMTimeGetSeconds(seekTime);
            playerEventManager.willSeekFrom(position: NSInteger(seekTimeInSecs));
        }
        return .success;
    }

    /**
     This function is called while player's seekbar is seeking.
     - Parameters:
        - asset: An instance of CVAAsset.
        - info: A dictionary containing seek information.
     - Returns: An instance of CVAPlayerStatus.
     */
    public func seekValueChangeAsset(asset:CVAAsset, info : [AnyHashable : Any]) -> CVAPlayerStatus {
        let seekTimeScale = info["value"]
        
        if let time = seekTimeScale {
           let seekTime = getSeekPosition(avplayer: avPlayer!, value: time as! Float)
           seekplayer(avPlayer:avPlayer!,toTime: seekTime, callConvivaSeekEvents: false);
        }
        
        return .success;
    }

    /**
     This function is called when player's seekbar finished seeking.
     - Parameters:
        - asset: An instance of CVAAsset.
        - info: A dictionary containing seek information.
     - Returns: An instance of CVAPlayerStatus.
     */
    public func seekEndAsset(asset:CVAAsset, info : [AnyHashable : Any]) -> CVAPlayerStatus {
        let seekTimeScale = info["value"]
        
        if let time = seekTimeScale {
            let seekTime = getSeekPosition(avplayer: avPlayer!, value: time as! Float)
            seekplayer(avPlayer:avPlayer!, toTime: seekTime, callConvivaSeekEvents: true);
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
            seekplayer(avPlayer: avPlayer!, toTime: seekTime, callConvivaSeekEvents: false)
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
            seekplayer(avPlayer: avPlayer!, toTime: seekTime, callConvivaSeekEvents: false)
        }
        
        return .success;
    }
    
    /**
     This function is used to translate player provided seek value.
     - Parameters:
        - avplayer: An instance of AVPlayer where content was seeked.
        - value: Value of seek in Float
     */
    private func getSeekPosition(avplayer : AVPlayer, value: Float) -> CMTime {
        
        if let duration = avplayer.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            
            let value = Float64(value) * totalSeconds
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            
            return seekTime
        }
        return CMTime.zero
    }

    /**
     This function is used to perform seek to desired time
     - Parameters:
        - avplayer: An instance of AVPlayer where content was seeked.
        - toTime: CMTime
        - convivaSeekEvents: Bool      true/false:  Send/Don't send Conviva Seek Events (pss/pse)
     */

    private func seekplayer(avPlayer:AVPlayer,toTime:CMTime,callConvivaSeekEvents convivaSeekEvents: Bool = true,completionHandler:(() -> Void)? = nil) {
        
        let seekTimeInSecs = CMTimeGetSeconds(toTime);
        avPlayer.seek(to: toTime, completionHandler: { (completedSeek) in
            if convivaSeekEvents {
                if true == completedSeek{
                    self.playerEventManager.didSeekTo(position: NSInteger(seekTimeInSecs));
                }
                else {
                    self.playerEventManager.didFailSeekTo(position: NSInteger(seekTimeInSecs));
                }
            }
        })
    }
}


