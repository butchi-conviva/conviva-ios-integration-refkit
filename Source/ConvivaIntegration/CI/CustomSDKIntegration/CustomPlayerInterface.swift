//
//  CustomPlayerInterface.swift
//  ConvivaIntegrationRefKit
//
//  Created by Gaurav Tiwari on 18/09/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

import Foundation
import ConvivaSDK

class CustomPlayer {
    var videoURL : URL
    
    init(videoURL : URL) {
        self.videoURL = videoURL
    }
    
    func play() {
        
    }
    
    func pause() {
        
    }
    
    func stop() {
        
    }
}

class CustomPlayerInterface {
    var playerStateManager : CISPlayerStateManagerProtocol
    var customPlayer : CustomPlayer
    
    init(playerStateManager : CISPlayerStateManagerProtocol, customPlayer: CustomPlayer) {
        self.playerStateManager = playerStateManager
        self.customPlayer = customPlayer
    }
    
    func cleanupCustomPLayerInterface() {
        
    }
    
    func reportError() {
        
    }
    
    func setPlayerState(playerState : PlayerState) {
        playerStateManager.setPlayerState!(playerState)
    }
    
    func setSeekStart(seekToPosition : NSInteger) {
        playerStateManager.setSeekStart!(Int64(seekToPosition))
    }
    
    func setSeekEnd(seekToPosition : NSInteger) {
        playerStateManager.setSeekEnd!(Int64(seekToPosition))
    }
    
    func setCDNServerIP(cdnServerIP : String) {
        playerStateManager.setCDNServerIP!(cdnServerIP)
    }
    
    func setBitrateKbps(newBitrateKbps: Int) {
        playerStateManager.setBitrateKbps!(newBitrateKbps)
    }
}
