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
    override func appendNestedItems(plist: [NSObject: AnyObject]) {
        self.items = [WERendevu]()
        if let itemsPlist = plist[self.itemsKey] as? [ [NSObject: AnyObject]] {
            for plist in itemsPlist {
                self.items.append(WERendevu(plist: plist))
            }
        }
    }
    override func plistDataOfInstance() -> [NSObject : AnyObject] {
        var plist: [NSObject : AnyObject] = super.plistDataOfInstance()
        var itemsPlist = [ [NSObject : AnyObject] ]()
        if nested && self.items.count > 0 {
            if let items = self.items as? [WERendevu] {
                println("Made it here")
                for item in items {
                    itemsPlist.append(item.plist)
                }
            }
        }
        plist[self.itemsKey] = itemsPlist
        return plist
    }
}
