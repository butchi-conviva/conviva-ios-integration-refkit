//
//  CVAAdAsset.swift
//  ConvivaIntegrationRefKit
//
//  Created by Butchi peddi on 19/11/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

import Foundation

enum CVAAdType : String {
    /// Following are the set of ad tags supported by Google IMA
    case preroll = "preroll"
    case skippable = "skippable"
    case postroll = "postroll"
    case adRules = "adRules"
    case adRulesPods = "adRulesPods"
    case vmapPods = "vmapPods"
    case wrapper = "wrapper"
    case adSense = "adSense"
}

public class CVAAdAsset: NSObject {

    private(set) var id:Int = 0;
    private(set) var type:CVAAdType = .adRules
    
    init(data:Dictionary<String,Any>?, supportedAdTypes: CVASupportedAdTypes) {
        
        if let actualData = data {
            self.id = (actualData[CVAdAssetKeys.id] as? Int) ?? 0;
        }
        
        if supportedAdTypes == .noroll {
            //  No Ads
        }
        else if supportedAdTypes == .preroll {
            self.type = CVAAdType(rawValue: CVAAdType.preroll.rawValue)!
        }
        else if supportedAdTypes == .postroll {
            self.type = CVAAdType(rawValue: CVAAdType.postroll.rawValue)!
        }
        else {
            self.type = CVAAdType(rawValue: CVAAdType.adRules.rawValue)!
        }
    }
}
