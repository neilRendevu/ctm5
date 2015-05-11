//
//  WEBaseRow.swift
//  ctm5
//
//  Created by Neil Weintraut on 5/11/15.
//  Copyright (c) 2015 Neil Weintraut. All rights reserved.
//

import Foundation
import WatchKit

class WEBaseRow: WKInterfaceController {
    var derivedImage: WEDerivedImage? = nil
    @IBOutlet weak var image: WKInterfaceImage!
    
    func configure(WEBaseModel) -> WEDerivedImage? {
        println("Need to implement .configure() in Row Controller")
        return nil
    }
}
