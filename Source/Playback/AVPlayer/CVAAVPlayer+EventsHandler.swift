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
        NotificationCenter.default.addObserver(self, selector:#selector(didChangeAppState(_:)) , name: UIApplication.didEnterBackgroundNotification, object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(didChangeAppState(_:)) , name:UIApplication.willEnterForegroundNotification, object:nil)
    }
    
    /**
     This function is used to removed the earlier added AVPlayer Background - Foreground notifications.
     */
    private func deRegisterAppStateChangeNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
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
        avPlayerManager.cleanupSession()
    }
    
    /**
     This function is used to implement the behaviour when AVPlayer has failed playing.
     In this situation Conviva session should be cleaned up.
     */
    @objc private func didFailPlaying(_ sender: Notification) -> Void {
        avPlayerManager.cleanupSession()
    }
    
    /**
     This function is used to implement the behaviour when application switches between Background - Foreground.
     When the app goes to Background, Conviva session should be cleaned up.
     When the app goes to Foreground, Conviva session should be created.
     */
    @objc private func didChangeAppState(_ sender: Notification) -> Void {
        if (sender.name == UIApplication.didEnterBackgroundNotification) {
            avPlayerManager.cleanupSession()
        }
        if (sender.name == UIApplication.willEnterForegroundNotification) {
            if avPlayer != nil {
                avPlayerManager.createSession(player: avPlayer, asset: self.asset)
                avPlayer?.play()
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
                    // avPlayer is playing. Cam 
                }
                else{
                    // avPlayer is paused
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
