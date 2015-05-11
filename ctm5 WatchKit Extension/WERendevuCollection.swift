//
//  WERendevuCollection.swift
//  ctm5
//
//  Created by Neil Weintraut on 5/10/15.
//  Copyright (c) 2015 Neil Weintraut. All rights reserved.
//

import Foundation

class WERendevuCollection: WEBaseModel {
    
    override init(plist: [NSObject : AnyObject]) {
        super.init(plist: plist)
        self.className = "WERendevuCollection"
        self.className = "WERendevu"
        self.dateFormat = "HH:mm"
        self.dateFormatter.dateFormat = self.dateFormat
        self.nested = true
    }
    override func appendNestedItems() {
        self.items = [WERendevu]()
        if let itemsPlist = plist[self.itemsKey] as? [ [NSObject : AnyObject]] {
            for itemPlist in itemsPlist {
                self.items.append(WERendevu(plist: itemPlist) )
            }
        }
    }
}
