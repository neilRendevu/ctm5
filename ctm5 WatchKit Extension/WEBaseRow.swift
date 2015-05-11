//
//  WEBaseRow.swift
//  ctm5
//
//  Created by Neil Weintraut on 5/11/15.
//  Copyright (c) 2015 Neil Weintraut. All rights reserved.
//

import Foundation
import WatchKit

class WEBaseRow: NSObject {
    var derivedImage: WEDerivedImage? = nil
    var rowName: String = "BaseRow"
    var imageHeight: CGFloat = 60.0
    var imageWidth: CGFloat = 60.0
    @IBOutlet weak var image: WKInterfaceImage!
    
    
    func configure(WEBaseModel) -> WEDerivedImage? {
        println("Need to implement .configure() in Row Controller")
        return nil
    }
}
