//
//  CVAPlayerConstants.swift
//  CVAReferenceApp
//
//  Created by Butchi peddi on 22/08/19.
//  Copyright © 2019 Conviva. All rights reserved.
//

import Foundation

public enum CVAPlayerCommand : String {
    
    case start = "start"
    case play = "play"
    case pause = "pause"
    case seek = "seek"
    case stop = "stop"
    case skipfwd = "skipfwd"
    case skipbwd = "skipbwd"
    case replay = "replay"
    case retry = "retry"
    
}

public enum CVAPlayerStatus {
    case failed
    case success
}

let playbackPosition = "playbackPosition";
let totalContentDuration = "totalContentDuration";
let kAVPlayerLayer = "kAVPlayerLayer";

let kGoogleIMAAdView = "kGoogleIMAAdView";
