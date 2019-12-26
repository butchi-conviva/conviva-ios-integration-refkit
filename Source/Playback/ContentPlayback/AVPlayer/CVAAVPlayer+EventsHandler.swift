//
//  CVAAVPlayer+EventsHandler.swift
//  ConvivaIntegrationRefKit
//
//  Created by Gaurav Tiwari on 22/10/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

import Foundation
import AVFoundation

/// An extension of class CVAAVPlayer which is used to implement AVPlayer's Notifications and events.

extension CVAAVPlayer {
    
    /**
     This function is used to add a periodic time observer on AVPlayer.
     */
    func addPeriodicTimeObserver() {
        // Notify every half second
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.5, preferredTimescale: timeScale)
        
        if (avPlayer != nil) {
            timeObserverToken = avPlayer?.addPeriodicTimeObserver(forInterval: time,
                                                                 queue: .main) {
                                                                    [weak self] time in
                                                                    // update player transport UI
                                                                    let elapsedtime = CMTimeGetSeconds(time);
                                                                    if(0 < elapsedtime){
                                                                        let totalDuration = CMTimeGetSeconds((self!.avPlayer?.currentItem!.duration)!);
                                                                        self?.responseHandler?.onPlayerEvent(event:.onPlayHeadChange, info: [playbackPosition:elapsedtime,totalContentDuration:totalDuration])
                                                                        
                                                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PlaybackProgress"), object:nil,userInfo:  ["progress":(elapsedtime/totalDuration)])
                                                                    }
            }
        }
    }
    
    /**
     This function is used to remove the earlier added periodic time observer on AVPlayer.
     */
    func removePeriodicTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            if let avPlayer = avPlayer {
                avPlayer.removeTimeObserver(timeObserverToken)
            }
            self.timeObserverToken = nil
        }
    }
    
    /**
     This function is used to add AVPlayer playback completion notifications.
     */
    func registerPlayerNotification(_ player: AVPlayer) {
        NotificationCenter.default.addObserver(self, selector:#selector(didFinishPlaying(_:)) , name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:player.currentItem)
        
        NotificationCenter.default.addObserver(self, selector:#selector(didFailPlaying(_:)) , name:NSNotification.Name.AVPlayerItemFailedToPlayToEndTime, object:player.currentItem)
        
        NotificationCenter.default.addObserver(self, selector:#selector(didFailPlaying(_:)) , name:NSNotification.Name.AVPlayerItemPlaybackStalled, object:player.currentItem)
        
        NotificationCenter.default.addObserver(self, selector:#selector(didFailPlaying(_:)) , name:NSNotification.Name.AVPlayerItemNewErrorLogEntry, object:player.currentItem)
        
        // Add observer for AVPlayer status and AVPlayerItem status
        self.avPlayer?.addObserver(self, forKeyPath: #keyPath(AVPlayer.status), options: [.new, .initial], context: nil)
        self.avPlayer?.addObserver(self, forKeyPath: #keyPath(AVPlayer.currentItem.status), options:[.new, .initial], context: nil)
        self.avPlayer?.addObserver(self, forKeyPath: #keyPath(AVPlayer.timeControlStatus), options:[.new, .initial], context: nil)
    }
    
    /**
     This function is used to remove the earlier added AVPlayer playback completion Notification.
     */
    func deRegisterPlayerNotification(_ player: AVPlayer) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemFailedToPlayToEndTime, object: player.currentItem)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemPlaybackStalled, object: player.currentItem)

        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.AVPlayerItemNewErrorLogEntry, object:player.currentItem)
        
        self.avPlayer?.removeObserver(self, forKeyPath: #keyPath(AVPlayer.status))
        self.avPlayer?.removeObserver(self, forKeyPath: #keyPath(AVPlayer.currentItem.status))
    }
    
    /**
     This function is used to add AVPlayer Background - Foreground notifications.
     */
    func registerAppStateChangeNotifications() {
        #if os(iOS)
        NotificationCenter.default.addObserver(self, selector:#selector(didChangeAppState(_:)) , name: UIApplication.didEnterBackgroundNotification, object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(didChangeAppState(_:)) , name:UIApplication.willEnterForegroundNotification, object:nil)
        #endif
    }
    
    /**
     This function is used to removed the earlier added AVPlayer Background - Foreground notifications.
     */
    func deRegisterAppStateChangeNotifications() {
        #if os(iOS)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        #endif
    }
    
    /**
     This function is used to add notification which handle audio interruption.
     */
    func registerAudioInterruptionNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAudioInterruption), name: AVAudioSession.interruptionNotification, object: avAudioSession)
    }
    
    /**
     This function is used to remove notification which handle audio interruption.
     */
    func deRegisterAudioInterruptionNotifications() {
        NotificationCenter.default.removeObserver(self, name: AVAudioSession.interruptionNotification, object: avAudioSession)
    }

    /**
     This function is used to add observer for AVPlayer's rate property.
     */
    func addObserverForRate(_ player: AVPlayer) {
        player.addObserver(self, forKeyPath: "rate", options:NSKeyValueObservingOptions(), context: nil)
        player.currentItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: nil)
    }
    
    /**
     This function is used to implement the behaviour when AVPlayer has finished playing.
     In this situation Conviva session should be cleaned up.
     */
    @objc private func didFinishPlaying(_ sender: Notification) -> Void {
        playerEventManager.didStopPlayback()
        self.responseHandler?.onPlayerEvent(event:.onContentPlayDidFinish, info: [:])
    }
    
    /**
     This function is used to implement the behaviour when AVPlayer has failed playing.
     In this situation Conviva session should be cleaned up.
     */
    @objc private func didFailPlaying(_ sender: Notification) -> Void {
        
        Swift.print("didFailPlaying \(sender)")
        
        /// When the playback is attempted in very low bandwidth (~56kbps) the AVPlayerItemPlaybackStalled event is recieved which causes playback error. This is not handled in the library hence we need to explicitely send this error.
        /// Since for this event, sender.userInfo is nil, we need to send custom error.
        //if sender.name == NSNotification.Name.AVPlayerItemPlaybackStalled {
        //    let error = NSError(domain:"", code:401, userInfo:[ NSLocalizedDescriptionKey: "Playback stalled"])
        //    playerEventManager.didFailPlayback(player: self.avPlayer as Any, error: error as Error)
        
        
        self.responseHandler?.onPlayerEvent(event:.onContentPlayDidFail, info: [:])
    }
    
    /**
     This function is used to implement the behaviour when application switches between Background - Foreground.
     When the app goes to Background, Conviva session should be cleaned up.
     When the app goes to Foreground, a new Conviva session should be created.
     */
    @objc private func didChangeAppState(_ sender: Notification) -> Void {
        #if os(iOS)
        if (sender.name == UIApplication.didEnterBackgroundNotification) {
            playerEventManager.didEnterBackground()
        }
        if (sender.name == UIApplication.willEnterForegroundNotification) {
            if avPlayer != nil {
                playerEventManager.willEnterForeground(player: avPlayer as Any, assetInfo: self.asset)
                avPlayer?.play()
            }
        }
        #endif
    }
    
    /**
     This function is used to implement the behaviour when there is a audio interruption.
     Implement functionality under case .began in scenarios like:
     1. when the incoming call starts
     2. when the alarm notification shows up
     
     Implement functionality under case .ended in scenarios like:
     1. when the incoming call ends unanswered
     2. when the incoming call is declined by the user
     3. when the incoming call is answered by the user and completes
     4. when the alarm notification is dismissed by the user
     */
    @objc func handleAudioInterruption(_ notification: Notification) {
        if notification.name != AVAudioSession.interruptionNotification || notification.userInfo == nil{
            return
        }
        var info = notification.userInfo!
        var intValue: UInt = 0
        (info[AVAudioSessionInterruptionTypeKey] as! NSValue).getValue(&intValue)
        if let type = AVAudioSession.InterruptionType.init(rawValue: intValue) {
            switch type {
            case .began:
                // Capture interruption start scenarios here. For example:
                // 1. when the incoming call starts
                // 2. when the alarm notification shows up
                self.playerEventManager.didReceiveAudioInterruption()
            case .ended:
                // Capture interruption end scenarios here. For example:
                // 1. when the incoming call ends unanswered
                // 2. when the incoming call is declined by the user
                // 3. when the incoming call is answered by the user and completes
                // 4. when the alarm notification is dismissed by the user
                if self.avPlayer != nil {
                    self.playerEventManager.didFinishAudioInterruption(player: self.avPlayer as Any, assetInfo: self.asset)
                    self.avPlayer?.play()
                }
            }
        }
    }
    
    /**
     This function is used to implement the behaviour when there is a change in cellular status of the application.
     This implementation is unused and will be removed later.
     */
    /*
    func handleCallStateChange() {
        if let callCenter = self.callCenter {
            callCenter.callEventHandler = { call in
                switch call.callState {
                case CTCallStateIncoming:
                    self.playerEventManager.didEnterBackground()
                case CTCallStateDialing:
                    self.playerEventManager.didEnterBackground()
                case CTCallStateConnected:
                    // During connected calls, no action of Conviva as the earlier session was already ended and a new session will be created when the call is disconnected. No monoting or session lifecycle during call is happening.
                    print(#function, call.callState)
                case CTCallStateDisconnected:
                    if self.avPlayer != nil {
                        self.playerEventManager.willEnterForeground(player: self.avPlayer as Any, assetInfo: self.asset)
                        self.avPlayer?.play()
                    }
                default:
                    print(#function, call.callState)
                }
            }
        }
    }
    */
    
    /**
     This function is the  observer for AVPlayer's rate property.
     */
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "rate" {
            if let avPlayer = avPlayer {
                if avPlayer.rate > 0.01 {
                    // avPlayer is playing. Can be used later to update the UI etc.
                }
                else{
                    // avPlayer is paused. Can be used later to update the UI etc.
                }
            }
        }
        if keyPath == #keyPath(AVPlayer.currentItem.status) {
            let newStatus: AVPlayerItem.Status
            if let newStatusAsNumber = change?[NSKeyValueChangeKey.newKey] as? NSNumber {
                newStatus = AVPlayerItem.Status(rawValue: newStatusAsNumber.intValue)!
            } else {
                newStatus = .unknown
            }
            if newStatus == .failed {
                
                self.responseHandler?.onPlayerEvent(event:.onContentPlayDidFail, info: [:])

                NSLog("Error: \(String(describing: self.avPlayer?.currentItem?.error?.localizedDescription)), error: \(String(describing: self.avPlayer?.currentItem?.error))")
            }
        }
        
        if #available( iOS 10.0, tvOS 10.0, *) {
        if keyPath == #keyPath(AVPlayer.timeControlStatus) {
            
            if let playStateAsNumber = change?[NSKeyValueChangeKey.newKey] as? NSNumber {
                
                if let playState =  AVPlayer.TimeControlStatus(rawValue: playStateAsNumber.intValue) {
                
                    switch playState {
                    case .playing:
                        self.responseHandler?.onPlayerEvent(event:.onContentPlayDidPlay, info: [:])
                    case .paused:
                        fallthrough
                    case .waitingToPlayAtSpecifiedRate:
                        self.responseHandler?.onPlayerEvent(event:.onContentPlayDidPause, info: [:])
                   
                    }
                    
                }
            }
        }
        }
    }
    
    /**
     This function is used to implement the behaviour when AVPlayer playback has stopped.
     */
    func stopPlayback() {
        removePeriodicTimeObserver();
        deRegisterAppStateChangeNotifications()
        deRegisterAudioInterruptionNotifications()
        if let avPlayer = avPlayer {
            deRegisterPlayerNotification(avPlayer)
            avPlayer.pause();
        }
    }
}
