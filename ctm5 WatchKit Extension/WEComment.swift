//
//  WEComment.swift
//  ctm5
//
//  Created by Neil Weintraut on 5/10/15.
//  Copyright (c) 2015 Neil Weintraut. All rights reserved.
//

import Foundation

class WEComment: WEBaseModel {
    var commentType: WECommentType?
    var commentTypeKey: String = "commentType"
    var recipientId: String? = nil
    
    override init(plist: [NSObject: AnyObject]) {
        super.init(plist: plist)
        self.strings = self.strings + ["recipientId"]
        self.className = "WEComments"
        self.dateFormat = "HH:mm"
        self.dateFormatter.dateFormat = dateFormat
        self.nested = false
        if let commentTypeRawValue = plist[self.commentTypeKey] as? String {
            if let commentType = WECommentType(rawValue: commentTypeRawValue){
                self.commentType = commentType
            }
        }
    }
    override func appendNestedItems(plist: [NSObject : AnyObject]) {
    
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

        plist[self.itemsKey] = itemsPlist
        if let commentType: WECommentType = self.commentType {
            plist[self.commentTypeKey] = commentType.rawValue
        }
        return plist
    }
}


enum WECommentType: String {
    case text =     "text"
    case privateComment =  "privateComment"
    case map =      "map"
    case image =    "image"
}