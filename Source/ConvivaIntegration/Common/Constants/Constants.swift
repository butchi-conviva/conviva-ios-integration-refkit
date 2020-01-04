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
        static let encryptedURL1 = "http://localhost/reference-app-server/v1/content/hls/drm/bipbop/index.m3u8"
        static let encryptedURL2 = "http://localhost/reference-app-server/v1/content/hls/drm/avengers/index.m3u8"
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
            
            
            //  Content Insights
            
            static let contentType = "contentType"  //  More advanced content delivery method.
            static let channel = "channel"  //  The channel on which the content is consumed
            static let brand = "brand"  //  The name of the brand to which the content belongs
            static let affiliate = "affiliate"  //  Affiliate or MVPD name for TV Everywhere authenticated services
            static let categoryType = "categoryType"    //  Content business categories of interest

            static let tmsID = "TMSID"    //  If you are using a standardized metadata system like Gracenote
            static let roviID = "ROVIID"    //  If you are using a standardized metadata system like Rovi
            static let cmsID = "CMSID"  //  Customized for each CMS

            static let seriesName = "seriesName"
            static let seasonNumber = "seasonNumber"
            static let showTitle = "showTitle"
            static let episodeNumber = "episodeNumber"
            static let genre = "genre"  //  Primary content genre
            static let genreList = "genreList"  //  A list of applicable content genre in a comma separated list

            static let description = "description"  //  Short description of the content
            static let originalAirDate = "originalAirDate"
            static let imageURL_16x9 = "imageURL_16x9"  //  Asset large image full URL
            static let imageURL_4x3 = "imageURL_4x3"  //  Asset small image full URL
            static let castList = "castList"  //  Comma-separated list of actors
            static let awardsList = "awardsList"  //  Comma-separated list of awards

            static let marketingID = "marketingID"  //  Marketing ID to tie back to Adobe/Salesforce/other marketing tracking tool
            static let sourceType = "sourceType"  //  Source that initiated the video. These could both be in-app actions as well as external actions
            static let sourceURL = "sourceURL"  //  Instance source URL

            static let subscriptionType = "subscriptionType"  //  The type of subscription based on subscriber account status
            static let subscriptionTier = "subscriptionTier"  //  The tier of the subscriber based on business categories; varies based on the offering
            static let viewerClassification = "viewerClassification"  //  Subscriber classification based on business categories; varies based on the offering
            static let acqusitionSource = "acqusitionSource"  //  Source from which the viewer was acquired; varies based on the offering
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
            
            
            //  Content Insights
            
            static let contentType = "VOD"  //  Acceptable list values: [Live, Live-Linear, DVR, Catchup, VOD].
            static let channel = "CNN"
            static let brand = "Disney"
            static let affiliate = "AT&T-DirecTV"
            static let categoryType = "Movies"    //  Acceptable list values: [Episodic, Movies, News, Sports, Events, Informercials, Shorts, Promos]

            static let tmsID = "TMSID"
            static let roviID = "ROVIID"
            static let cmsID = "CMSID"

            static let seriesName = "Friends"    //  Example: "Friends", Null if not applicable
            static let seasonNumber = "1"    //  Example: 1, Null if not applicable
            static let showTitle = "The One with All the Cheesecakes"  //  Example: "The One with All the Cheesecakes".
            static let episodeNumber = "3"  //  Example: 3, Null if not applicable
            static let genre = "Drama"  //  Example: Drama
            static let genreList = "Drama, Crime, Political, Violence"  //  Example: “Drama, Crime, Political, Violence”

            static let description = "Set at the intersection of the near future and the reimagined past, explore a world in which every human appetite can be indulged without consequence."
            static let originalAirDate = "April 17 2011"  //  Example: "April 17 2011"
            static let imageURL_16x9 = "https://tvseriesfinale.com/wp-content/uploads/2018/04/westworld-hbo-season-2-ratings-cancel-renew-season-3.png"
            static let imageURL_4x3 = "https://tvseriesfinale.com/wp-content/uploads/2018/04/westworld-hbo-season-2-ratings-cancel-renew-season-3.png"
            static let castList = "Tim Robbins, Morgan Freeman, Bob Gunton"    // Examples: Tim Robbins, Morgan Freeman, Bob Gunton
            static let awardsList = "Best Picture, Best Actor in a Leading Role, Oscars 2018, Golden Globes 2017"    //  Examples: Best Picture, Best Actor in a Leading Role, Oscars 2018, Golden Globes 2017

            static let marketingID = "12345"
            static let sourceType = "Carousel"    //  Examples: In-App actions - Promotion, Auto-Play, Recommendation, Carousel, Search, Direct, Live_Linear. External - Search, Social, Web Page, Referral.
            static let sourceURL = "http://frame.agency/?utm_source=Facebook&utm_medium=NewsFeed&utm_term=CreativeAgency&utm _content=V-1&utm_campaign=SummerCampaign"

            static let subscriptionType = "Trial"   //  Examples: Trial, Paying.
            static let subscriptionTier = "Tier 1"    //  Examples: Tier 1, Tier 2, Tier 3, Basic
            static let viewerClassification = "Loyal"    //  Examples: Loyal, High Value
            static let acqusitionSource = "Facebook"    //  Examples: Facebook, Marketing Campaign-12314, Super Bowl Campaign.
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
