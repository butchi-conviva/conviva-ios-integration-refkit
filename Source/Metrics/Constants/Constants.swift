//
//  Constants.swift
//  CVAReferenceApp
//
//  Created by Gaurav Tiwari on 30/08/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

struct Conviva {
    struct Credentials {
        static let customerKey = "1a6d7f0de15335c201e8e9aacbc7a0952f5191d7"
        static let gatewayURL = "https://conviva.testonly.conviva.com"
    }

    struct URLs {
        static let devimagesURL = "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"
    }

    struct Keys {
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
    }

    struct Values {
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
