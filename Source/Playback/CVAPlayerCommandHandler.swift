//
//  CVAPlayerHandler.swift
//  CVAReferenceApp
//
//  Created by Butchi peddi on 03/09/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

public protocol CVAPlayerCommandHandler : class {
    
    var contentPlayer: Any? { get }
    
    var playerResponseHandler:CVAPlayerResponseHandler? { get set };
    
    func initAssetPlayback(playerEventManager : CVAPlayerEventsManager, asset : CVAAsset) -> CVAPlayerStatus
    
    func playAsset(asset:CVAAsset) -> CVAPlayerStatus;
    
    func pauseAsset(asset:CVAAsset) -> CVAPlayerStatus;
    
    func seekAsset(asset:CVAAsset, info : [AnyHashable : Any]) -> CVAPlayerStatus;
    
    func skipfwdAsset(asset:CVAAsset, info : [AnyHashable : Any]?) -> CVAPlayerStatus;
    
    func skipbwdAsset(asset:CVAAsset, info : [AnyHashable : Any]?) -> CVAPlayerStatus;
    
    func replayAsset(asset:CVAAsset, info : [AnyHashable : Any]?) -> CVAPlayerStatus;
    
    func stopAssetPlayback(asset:CVAAsset) -> CVAPlayerStatus;
    
    func retryAssetPlayback(asset:CVAAsset,info : [AnyHashable : Any]?) -> CVAPlayerStatus;
    
}
