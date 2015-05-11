//
//  WERendevu.swift
//  ctm5
//
//  Created by Neil Weintraut on 5/10/15.
//  Copyright (c) 2015 Neil Weintraut. All rights reserved.
//

import Foundation

class WERendevu: WEBaseModel {
    var privacyType: WERendevuPrivacyType? = nil
    let privacyTypeKey = "privacyType"

    var member: Bool? = nil
    
    override init(plist: [NSObject : AnyObject]) {
        super.init(plist: plist)
        self.className = "WERendevu"
        self.dateFormat = "HH:mm"
        self.dateFormatter.dateFormat = self.dateFormat
        self.nested = true
        if let privacyRawValue = plist[self.privacyTypeKey] as? String {
            if let privacyType: WERendevuPrivacyType = WERendevuPrivacyType(rawValue: privacyRawValue) {
                self.privacyType = privacyType
            }
        }
    }
    override func appendNestedItems() {
        self.items = [WEComment]()
        if let itemsPlist = plist[self.itemsKey] as? [ [NSObject : AnyObject]] {
            for itemPlist in itemsPlist {
                self.items.append(WEComment(plist: itemPlist) )
            }
        }
    }
    override func plistDataOfInstance() -> [NSObject : AnyObject] {
        var plist: [NSObject : AnyObject] = super.plistDataOfInstance()
        if let privacyType: WERendevuPrivacyType = self.privacyType {
            plist[self.privacyTypeKey] = privacyType.rawValue
        }
        return plist
    }
    override func toString() -> String {
        var string = super.toString()
        var rawValue = ""
        if let privacyType = self.privacyType {
            rawValue = privacyType.rawValue
        }
        string = string + "\(self.privacyTypeKey): \(rawValue)"
        return string
    }
}


enum WERendevuPrivacyType: String {
    case Public =   "Public"
    case Private =  "Private"
    case Secret =   "Secret"
    case Member = "Member"
    case Originator = "Originator"
}