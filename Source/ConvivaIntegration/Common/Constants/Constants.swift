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
        static let gatewayURLTest = "https://touchstone.conviva.com"
        static let gatewayURLProd = "https://touchstone.conviva.com"
    }

    /// A struct used to store list of playback URLs.
    struct URLs {
        static let devimagesURL = "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"
        static let unencryptedURL = "http://localhost/unencrypted/prog_index.m3u8"
        static let encryptedURL1 = "http://localhost/encrypted/master.m3u8"
        static let encryptedURL2 = "http://172.19.3.111/encrypted/master.m3u8"
        static let encryptedURL3 = "https://willzhanmswest.streaming.mediaservices.windows.net/92fc0471-0878-4eeb-80a3-e5b6fc497806/NoAudio.ism/manifest(format=m3u8-aapl)"
        static let sampleLocalURL = "http://localhost/sample/index.m3u8"
        static let hostedContent1 =  "http://reference-apps.conviva.com/vod/hls/bipbop/index.m3u8"
        static let hostedContent2 =  "http://reference-apps.conviva.com/vod/hls/avengers/index.m3u8"
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
    
    struct GoogleIMAAdTags {
        // DFP content path
        static let kDFPContentPath = "http://rmcdn.2mdn.net/Demo/html5/output.mp4";
        
        // Android content path
        static let kAndroidContentPath = "https://s0.2mdn.net/instream/videoplayer/media/android.mp4";
        
        // Big buck bunny content path
        static let kBigBuckBunnyContentPath = "http://googleimadev-vh.akamaihd.net/i/big_buck_bunny/" +
        "bbb-,480p,720p,1080p,.mov.csmil/master.m3u8";
        
        // Bip bop content path
        static let kBipBopContentPath = "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8";
        
        // Standard pre-roll
        static let kPrerollTag =
            "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&" +
                "iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&" +
                "output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dlinear&" + "correlator=";
        
        // Skippable
        static let kSkippableTag =
            "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&" +
                "iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&" +
                "output=vast&unviewed_position_start=1&" +
        "cust_params=deployment%3Ddevsite%26sample_ct%3Dskippablelinear&correlator=";
        
        // Post-roll
        static let kPostrollTag =
            "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&" +
                "iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&" +
                "output=vmap&unviewed_position_start=1&" +
                "cust_params=deployment%3Ddevsite%26sample_ar%3Dpostonly&cmsid=496&vid=short_onecue&" +
        "correlator=";
        
        // Ad rues
        static let kAdRulesTag =
            "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&" +
                "iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&" +
                "output=vast&unviewed_position_start=1&" +
                "cust_params=deployment%3Ddevsite%26sample_ar%3Dpremidpost&cmsid=496&vid=short_onecue&" +
        "correlator=";
        
        // Ad rules pods
        static let kAdRulesPodsTag =
            "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&" +
                "iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&" +
                "output=vast&unviewed_position_start=1&" +
                "cust_params=deployment%3Ddevsite%26sample_ar%3Dpremidpostpod&cmsid=496&vid=short_onecue&" +
        "correlator=";
        
        // VMAP pods
        static let kVMAPPodsTag =
            "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&" +
                "iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&" +
                "output=vmap&unviewed_position_start=1&" +
                "cust_params=deployment%3Ddevsite%26sample_ar%3Dpremidpostpod&cmsid=496&vid=short_onecue&" +
        "correlator=";
        
        // Wrapper
        static let kWrapperTag =
            "http://pubads.g.doubleclick.net/gampad/ads?sz=640x480&" +
                "iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&" +
                "output=vast&unviewed_position_start=1&" +
        "cust_params=deployment%3Ddevsite%26sample_ct%3Dredirectlinear&correlator=";
        
        // AdSense
        static let kAdSenseTag =
        "http://googleads.g.doubleclick.net/pagead/ads?client=ca-video-afvtest&ad_type=video";

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
