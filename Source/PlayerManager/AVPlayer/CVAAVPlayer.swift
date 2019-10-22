//
//  CVAAVPlayer.swift
//  CVAReferenceApp
//
//  Created by Butchi peddi on 03/09/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import AVFoundation

public class CVAAVPlayer: NSObject {
    var avPlayer : AVPlayer!
    var avPlayerLayer : AVPlayerLayer?
    var convivaAVPlayerIntegrationRef : CVAAVPlayerIntegrationRef!
    var asset : CVAAsset!
    var responseHandler:CVAPlayerResponseHandler?;
    var timeObserverToken: Any?
  
  private func initializeAVPlayer() {
    
    guard nil != self.asset else {
        Swift.print("Empty asset info");
        return;
    }
    
    guard  nil != self.asset?.playbackURI else {
        Swift.print("Empty asset url");
        return;
    }
    
    let videoURL = self.asset?.playbackURI;
    
    avPlayer = AVPlayer(url: videoURL! as URL)
    self.avPlayerLayer = AVPlayerLayer(player: avPlayer)
    
    avPlayer!.play()
    addPeriodicTimeObserver();
    
    DispatchQueue.main.async {
        self.responseHandler?.onPlayerCommandComplete(command: .play, status: .success, info: [kAVPlayerLayer:self.avPlayerLayer]);
    }
  }  
}

// Following extension implements CVAPlayerCommandHandler functions
extension CVAAVPlayer : CVAPlayerCommandHandler {
    public var playerResponseHandler: CVAPlayerResponseHandler? {
        get {
            return responseHandler;
        }
        set {
            responseHandler = newValue;
        }
    }
    
    public func startAssetPlayback(asset : CVAAsset) -> CVAPlayerStatus {
        self.asset = asset
        CVAAVPlayerIntegrationRef.setupConvivaMonitoring()
        
        convivaAVPlayerIntegrationRef = CVAAVPlayerIntegrationRef()
        convivaAVPlayerIntegrationRef.createSession(player: getAVPlayer(), metadata: getMetadata(asset: self.asset))
        return .success;
    }
    
    public func playAsset(asset:CVAAsset) -> CVAPlayerStatus {
        avPlayer!.play()
        return .success;
    }
    
    public func pauseAsset(asset:CVAAsset) -> CVAPlayerStatus {
        avPlayer!.pause()
        return .success;
    }
    
    public func seekAsset(asset:CVAAsset, info : [AnyHashable : Any]) -> CVAPlayerStatus {
        let seekTimeScale = info["value"]
        
        if let time = seekTimeScale {
            seek(avplayer: avPlayer!, value: time as! Float)
        }
        
        return .success;
    }
    
    public func stopAssetPlayback(asset:CVAAsset) -> CVAPlayerStatus {
        stopPlayback();
        convivaAVPlayerIntegrationRef.cleanupSession()
        return .success;
    }
    
    private func seek (avplayer : AVPlayer, value: Float) {
        
        if let duration = avplayer.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            
            let value = Float64(value) * totalSeconds
            
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            
            convivaAVPlayerIntegrationRef.seekStart(position: NSInteger(value));
            avplayer.seek(to: seekTime, completionHandler: { (completedSeek) in
                if true == completedSeek{
                    self.convivaAVPlayerIntegrationRef.seekEnd(position: NSInteger(value));
                }
            })
        }
    }
}

// Following extension implements Notifications and NotificationHandlers related to APlayer
extension CVAAVPlayer {
    private func addPeriodicTimeObserver() {
        // Notify every half second
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.5, preferredTimescale: timeScale)
        
