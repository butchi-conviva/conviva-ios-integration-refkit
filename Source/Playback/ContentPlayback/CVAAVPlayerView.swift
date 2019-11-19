//
//  CVAAVPlayerView.swift
//  CVAReferenceApp
//
//  Created by Butchi peddi on 23/08/19.
//  Copyright © 2019 Conviva. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

@objc(CVAAVPlayerView)
public class CVAAVPlayerView: UIView {

  private(set) var avPlayerLayer:AVPlayerLayer?

  public init(avPlayerLayer:AVPlayerLayer) {
    
    self.avPlayerLayer = avPlayerLayer;
    super.init(frame: CGRect.zero);
    
    self.avPlayerLayer!.frame = self.bounds
    self.layer.addSublayer(self.avPlayerLayer!);
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented. Please use init(avPlayerLayer:)")
  }
  
  func setAVPlayerLayer(layer:AVPlayerLayer){
    
    self.avPlayerLayer = layer;
    
    self.avPlayerLayer!.frame = self.bounds
    self.layer.addSublayer(self.avPlayerLayer!);
  }
  
  override public func didMoveToWindow() {
    super.didMoveToWindow()
    self.backgroundColor = .black
    self.avPlayerLayer?.frame = self.bounds;
  }
  
  override public func didMoveToSuperview() {
    super.didMoveToSuperview()
    self.backgroundColor = .black
    self.avPlayerLayer?.frame = self.bounds;
  }
  
//  override public func layoutSubviews() {
//    self.avPlayerLayer?.frame = self.bounds;
//  }
}
