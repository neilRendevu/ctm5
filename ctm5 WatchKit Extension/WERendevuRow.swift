//
//  WERendevuRo.swift
//  ctm5
//
//  Created by Neil Weintraut on 5/11/15.
//  Copyright (c) 2015 Neil Weintraut. All rights reserved.
//

import Foundation
import WatchKit

class WERendevuRow: WEBaseRow {

    @IBOutlet weak var originatorNameLabel: WKInterfaceLabel!
    @IBOutlet weak var rowImage: WKInterfaceImage!
    @IBOutlet weak var rowTitle: WKInterfaceLabel!
    @IBOutlet weak var locationLabel: WKInterfaceLabel!
    var device = WKInterfaceDevice.currentDevice()
    
    
    override init() {
        super.init()
        self.rowName = "RendevuRow"
        self.imageHeight = 30.0
        self.imageWidth = 30.0
        
    }
    
    override func configure(rendevu: WEBaseModel) -> WEDerivedImage? {
        if let rendevu = rendevu as? WERendevu {
            if let originator: String = rendevu.originatorName { self.originatorNameLabel.setText(originator)}
            if let title: String = rendevu.title {self.rowTitle.setText(title)}
            if let location:String = rendevu.location {self.locationLabel.setText(location)}
            if let imageId: String = rendevu.imageId {
                self.derivedImage = WEDerivedImage(imageId: imageId, width: self.imageWidth, height: self.imageHeight)
                if let size = device.cachedImages[self.derivedImage!.derivedImageName] as? Int {
                    if size > 0 {
                        self.rowImage.setImageNamed(self.derivedImage!.derivedImageName)
                        return nil
                    }
                }
                return self.derivedImage
            }
        }
        return nil
    }
}