        timeObserverToken = avPlayer.addPeriodicTimeObserver(forInterval: time,
                                                             queue: .main) {
                                                                [weak self] time in
                                                                // update player transport UI
                                                                let elapsedtime = CMTimeGetSeconds(time);
                                                                if(0 < elapsedtime){
                                                                    let totalDuration = CMTimeGetSeconds(self!.avPlayer.currentItem!.duration);
                                                                    self?.responseHandler?.onPlayerEvent(event:.onPlayHeadChange, info: [playbackPosition:elapsedtime,totalContentDuration:totalDuration])
                                                                }
        }
    }
    
    private func removePeriodicTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            avPlayer.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    private func registerPlayerNotification(_ player: AVPlayer) -> Void {
        NotificationCenter.default.addObserver(self, selector:#selector(didFinishPlaying(_:)) , name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:player.currentItem)
        NotificationCenter.default.addObserver(self, selector:#selector(didFailPlaying(_:)) , name:NSNotification.Name.AVPlayerItemFailedToPlayToEndTime, object:player.currentItem)
    }
    
    private func deRegisterPlayerNotification(_ player: AVPlayer) -> Void {
    
    }
    
    private func registerAppStateChangeNotifications() -> Void {
        NotificationCenter.default.addObserver(self, selector:#selector(didChangeAppState(_:)) , name: UIApplication.didEnterBackgroundNotification, object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(didChangeAppState(_:)) , name:UIApplication.didEnterBackgroundNotification, object:nil)
    }
    
    private func deRegisterAppStateChangeNotifications() -> Void {
        
    }
    
    private func addObserverForRate(_ player: AVPlayer) -> Void {
        player.addObserver(self, forKeyPath: "rate", options:NSKeyValueObservingOptions(), context: nil)
    }
    
    @objc private func didFinishPlaying(_ sender: Notification) -> Void {

    }
    
    @objc private func didFailPlaying(_ sender: Notification) -> Void {
        
    }
    
    @objc private func didChangeAppState(_ sender: Notification) -> Void {
        if (sender.name == UIApplication.didEnterBackgroundNotification) {
            convivaAVPlayerIntegrationRef.cleanupSession()
        }
        if (sender.name == UIApplication.didEnterBackgroundNotification) {
            convivaAVPlayerIntegrationRef.createSession(player: getAVPlayer(), metadata: getMetadata(asset: self.asset))
            avPlayer!.play()
        }
    }

    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "rate" {
            
            if avPlayer.rate > 0.01 {
                // avPlayer is playing
            }
            else{
                // avPlayer is paused
            }
        }
    }

    private func stopPlayback() {
        removePeriodicTimeObserver();
        deRegisterPlayerNotification(avPlayer)
        deRegisterAppStateChangeNotifications()
        avPlayer.pause();
        avPlayer = nil;
    }
}

extension CVAAVPlayer {
    private func getAVPlayer() -> AVPlayer {
        let videoURL = NSURL(string: Conviva.URLs.devimagesURL)
        avPlayer = AVPlayer(url: videoURL! as URL)
        self.avPlayerLayer = AVPlayerLayer(player: avPlayer)
        addPeriodicTimeObserver();
        registerPlayerNotification(avPlayer)
        registerAppStateChangeNotifications()
        addObserverForRate(avPlayer)
        avPlayer!.play()
        
        DispatchQueue.main.async {
            self.responseHandler?.onPlayerCommandComplete(command: .play, status: .success, info: [kAVPlayerLayer:self.avPlayerLayer as Any]);
        }
        
        return avPlayer
    }
    
    private func getMetadata(asset : CVAAsset) -> [String : Any] {
        return [Conviva.Keys.Metadata.title : Conviva.Values.Metadata.title,
                Conviva.Keys.Metadata.userId : Conviva.Values.Metadata.userId,
                Conviva.Keys.Metadata.playerName : Conviva.Values.Metadata.playerName,
                Conviva.Keys.Metadata.live : Conviva.Values.Metadata.live,
                Conviva.Keys.Metadata.duration : Conviva.Values.Metadata.duration,
                Conviva.Keys.Metadata.efps : Conviva.Values.Metadata.efps,
                Conviva.Keys.Metadata.tags : getCustomTags() as NSMutableDictionary] as [String : Any]
    }
    
    private func getCustomTags() -> NSMutableDictionary {
        return [Conviva.Keys.Metadata.matchId : Conviva.Values.Metadata.matchId,
         Conviva.Keys.Metadata.productType : Conviva.Values.Metadata.productType,
         Conviva.Keys.Metadata.playerVendor : Conviva.Values.Metadata.playerVendor,
         Conviva.Keys.Metadata.playerVersion : Conviva.Values.Metadata.playerVersion,
         Conviva.Keys.Metadata.product : Conviva.Values.Metadata.product,
         Conviva.Keys.Metadata.assetID : Conviva.Values.Metadata.assetID,
         Conviva.Keys.Metadata.carrier : Conviva.Values.Metadata.carrier,
         Conviva.Keys.Metadata.deviceID : UIDevice.current.identifierForVendor?.uuidString as Any,
         Conviva.Keys.Metadata.appBuild : Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as Any,
         Conviva.Keys.Metadata.favouriteTeam : UserDefaults.getFavouriteTeamName() as Any]
        
        let tags :  NSMutableDictionary = [Conviva.Keys.Metadata.matchId : Conviva.Values.Metadata.matchId,
                                           Conviva.Keys.Metadata.productType : Conviva.Values.Metadata.productType,
                                           Conviva.Keys.Metadata.playerVendor : Conviva.Values.Metadata.playerVendor,
                                           Conviva.Keys.Metadata.playerVersion : Conviva.Values.Metadata.playerVersion,
                                           Conviva.Keys.Metadata.product : Conviva.Values.Metadata.product,
                                           Conviva.Keys.Metadata.assetID : Conviva.Values.Metadata.assetID,
                                           Conviva.Keys.Metadata.carrier : Conviva.Values.Metadata.carrier,
                                           Conviva.Keys.Metadata.deviceID : UIDevice.current.identifierForVendor?.uuidString as Any,
                                           Conviva.Keys.Metadata.appBuild : Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as Any,
                                           Conviva.Keys.Metadata.favouriteTeam : UserDefaults.getFavouriteTeamName() as Any]
        return tags
    }
}
