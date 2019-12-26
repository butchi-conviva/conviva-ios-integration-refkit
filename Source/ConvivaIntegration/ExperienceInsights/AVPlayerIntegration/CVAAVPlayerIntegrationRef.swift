//
//  ConvivaAVPlayer.swift
//  ConvivaIntegrationRefKit
//
//  Created by Gaurav Tiwari on 25/09/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit
import ConvivaCore
import ConvivaAVFoundation

/// A class used to keep all methods used for Conviva AVPlayer integration.
class CVAAVPlayerIntegrationRef : CVABaseIntegrationRef {
    /**
     The AVPlayer instance which needs to be monitored using Conviva monitoring.
     */
    private var videoPlayer : AVPlayer!
    
    /**
     The set of metadata values provided by customer will be contained using this. And then, values from metadataDict are mapped to ConvivaContentInfo.
     */
    private var metadataDict : [String : Any] = [:]

    /**
     The instance of type CVAContentSessionProvider protocol.
     This delegate will be used pass ConvivaLightSession instance from CVAAVPlayerIntegrationRef to CVAPlayerEventsManager.
     */
    var delegate: CVAContentSessionProvider? = nil

    /**
     Used to create a Conviva monitoring session.
     - Parameters:
     - player: The streamer instance which needs to be monitored.
     - metadata: The initial set of metadata values related to a video playback.
     If the initial values are not available, this paramter can be nil as well.
     If the values need to be updated later, please use updateContentMetadata.
     Visit https://community.conviva.com/site/global/platforms/ios/av_player/index.gsp#updateContentMetadata
     */
    func createContentSession(player: Any?, metadata: [String : Any]?) {
        self.videoPlayer = player as? AVPlayer
        self.metadataDict = metadata ?? ["" : ""]
        
        let metadata : [String : Any] = [
            Conviva.Keys.ConvivaContentInfo.assetName : self.metadataDict[Conviva.Keys.Metadata.title] as Any,
            Conviva.Keys.ConvivaContentInfo.viewerId : self.metadataDict[Conviva.Keys.Metadata.userId] as Any,
            Conviva.Keys.ConvivaContentInfo.playerName : self.metadataDict[Conviva.Keys.Metadata.playerName] as Any,
            Conviva.Keys.ConvivaContentInfo.isLive : self.metadataDict[Conviva.Keys.Metadata.live] as Any,
            Conviva.Keys.ConvivaContentInfo.contentLength : self.metadataDict[Conviva.Keys.Metadata.duration] as Any,
            Conviva.Keys.ConvivaContentInfo.encodedFramerate : self.metadataDict[Conviva.Keys.Metadata.efps] as Any,
            Conviva.Keys.ConvivaContentInfo.tags: self.metadataDict[Conviva.Keys.Metadata.tags] as Any]
        
        if let session = LivePass.createSession(withStreamer: self.videoPlayer, andConvivaContentInfo: getConvivaContentInfoFromMetadata(metadata)) {
            self.convivaContentSession = session
            self.delegate?.didRecieveContentSession(session: convivaContentSession)
        }
        else{
            print(Conviva.Errors.initializationError)
        }
    }
    
    /**
     Used to cleanup a Conviva monitoring session.
     */
    func cleanupContentSession() {
        if  self.convivaContentSession != nil {
            LivePass.cleanupSession(self.convivaContentSession)
            self.convivaContentSession = nil
        }
    }
}

extension CVAAVPlayerIntegrationRef {
    /**
     Used to map customer provided metadata values to ConvivaContentInfo instance.
     - Parameters:
        - metadata: A Dictionary containing customer provided metadata
     
     - Returns: A ConvivaContentInfo instance which has mapped customer provided metadata values.
     */
    private func getConvivaContentInfoFromMetadata(_ metadata : Dictionary<String, Any>) -> ConvivaContentInfo {
        convivaMetadata = ConvivaContentInfo.createInfoForLightSession(withAssetName: metadataDict[Conviva.Keys.ConvivaContentInfo.assetName] as? String ) as? ConvivaContentInfo
        
        convivaMetadata.viewerId = metadataDict[Conviva.Keys.ConvivaContentInfo.viewerId] as? String
        convivaMetadata.playerName = metadataDict[Conviva.Keys.ConvivaContentInfo.playerName] as? String
        convivaMetadata.isLive = (metadataDict[Conviva.Keys.ConvivaContentInfo.isLive] != nil) ? true : false
        convivaMetadata.resource = CDN_NAME_AKAMAI
        convivaMetadata.encodedFramerate = metadataDict[Conviva.Keys.ConvivaContentInfo.encodedFramerate] as! Int
        
        /// Since AVPlayer library auto-collects content length, following reporting of contentLength should be avoided.
        /// In case customer(s) are willing to send their own custom contentLength value, they can uncommennt following and the value being set in asset will be picked up.
        // convivaMetadata.contentLength = metadataDict[Conviva.Keys.ConvivaContentInfo.contentLength] as! Int
        convivaMetadata.tags = metadataDict[Conviva.Keys.ConvivaContentInfo.tags] as? NSMutableDictionary
        return convivaMetadata
    }
}
