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
    var playerContentViewProvider:CVAPlayerContentViewProvider;
    var adCommandHandler:CVAAdCommandHandler;
    var currentAsset:CVAAsset?
    var currentAdAsset:CVAAdAsset?
    
    public init(playerWithCmdHandler:CVAPlayerCommandHandler,
                adCommandHandler:CVAAdCommandHandler,
                playerEventManager:CVAPlayerEventManager,
                playerContentViewProvider:CVAPlayerContentViewProvider) {
        
        self.playerCommandHandler = playerWithCmdHandler;
        self.adCommandHandler = adCommandHandler;
        self.playerEventManager = playerEventManager;
        self.playerContentViewProvider = playerContentViewProvider;
        
        super.init();
        
        playerCommandHandler.playerResponseHandler = self;
        adCommandHandler.dataSource = self;
    }
}

extension CVAPlayerManager : CVAPlayerCmdExecutor {
    
    public func handleEvent(_ eventName: String!, info: [AnyHashable : Any]?) {
        
        let event = CVAPlayerCommand(rawValue: eventName);
        
        let assetInfo = info?["asset"] ?? nil;
        let adInfo = info?["adInfo"] ?? nil;
        
        let asset = (nil != assetInfo ) ? CVAAsset(data: assetInfo as? [String:Any]) : CVAAsset(data: nil);
        let adAsset = (nil != adInfo ) ? CVAAdAsset(data: adInfo as? [String:Any]) : CVAAdAsset(data:nil);
        
        var status:CVAPlayerStatus = .failed;
        
        if let _ = event{
            
            switch event! {
                
            case CVAPlayerCommand.start:
                
                self.currentAsset = asset;
                self.currentAdAsset = adAsset;
                
                status = playerCommandHandler.startAssetPlayback(asset: asset);
                status = playerCommandHandler.pauseAsset(asset: asset);
                
                if let _ = self.currentAdAsset {
                    status = adCommandHandler.startAdPlayback(asset: self.currentAdAsset!)
                }
                
            case CVAPlayerCommand.play:
                status = playerCommandHandler.playAsset(asset: asset);
                
            case CVAPlayerCommand.pause:
                status = playerCommandHandler.pauseAsset(asset: asset);
                
            case CVAPlayerCommand.seek:
                status = playerCommandHandler.seekAsset(asset: asset, info : info!);
                
            case CVAPlayerCommand.stop:
                status = playerCommandHandler.stopAssetPlayback(asset: asset);
                
            case CVAPlayerCommand.skipbwd:
                status = playerCommandHandler.skipbwdAsset(asset: asset, info : info);
                
            case CVAPlayerCommand.skipfwd:
                status = playerCommandHandler.skipfwdAsset(asset: asset, info : info);
                
            case CVAPlayerCommand.replay:
                status = playerCommandHandler.replayAsset(asset: asset, info : info);
                
            case CVAPlayerCommand.retry:
                status = playerCommandHandler.retryAssetPlayback(asset: asset, info:info);
            }
        }
        
        Swift.print("hanldeEvent status \(status)");
    }
    
}

extension CVAPlayerManager : CVAPlayerResponseHandler {
    
    public func onPlayerCommandComplete(command: CVAPlayerCommand,
                                        status: CVAPlayerStatus,
                                        info: [AnyHashable : Any]!) {
        switch command {
        case CVAPlayerCommand.play:
            if status == .success {
                let contentView = self.playerContentViewProvider.playerContentView();

                if let avPlayerLayer = info[kAVPlayerLayer] as? AVPlayerLayer {
                    avPlayerLayer.frame = contentView.bounds;
                    avPlayerLayer.removeFromSuperlayer();
                    contentView.layer.insertSublayer(avPlayerLayer, at:UInt32(contentView.layer.sublayers?.count ?? 0) )
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


extension CVAPlayerManager : CVAAdResponseHandler {
    
    public func onAdCommandComplete(command:CVAAdPlayerCommand,
                                          status:CVAPlayerStatus,
                                          info:[AnyHashable : Any]!) {
        Swift.print("onAdCommandComplete \(command)");
        
        switch command {
        case CVAAdPlayerCommand.start:
            if status == .success {
                let contentView = self.playerContentViewProvider.playerContentView();
                if let adView = info[kGoogleIMAAdView] as? CVAAdView {
                    adView.frame = contentView.bounds;
                    contentView.addSubview(adView)
                }
            }
        default:
            Swift.print("command \(command) status \(status) info \(info)");
        }
        
    }
    
    public func onAdEvent(event:CVAPlayerEvent,
                          info:[AnyHashable : Any]) {
        
        Swift.print("onAdEvent \(event)");
        self.playerEventManager.onPlayerEvent(event: event, info: info);
    }
    
}

extension CVAPlayerManager : CVAAdDataSource {
    
    public var contentPlayer: Any? {
        get {
            return self.playerCommandHandler.contentPlayer;
        }
    }

}

