//
//  CVAPlayerContentViewProvider.swift
//  ConvivaIntegrationRefKit
//
//  Created by Butchi peddi on 04/09/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol CVAPlayerContentViewProvider {
    func playerContentView() -> UIView;
}

@objc public protocol CVAAdViewProvider {
    func adView() -> CVAAdView
}
