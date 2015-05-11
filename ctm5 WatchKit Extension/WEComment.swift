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
    override func plistDataOfInstance() -> [NSObject : AnyObject] {
        var plist: [NSObject : AnyObject] = super.plist
        if let commentType: WECommentType = self.commentType {
            plist[self.commentTypeKey] = commentType.rawValue
        }
        return plist
    }
}


enum WECommentType: String {
    case text =     "text"
    case map =      "map"
    case image =    "image"
}