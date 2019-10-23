//
//  CVAAVPlayer+ObjectProvider.swift
//  ConvivaIntegrationRefKit
//
//  Created by Gaurav Tiwari on 22/10/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

import Foundation
import AVFoundation

/// An extension of class CVAAVPlayer which is used to provide basic objects which are used in Conviva calls.

extension CVAAVPlayer {
    
    /**
     This function initializes the AVPlayer.
     */
    func initializeAVPlayer() {
        
        guard nil != self.asset else {
            Swift.print("Empty asset info");
            return;
        }
        
        //        guard nil != self.asset?.playbackURI else {
        //            Swift.print("Empty asset url");
        //            return;
        //        }
        //        let videoURL = self.asset?.playbackURI;
        
        let videoURL = NSURL(string: Conviva.URLs.devimagesURL)
        
        avPlayer = AVPlayer(url: videoURL! as URL)
        self.avPlayerLayer = AVPlayerLayer(player: avPlayer)
        
        addPeriodicTimeObserver();
        
        DispatchQueue.main.async {
            self.responseHandler?.onPlayerCommandComplete(command: .play, status: .success, info: [kAVPlayerLayer:self.avPlayerLayer as Any]);
        }
    }

    func getAVPlayer() -> AVPlayer? {
        let videoURL = NSURL(string: Conviva.URLs.devimagesURL)
        avPlayer = AVPlayer(url: videoURL! as URL)
        self.avPlayerLayer = AVPlayerLayer(player: avPlayer)
        addPeriodicTimeObserver();

        registerAppStateChangeNotifications()

        if let avPlayer = avPlayer {
            registerPlayerNotification(avPlayer)
            addObserverForRate(avPlayer)
            avPlayer.play()
        }

        DispatchQueue.main.async {
            self.responseHandler?.onPlayerCommandComplete(command: .play, status: .success, info: [kAVPlayerLayer:self.avPlayerLayer as Any]);
        }

        if let avPlayer = avPlayer {
            return avPlayer
        }
        else {
            return nil
        }
    }
    
    /**
     This function prepares the Metadata values which will be lated passed to Conviva.
     */
    func getMetadata(asset : CVAAsset) -> [String : Any] {
        return [Conviva.Keys.Metadata.title : Conviva.Values.Metadata.title,
                Conviva.Keys.Metadata.userId : Conviva.Values.Metadata.userId,
                Conviva.Keys.Metadata.playerName : Conviva.Values.Metadata.playerName,
                Conviva.Keys.Metadata.live : Conviva.Values.Metadata.live,
                Conviva.Keys.Metadata.duration : Conviva.Values.Metadata.duration,
                Conviva.Keys.Metadata.efps : Conviva.Values.Metadata.efps,
                Conviva.Keys.Metadata.tags : getCustomTags() as NSMutableDictionary] as [String : Any]
    }
    
    /**
     This function prepares the Metadata's tags values which will be lated passed to Conviva.
     */
    func getCustomTags() -> NSMutableDictionary {
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
    }
}
