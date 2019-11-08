//
//  CVAAVPlayer+EventsHandler.swift
//  ConvivaIntegrationRefKit
//
//  Created by Gaurav Tiwari on 22/10/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

import Foundation
import AVFoundation
import CoreTelephony

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
                                                                    }
            }
        }
    }
    
    /**
     This function is used to remove the earlier added periodic time observer on AVPlayer.
     */
    private func removePeriodicTimeObserver() {
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
    }
    
    /**
     This function is used to remove the earlier added AVPlayer playback completion Notification.
     */
    func deRegisterPlayerNotification(_ player: AVPlayer) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemFailedToPlayToEndTime, object: player.currentItem)
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
    private func deRegisterAppStateChangeNotifications() {
        #if os(iOS)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        #endif
    }
    
    /**
     This function is used to add observer for AVPlayer's rate property.
     */
    func addObserverForRate(_ player: AVPlayer) {
        player.addObserver(self, forKeyPath: "rate", options:NSKeyValueObservingOptions(), context: nil)
    }
    
    /**
     This function is used to implement the behaviour when AVPlayer has finished playing.
     In this situation Conviva session should be cleaned up.
     */
    @objc private func didFinishPlaying(_ sender: Notification) -> Void {
        playerEventManager.didStopPlayback()
    }
    
    /**
     This function is used to implement the behaviour when AVPlayer has failed playing.
     In this situation Conviva session should be cleaned up.
     */
    @objc private func didFailPlaying(_ sender: Notification) -> Void {
        playerEventManager.didStopPlayback()
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
     This function is used to implement the behaviour when there is a change in cellular status of the application.
     */
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
    }
    
    /**
     This function is used to implement the behaviour when AVPlayer playback has stopped.
     */
    func stopPlayback() {
        removePeriodicTimeObserver();
        deRegisterAppStateChangeNotifications()
        if let avPlayer = avPlayer {
            deRegisterPlayerNotification(avPlayer)
            avPlayer.pause();
        }
    }
}
