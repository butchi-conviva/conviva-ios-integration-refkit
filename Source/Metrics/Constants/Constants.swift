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
  
  struct MetadataKeys {
    static let useruuid = "useruuid"
    static let isLive = "isLive"
    static let title = "title"
    static let customMetadata = "customMetadata"
  }
  
  struct MetadataTagsKeys {
    static let matchId = "matchId"
    static let premium = "premium"
  }
}
