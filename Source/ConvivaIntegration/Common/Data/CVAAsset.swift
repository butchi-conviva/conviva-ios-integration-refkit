//
//  CVAAsset.swift
//  CVAReferenceApp
//
//  Created by Butchi peddi on 22/08/19.
//  Copyright © 2019 Conviva. All rights reserved.
//

import Foundation

public class CVAAsset: NSObject {
    
//    static let mediaURL = NSURL(string: "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8")
    static let mediaURL = NSURL(string: "http://localhost/sample/index.m3u8")
    static let defaultCDN = "akamai"
    
    private(set) var title:String?
    private(set) var desc:String?
    private(set) var callsign:String?
    private(set) var thumbnail:String?
    private(set) var playbackURI:NSURL?
    private(set) var cdn:String?
    private(set) var  islive:Bool = false;
    private(set) var  duration:Int = 1 * 60 * 60;
    private(set) var  efps:Int = 30;
    private(set) var  contentid:Int64 = 30;
    
    init(data:Dictionary<String,Any>?) {
        
        if let actualData = data {
            
            self.title = (actualData[CVAAssetKeys.title] as? String) ?? "NA";
            self.desc = (actualData[CVAAssetKeys.desc] as? String) ?? "NA";
            self.callsign = (actualData[CVAAssetKeys.callsign] as? String) ?? "NA";
            self.thumbnail = (actualData[CVAAssetKeys.thumbnail] as? String) ?? "NA";
            
            let mediaURLString = (actualData[CVAAssetKeys.playbackURI] as? String);
            self.playbackURI = (nil != mediaURLString) ? NSURL(string: mediaURLString!) : CVAAsset.mediaURL;
            
            self.cdn = (actualData[CVAAssetKeys.cdn] as? String) ?? CVAAsset.defaultCDN;
            self.contentid = (actualData[CVAAssetKeys.contenid] as? Int64) ?? 0;
            
        }
        
        super.init()
    }
}
