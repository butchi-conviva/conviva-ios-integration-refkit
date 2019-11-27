//
//  CVAContentSessionProvider.swift
//  ConvivaIntegrationRefKit
//
//  Created by Gaurav Tiwari on 26/11/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

import Foundation
import ConvivaCore

/// To create a Conviva session for ads, its mandatory to pass a Conviva session for content.
/// Following protocol is used to pass Conviva content session between Conviva integration managers i.e. between CVAPlayerEventsManager and CVAAdsEventsManager
public protocol CVAContentSessionProvider {
    func didRecieveContentSession(session: ConvivaLightSession)
}
