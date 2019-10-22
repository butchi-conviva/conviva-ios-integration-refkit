//
//  Utils.swift
//  ConvivaIntegrationRefKit
//
//  Created by Gaurav Tiwari on 17/10/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

import Foundation

/// A class used to keep common utilities functions.
class Utilities {
    /**
     Used to get device identifier.
     - Returns:
        - A string type value of device identifier
     */
    func getDeviceID() -> String {
        return (UIDevice.current.identifierForVendor?.uuidString)!
    }
    
    /**
     Used to get application build version.
     - Returns:
        - A string type value of application build version
     */
    func getAppBuildVersion() -> String {
        return (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String)!
    }
}
