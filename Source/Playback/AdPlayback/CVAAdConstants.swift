//
//  CVAAdConstants.swift
//  ConvivaIntegrationRefKit
//
//  Created by Butchi peddi on 15/12/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

import Foundation

struct CVASupportedAdTypes : OptionSet {
    
    let rawValue: Int
    static let noroll = CVASupportedAdTypes(rawValue:  0 << 0)
    static let preroll = CVASupportedAdTypes(rawValue:  1 << 0)
    static let midroll = CVASupportedAdTypes(rawValue:  1 << 1)
    static let postroll = CVASupportedAdTypes(rawValue: 1 << 2)
}
