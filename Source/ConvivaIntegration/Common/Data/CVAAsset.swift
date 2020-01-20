//
//  CVAAsset.swift
//  CVAReferenceApp
//
//  Created by Butchi peddi on 22/08/19.
//  Copyright © 2019 Conviva. All rights reserved.
//

import Foundation

public class CVAAsset: NSObject {
    
    static let mediaURL = NSURL(string: Conviva.URLs.hostedContent1)
//    static let mediaURL = NSURL(string: Conviva.URLs.encryptedURL1)
//      static let mediaURL = NSURL(string: Conviva.URLs.encryptedURL2)
//    static let mediaURL = NSURL(string: Conviva.URLs.encryptedURL3)
//    static let mediaURL = NSURL(string: Conviva.URLs.unencryptedURL)
//    static let mediaURL = NSURL(string: Conviva.URLs.devimagesURL)
//    static let mediaURL = NSURL(string: "http://localhost/sample/index.m3u8")
    static let defaultCDN = "akamai"
    
    private(set) var title:String?
    private(set) var desc:String?
    private(set) var callsign:String?
    private(set) var thumbnail:String?
    private(set) var backdropImage:String?
    private(set) var mediaType:String?
    private(set) var playbackURI:NSURL?
    private(set) var cdn:String?
    private(set) var  islive:Bool = false;
    private(set) var  duration:Int = 1 * 60 * 60;
    private(set) var  efps:Int = 30;
    private(set) var  contentid:Int64 = 30;

    var watchedDuration:Float64 = 0;

    private(set) var  encrypted:Bool = false;
    private(set) var  supportedAdTypes:CVASupportedAdTypes = .preroll;
    init(data:Dictionary<String,Any>?, isLive: Bool) {
        
        if let actualData = data {
            
            self.title = (actualData[CVAAssetKeys.title] as? String) ?? "NA";
            self.desc = (actualData[CVAAssetKeys.desc] as? String) ?? "NA";
            self.callsign = (actualData[CVAAssetKeys.callsign] as? String) ?? "NA";
            
            if let thumbNail = (actualData[CVAAssetKeys.thumbnail] as? String) {
                self.thumbnail = "https://image.tmdb.org/t/p/w500" + thumbNail
            }
            else {
                self.thumbnail = "NA";
            }
            
            if let backdropImage = (actualData[CVAAssetKeys.backdropImage] as? String) {
                self.backdropImage = "https://image.tmdb.org/t/p/w500" + backdropImage
            }
            else {
                self.backdropImage = "NA";
            }
            
            self.mediaType  = (actualData[CVAAssetKeys.mediaType] as? String) ?? "NA";
            self.cdn = (actualData[CVAAssetKeys.cdn] as? String) ?? CVAAsset.defaultCDN;
            self.contentid = (actualData[CVAAssetKeys.contenid] as? Int64) ?? 0;
            self.watchedDuration = (actualData[CVAAssetKeys.watchedDuration] as? Float64) ?? 0;
            self.islive = isLive;
            
            let contentNode = (actualData[CVAAssetKeys.content] as? Dictionary<String,Any>);
            if let content = contentNode {
                
                let mediaURLString = (content[CVAAssetKeys.streamUrl] as? String);
                self.playbackURI = (nil != mediaURLString) ? NSURL(string: mediaURLString!) : CVAAsset.mediaURL;
                self.encrypted = (content[CVAAssetKeys.encrypted] as? Bool) ?? false;
                self.supportedAdTypes = CVASupportedAdTypes(rawValue:(content[CVAAssetKeys.adtype] as? Int) ?? 0);
            }
            
        }
        
        super.init()
    }
}

/// An extension of class CVAAsset which is used to provide basic objects which are used in Conviva calls.
extension CVAAsset {
    /**
     This function prepares the Metadata values which will be lated passed to Conviva.
     */
    func getMetadata(asset : CVAAsset) -> [String : Any] {
        return [Conviva.Keys.Metadata.title : asset.title ?? "Default Asset",
                Conviva.Keys.Metadata.userId : Conviva.Values.Metadata.userId,
                Conviva.Keys.Metadata.playerName : Conviva.Values.Metadata.playerName,
                Conviva.Keys.Metadata.live : asset.islive,
                Conviva.Keys.Metadata.duration : asset.duration,
                Conviva.Keys.Metadata.efps : asset.efps,
                Conviva.Keys.Metadata.tags : getCustomTags() as NSMutableDictionary] as [String : Any]
    }
    
    /**
     This function prepares the Metadata's tags values which will be lated passed to Conviva.
     */
    func getCustomTags() -> NSMutableDictionary {
        #if os(iOS)
        let deviceID = UIDevice.current.identifierForVendor?.uuidString
        #else
        let deviceID = ""
        #endif
        
        let customTags = NSMutableDictionary()
        customTags[Conviva.Keys.Metadata.matchId] = Conviva.Values.Metadata.matchId
        customTags[Conviva.Keys.Metadata.productType] = Conviva.Values.Metadata.productType
        customTags[Conviva.Keys.Metadata.playerVendor] = Conviva.Values.Metadata.playerVendor
        customTags[Conviva.Keys.Metadata.playerVersion] = Conviva.Values.Metadata.playerVersion
        customTags[Conviva.Keys.Metadata.product] = Conviva.Values.Metadata.product
        customTags[Conviva.Keys.Metadata.assetID] = Conviva.Values.Metadata.assetID
        customTags[Conviva.Keys.Metadata.carrier] = Conviva.Values.Metadata.carrier
        customTags[Conviva.Keys.Metadata.deviceID] = deviceID as Any
        customTags[Conviva.Keys.Metadata.appBuild] = Bundle.main.object(forInfoDictionaryKey: Conviva.Keys.infoDictionary) as Any
        customTags[Conviva.Keys.Metadata.favouriteTeam] = UserDefaults.getFavouriteTeamName() as Any
        
        let customTagsForCI = getCustomTagsForCI()
        customTags.addEntries(from: customTagsForCI)
        return customTags
    }
}
