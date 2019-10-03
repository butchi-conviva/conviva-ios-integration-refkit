//
//  ConvivaBase.swift
//  ConvivaIntegrationRefKit
//
//  Created by Gaurav Tiwari on 25/09/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

import Foundation

protocol ConvivaBase {
    var customerKey : String {get set}
    var gatewayURL : String {get set}
    var logLevel : Bool {get set}
    func setupConvivaMonitoring()
}

extension ConvivaBase {
    var customerKey : String {
        set {
            customerKey = customerKey
        }
        get {
            return "1a6d7f0de15335c201e8e9aacbc7a0952f5191d7"
        }
    }
    
    var gatewayURL : String {
        set {
            gatewayURL = gatewayURL
        }
        get {
            return "https://conviva.testonly.conviva.com"
        }
    }
    
    var logLevel : Bool {
        set {
            logLevel = false
        }
        get {
            return false
        }
    }
}
