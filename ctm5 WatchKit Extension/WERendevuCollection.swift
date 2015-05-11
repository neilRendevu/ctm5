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
        // var plist: [NSObject : AnyObject] = super.plistDataOfInstance()
        var plist = [NSObject : AnyObject]()
        for key in strings {
            if let value = self.valueForKey(key) as? String { plist[key] = value }
        }
        for key in dates {
            if let value = self.valueForKey(key) as? NSDate { plist[key] = value }
        }
        for key in doubles {
            if let value = self.valueForKey(key) as? Double { plist[key] = value }
        }
        for key in integers {
            if let value = self.valueForKey(key) as? Int { plist[key] = value }
        }
        var itemsPlist = [ [NSObject : AnyObject] ]()
        println(self.items.count)
        if nested && self.items.count > 0 {
            if let items = self.items as? [WERendevu] {
                println("Made it here")
                for item in items {
                    itemsPlist.append(item.plist)
                }
            }
            plist[self.itemsKey] = itemsPlist
        }
        return plist
    }
}
