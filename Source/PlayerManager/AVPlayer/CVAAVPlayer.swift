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
    var avPlayerLayer:AVPlayerLayer?
    var convivaWrapper : ConvivaWrapper!
    var responseHandler:CVAPlayerResponseHandler?;
    var timeObserverToken: Any?
    var asset:CVAAsset?
  
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
  
  private func stopPlayback() {
    removePeriodicTimeObserver();
    avPlayer.pause();
    avPlayer = nil;
  }
  
}

extension CVAAVPlayer : CVAPlayerCommandHandler {
  public var playerResponseHandler: CVAPlayerResponseHandler? {
    get {
      return responseHandler;
    }
    set {
      responseHandler = newValue;
    }
  }
  
  public func startAssetPlayback(asset:CVAAsset) -> CVAPlayerStatus {
    
    self.asset = asset;
    initializeAVPlayer()
    convivaWrapper = ConvivaWrapper(avPlayer: avPlayer!, environment: .testing)
    convivaWrapper.initiateSesionWithMetadata(title: "Avengers", useruuid: "50334345", isLive: true, premium: true, matchId: "12345")
    
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

    return .success;
  }
  
  private func seek (avplayer : AVPlayer, value: Float) {
    
    if let duration = avplayer.currentItem?.duration {
      let totalSeconds = CMTimeGetSeconds(duration)
      
      let value = Float64(value) * totalSeconds
      
      let seekTime = CMTime(value: Int64(value), timescale: 1)
      
        convivaWrapper.seekStart(position: NSInteger(value));
      avplayer.seek(to: seekTime, completionHandler: { (completedSeek) in
        //perhaps do something later here
        
        if true == completedSeek{
            self.convivaWrapper.seekEnd(position: NSInteger(value));
        }
      })
    }
  }
}
