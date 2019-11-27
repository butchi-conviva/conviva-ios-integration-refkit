//
//  CVAAdMgrDataSource.swift
//  ConvivaIntegrationRefKit
//
//  Created by Butchi peddi on 19/11/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

import Foundation
import UIKit

public protocol CVAAdDataSource {
    var contentPlayer: Any? { get }
    var contentView: UIView? {get}
}
