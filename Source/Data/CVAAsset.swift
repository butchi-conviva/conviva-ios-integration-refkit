//
//  CVAAsset.swift
//  CVAReferenceApp
//
//  Created by Butchi peddi on 22/08/19.
//  Copyright © 2019 Conviva. All rights reserved.
//

import Foundation

public class CVAAsset: NSObject {
  
  private(set) var title:String?
  private(set) var desc:String?
  private(set) var callsign:String?
  private(set) var thumbnail:String?
  private(set) var playbackURI:String?
  
  init(data:Dictionary<String,Any>) {
   
    self.title = (data[CVAAssetKeys.title] as? String) ?? "NA";
    self.desc = (data[CVAAssetKeys.desc] as? String) ?? "NA";
    self.callsign = (data[CVAAssetKeys.callsign] as? String) ?? "NA";
    self.thumbnail = (data[CVAAssetKeys.thumbnail] as? String) ?? "NA";
    self.playbackURI = (data[CVAAssetKeys.playbackURI] as? String) ?? "NA";
    
    super.init()
    
  }
}
