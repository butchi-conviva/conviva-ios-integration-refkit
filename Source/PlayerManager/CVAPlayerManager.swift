//
//  CVAPlayerManager.swift
//  CVAReferenceApp
//
//  Created by Butchi peddi on 22/08/19.
//  Copyright © 2019 Conviva. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

public class CVAPlayerManager: NSObject {

    var playerCommandHandler:CVAPlayerCommandHandler;
    var playerEventManager:CVAPlayerEventManager;
    var playerContentViewProvider:CVAPlayerContentViewProvider
  
    public init(playerWithCmdHandler:CVAPlayerCommandHandler,playerEventManager:CVAPlayerEventManager,playerContentViewProvider:CVAPlayerContentViewProvider) {
    
    self.playerCommandHandler = playerWithCmdHandler;
    self.playerEventManager = playerEventManager;
    self.playerContentViewProvider = playerContentViewProvider;
        
    super.init();
    
    playerCommandHandler.playerResponseHandler = self;
  }
}

extension CVAPlayerManager : CVAPlayerCmdExecutor {
  
  public func handleEvent(_ eventName: String!, info: [AnyHashable : Any]!) {
    
    let event = CVAPlayerCommand(rawValue: eventName);
    let asset = CVAAsset(data:info as! [String:Any]);
    var status:CVAPlayerStatus = .failed;
    
    if let _ = event{
    
      switch event! {
        case CVAPlayerCommand.start:
          status = playerCommandHandler.startAssetPlayback(asset: asset);
        
        case CVAPlayerCommand.play:
          status = playerCommandHandler.playAsset(asset: asset);

        case CVAPlayerCommand.pause:
          status = playerCommandHandler.pauseAsset(asset: asset);
        
        case CVAPlayerCommand.seek:
          status = playerCommandHandler.seekAsset(asset: asset, info : info);
        
        case CVAPlayerCommand.stop:
          status = playerCommandHandler.stopAssetPlayback(asset: asset);
      }
    }
    
    Swift.print("hanldeEvent status \(status)");
  }
  
}

extension CVAPlayerManager : CVAPlayerResponseHandler {
  
  public func onPlayerCommandComplete(command: CVAPlayerCommand,
                               status: CVAPlayerStatus, info: [AnyHashable : Any]!) {
    switch command {
    case CVAPlayerCommand.play:
        if status == .success {
            if let avPlayerLayer = info[kAVPlayerLayer] as? AVPlayerLayer {
                let contentView = self.playerContentViewProvider.playerContentView();
                avPlayerLayer.frame = contentView.bounds;
                contentView.layer.addSublayer(avPlayerLayer);
                Swift.print("command \(command) status \(status) info \(info) contentView.bounds \(contentView.bounds)");
            }
        }
    default:
        Swift.print("command \(command) status \(status) info \(info)");
    }
    
  }
  
  public func onPlayerEvent(event:CVAPlayerEvent,info:[AnyHashable : Any]) {
    self.playerEventManager.onPlayerEvent(event: event, info: info);
  }
}
