//
//  CVAPlayerEvents.swift
//  CVAReferenceApp
//
//  Created by Butchi peddi on 22/08/19.
//  Copyright © 2019 Conviva. All rights reserved.
//

import Foundation

public enum CVAPlayerEvent : String {

    case onPlayHeadChange          = "onPlayHeadChange"
    case onPlayerStateChange       = "onPlayerStateChange"
    case onPlayerdidFinishPlaying  = "onPlayerdidFinishPlaying"
    case onPlayerdidFailPlaying     = "onPlayerdidFailPlaying"

    case onAdLoading                =   "onAdLoading"
    case onAdLoadDidFail            =   "onAdLoadDidFail"
    case onAdPlayDidStart           =   "onAdPlayDidStart"
    case onAdPlayDidFail            =   "onAdPlayDidFail"
    case onAdPlayDidFinish          =   "onAdPlayDidFinish"
     
     public static let allValues =
     
     [onPlayHeadChange.rawValue,
     onPlayerStateChange.rawValue,
     onPlayerdidFinishPlaying.rawValue,
     onPlayerdidFailPlaying.rawValue,
     
     onAdLoading.rawValue,
     onAdLoadDidFail.rawValue,
     onAdPlayDidStart.rawValue,
     onAdPlayDidFail.rawValue,
     onAdPlayDidFinish.rawValue];

    /*


    case onContentLoading           =   "onContentLoading"
    case onContentLoadDidFail       =   "onContentLoadDidFail"
    case onContentPlayDidStart      =   "onContentPlayDidStart"
    case onContentPlayDidFail       =   "onContentPlayDidFail"
    case onContentPlayDidFinish     =   "onContentPlayDidFinish"
    case onPlayHeadChange           =   "onPlayHeadChange"
    case onPlayerStateChange        =   "onPlayerStateChange"
    case onAdLoading                =   "onAdLoading"
    case onAdLoadDidFail            =   "onAdLoadDidFail"
    case onAdPlayDidStart           =   "onAdPlayDidStart"
    case onAdPlayDidFail            =   "onAdPlayDidFail"
    case onAdPlayDidFinish          =   "onAdPlayDidFinish"

    public static let allValues =
        [onContentLoading.rawValue,
         onContentLoadDidFail.rawValue,
         onContentPlayDidStart.rawValue,
         onContentPlayDidFail.rawValue,
         onContentPlayDidFinish.rawValue,
         onPlayHeadChange.rawValue,
         onPlayerStateChange.rawValue,
         onAdLoading.rawValue,
         onAdLoadDidFail.rawValue,
         onAdPlayDidStart.rawValue,
         onAdPlayDidFail.rawValue,
         onAdPlayDidFinish.rawValue];

     */

}
