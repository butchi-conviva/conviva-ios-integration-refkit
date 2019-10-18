//
//  Utils.swift
//  ConvivaIntegrationRefKit
//
//  Created by Gaurav Tiwari on 17/10/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

import Foundation

class Utils {
    
    func getDeviceID() -> String {
        return (UIDevice.current.identifierForVendor?.uuidString)!
    }
    
    func getAppBuildVersion() -> String {
        return (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String)!
    }
}
