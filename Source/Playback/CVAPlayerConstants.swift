//
//  CVAPlayerConstants.swift
//  CVAReferenceApp
//
//  Created by Butchi peddi on 22/08/19.
//  Copyright © 2019 Conviva. All rights reserved.
//

import Foundation

struct PlayerError {
    static let Playback_Failed_Error = (code: -1001, domain: "playback_failed_error")
    static let Playback_Stalled_Error = (code: -1002, domain: "playback_stalled_error")
    static let Encrypted_Key_URL_Error = (code: -1003, domain: "encrypted_key_url_error")
    static let Encrypted_Key_Error = (code: -1004, domain: "encrypted_key_error")
    static let Unknown_Error = (code: -1005, domain: "unknown_error")
}

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

public enum CVAAdPlayerCommand : String {
    case start = "start"
    case skip = "skip"
    case stop = "stop"
}

public enum CVAPlayerStatus {
    case failed
    case success
}

let playbackPosition = "playbackPosition";
let totalContentDuration = "totalContentDuration";
let kAVPlayerLayer = "kAVPlayerLayer";
let kGoogleIMAAdView = "kGoogleIMAAdView";


