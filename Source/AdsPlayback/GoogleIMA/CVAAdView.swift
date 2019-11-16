//
//  CVAAdView.swift
//  ConvivaIntegrationRefKit
//
//  Created by Gaurav Tiwari on 13/11/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

import Foundation
import UIKit

@objc(CVAAdView)

public class CVAAdView : UIView {
    private(set) var adView : UIView?
    
    public init(adView : UIView) {
        self.adView = adView;
        super.init(frame: CGRect.zero);
        
        self.adView!.frame = self.bounds
        self.layer.addSublayer((self.adView?.layer)!);
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented. Please use init(avPlayerLayer:)")
    }
    
    override public func didMoveToWindow() {
        super.didMoveToWindow()
        self.backgroundColor = .black
        self.adView?.frame = self.bounds;
    }
    
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.backgroundColor = .black
        self.adView?.frame = self.bounds;
    }
}
