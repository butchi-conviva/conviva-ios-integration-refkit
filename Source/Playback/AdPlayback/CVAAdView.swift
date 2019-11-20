//
//  CVAAdView.swift
//  ConvivaIntegrationRefKit
//
//  Created by Gaurav Tiwari on 13/11/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

import Foundation
import UIKit

/// A class which is used to provide a view for ad playback. This view will be passed to Ad managers for ads playback.

@objc(CVAAdView)

public class CVAAdView : UIView {
//    private(set) var adView : UIView?
//
//    /**
//     The CVAAdView class initializer. This initializer initializes CVAAdView class with provieded UIView instance.
//     - Parameters:
//        - adView: Provided instance of UIView
//     */
//    public init(adView : UIView) {
//        self.adView = adView;
//        super.init(frame: CGRect.zero);
//
//        self.adView!.frame = self.bounds
//        self.layer.addSublayer((self.adView?.layer)!);
//    }
    
    /**
     The CVAAdView class initializer. This initializer initializes CVAAdView class with provieded frame.
     - Parameters:
         - frame: Provided instance of CGRect
     */
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented. Please use init(avPlayerLayer:)")
    }
    
    /**
     Tells the view that its window object changed.
     */
    override public func didMoveToWindow() {
        super.didMoveToWindow()
        self.backgroundColor = .clear
        //self.adView?.frame = self.bounds;
    }

    /**
     Tells the view that its superview changed.
     */
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.backgroundColor = .clear
        //self.adView?.frame = self.bounds;
    }
}
