//
//  WEBaseModel.swift
//  ctm5
//
//  Created by Neil Weintraut on 5/10/15.
//  Copyright (c) 2015 Neil Weintraut. All rights reserved.
//

import UIKit

class WEBaseModel: NSObject {
    var className: String = "WEBaseModel"
    
    var objectIdentifier: String? = nil
    var originatorId: String? = nil
    var originatorName: String? = nil
    var text: String? = nil
    var title: String? = nil
    var imageId: String? = nil
    var derivedImageName: String? = nil
    var createdAt: NSDate? = nil
    var lastUpdated: NSDate? = nil
    
    var cursor: Int = 0
    var maxCount: Int = 20
    
    var location: String? = nil
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    let dateFormatter = NSDateFormatter()
    var dateFormat: String = "HH:mm"
    
    var strings = ["objectIdentifier", "title", "originatorId", "originatorName", "text", "imageId", "location"]
    var dates = ["createdAt", "lastUpdated"]
    var doubles = ["latitude", "longitude"]
    var integers = ["cursor", "maxCount"]
    var itemsKey: String = "items"
    
    var items: [WEBaseModel] = [WEBaseModel]()
    var incomingItems: [WEBaseModel] = [WEBaseModel]()
    
    var users: [WEUser] = [WEUser]()
    var nested: Bool = true
    
    var plist: [NSObject : AnyObject] {
        get {
            return plistDataOfInstance()
        }
    }
    
    init(plist: [NSObject : AnyObject]) {
        super.init()
        self.dateFormatter.dateFormat = self.dateFormat
        for key in strings {
            if let value = plist[key] as? String { self.setValue(value, forKey: key) }
        }
        for key in dates {
            if let value = plist[key] as? NSDate { self.setValue(value, forKey: key) }
        }
        for key in doubles {
            if let value = plist[key] as? Double { self.setValue(value, forKey: key) }
        }
        for key in integers {
            if let value = plist[key] as? Int { self.setValue(value, forKey: key) }
        }
        self.appendNestedItems(plist)
    }
    func appendNestedItems(plist: [NSObject: AnyObject]){
        // Override this
        println("appendNestedItems() probably needs to be overridden in \(self.className)")
        self.items = [WEBaseModel]()
        if let itemsPlist = plist[self.itemsKey] as? [ [NSObject : AnyObject] ] {
            for itemPlist in itemsPlist {
                self.items.append(WEBaseModel(plist: itemPlist) )
            }
        }
    }
    func plistDataOfInstance() -> [NSObject : AnyObject] {
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
        if nested && self.items.count > 0 {
            for item in items {
                itemsPlist.append(item.plist)
            }
        }
        plist[self.itemsKey] = itemsPlist
        return plist
    }
    func toString() -> String {
        var string = "\(self.className): "
        for key in strings {
            var value = self.valueForKey(key) as? String ?? ""
            string = "\(string), \(key): \(value)  "
        }
        string = "\(string)\n"
        for key in dates {
            var value: String = ""
            if let date = self.valueForKey(key) as? NSDate { value = self.dateFormatter.stringFromDate(date) }
            string = "\(string), \(key): \(value) "
        }
        string = "\(string)\n"
        for key in doubles {
            let value = self.valueForKey(key) as? Double ?? 0.0
            string = "\(string), \(key): \(value) "
        }
        return string
    }
}
