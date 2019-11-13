//
//  Constants.swift
//  CVAReferenceApp
//
//  Created by Gaurav Tiwari on 30/08/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

/// A common struct to keep all the constant values which are used in Conviva integration.
struct Conviva {
    
    /// A struct used to store basic Credentials required for Conviva setup.
    struct Credentials {
        static let gatewayURLKey = "gatewayUrl"
        static let customerKey   = "1a6d7f0de15335c201e8e9aacbc7a0952f5191d7"
        static let gatewayURLTest = "https://conviva.testonly.conviva.com"
        static let gatewayURLProd = "https://cws.conviva.com"
    }

    /// A struct used to store list of playback URLs.
    struct URLs {
        static let devimagesURL = "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"
        static let unencryptedURL = "http://localhost/unencrypted/prog_index.m3u8"
        static let encryptedURL1 = "http://localhost/encrypted/master.m3u8"
        static let encryptedURL2 = "http://172.19.3.111/encrypted/master.m3u8"
        static let encryptedURL3 = "https://willzhanmswest.streaming.mediaservices.windows.net/92fc0471-0878-4eeb-80a3-e5b6fc497806/NoAudio.ism/manifest(format=m3u8-aapl)"
        static let sampleLocalURL = "http://localhost/sample/index.m3u8"
    }

    struct Errors {
        static let initializationError = "Conviva Error : failed to create session"
        static let typeNotAVPlayer = "Conviva Error : The player is not of type AVPlayer"
        static let typeNotAVQueuePlayer = ""
        static let typeNotBrightcove = ""
        static let typeNotValid = ""
    }
    
    /// A struct used to store list of keys for dictionaries used in the app.
    struct Keys {
        
        /// A struct used to store list of keys for ConvivaContentInfo.
        struct ConvivaContentInfo {
            // Ref : https://community.conviva.com/site/global/platforms/ios/av_player/index.gsp#setMetadata
            static let assetName = "assetName"
            static let streamUrl = "streamUrl"
            static let playerName = "playerName"
            static let viewerId = "viewerId"
            static let resource = "resource"
            
            static let tags = "tags"
            static let isLive    = "isLive"
            static let contentLength = "contentLength"
            static let encodedFramerate = "encodedFramerate"
        }
        
        /// A struct used to store list of keys which customer can use for  passing Metadata.
        struct Metadata {
            static let title = "assetName"
            static let url = "streamUrl"
            static let playerName = "playerName"
            static let userId = "viewerId"
            static let resource = "resource"

            static let live    = "isLive"
            static let duration = "contentLength"
            static let efps = "encodedFramerate"
            static let tags = "tags"

            static let matchId = "matchId"
            static let productType = "productType"
            static let playerVendor = "playerVendor"
            static let playerVersion = "playerVersion"
            static let product = "product"
            static let assetID = "assetID"
            static let carrier = "carrier"
            
            static let deviceID = "deviceID"
            static let appBuild = "appBuild"
            static let favouriteTeam = "favouriteTeam"
        }
        
        static let infoDictionary = "CFBundleShortVersionString"
    }

    /// A struct used to store list of values for dictionaries used in the app.
    struct Values {
        
        /// A struct used to store list of values which customer can use for  passing Metadata.
        struct Metadata {
            static let title = "Avengers"
            static let live    = true
            static let duration = 120
            static let efps = 60
            static let userId = "50334345"
            static let playerName = "Redbox iOS"
            
            static let matchId = "12345"
            static let productType = "Premium"
            static let playerVendor = "Apple"
            static let playerVersion = "N/A"
            static let product = "Internal"
            static let assetID = "87623"
            static let carrier = "N/A"
        }
    }
}

/// A struct used to store list of Environment type.
enum Environment : RawRepresentable {
    case testing
    case production
    
    typealias RawValue = Bool
    var rawValue: RawValue {
        return self == .testing ? true : false
    }
    init?(rawValue: RawValue) {
        self = rawValue == true ? .testing : .production
    }
}
