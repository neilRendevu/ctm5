//
//  SimulatedDataSource2.swift
//  ctm5
//
//  Created by Neil Weintraut on 5/12/15.
//  Copyright (c) 2015 Neil Weintraut. All rights reserved.
//

import UIKit

class SimulatedDataSource2: NSObject {
    var collections = [String: WERendevuCollection]()
    var users = ["Yashar", "Neil", "Umesh", "Beachy", "SuperBowl", "Namit", "Matthew", "Airplane", "Gigi", "Pennye"]
    var images = ["yashar.jpeg", "neil.jpeg", "umesh.jpeg", "beachparty.jpeg", "SuperBowl.png", "Namit.jpg", "Matthew.jpg", "airplane.jpeg", "Gigi.jpeg", "Pennye.jpg"]
    class var sharedInstance: SimulatedDataSource2 {
        struct Singleton {
            static let instance = SimulatedDataSource2()
        }
        return Singleton.instance
    }
    override init() {
        super.init()
        var collectionIdentifier = "Public Rendevus"
        self.collections[collectionIdentifier] = self.makeCollection(collectionIdentifier)
    }
    
    func makeCollection(collectionIdentifier: String) -> WERendevuCollection {
        var plist = collectionAttributes(collectionIdentifier)
        
        return WERendevuCollection(plist: plist)
    }
    func collectionAttributes(collectionIdentifier: String) -> [NSObject: AnyObject] {
        var plist = [NSObject : AnyObject]()
        plist["objectIdentifier"] = collectionIdentifier
        plist["originatorName"] = ("Name for \(collectionIdentifier) collection")
        plist["originatorId"] = "potentially some useful ID info"
        plist["text"] = "Description of \(collectionIdentifier) Collection"
        plist["title"] = "Title of \(collectionIdentifier)"
        plist["createdAt"] = NSDate()
        plist["lastUpdated"] = NSDate()
        plist["cursor"] = Int(0)
        plist["maxCount"] = Int(20)
        plist["location"] = "Cupertino"
        plist["latitude"] = Double(37.2)
        plist["longitude"] = Double(-122.1)
        plist["items"] = makeRendevus(plist["maxCount"] as! Int)
        return plist
    }
    func makeRendevus(count: Int) -> [[NSObject : AnyObject]] {
        var plist = [ [NSObject : AnyObject] ]()
        for var index = 0; index < count; ++index {
            var item = rendevuSeed()
            item["objectIdentifier"] = index
            let peopleIndex = index % users.count
            item["originatorName"] = self.users[peopleIndex]
            item["title"] = ("\(self.users[peopleIndex])'s Big Rendevu")
            item["text"] = ("\(self.users[peopleIndex])'s text")
            item["originatorId"] = self.users[peopleIndex]
            let pictureIndex = index % images.count
            item["imageId"] = self.images[pictureIndex]
            var count = item["maxCount"] as! Int
            item["items"] = makeComments(count)
            plist.append(item)
        }
        return plist
    }
    func rendevuSeed() -> [NSObject : AnyObject] {
        var seed = [NSObject : AnyObject]()
        seed["cursor"] = Int(0)
        seed["maxCount"] = Int(20)
        seed["createdAt"] = NSDate()
        seed["lastUpdated"] = NSDate()
        seed["location"] = "San Diego"
        seed["latitude"] = Double(33.0)
        seed["longitude"] = Double(-116.5)
        return seed
    }
    func makeComments(count: Int) -> [ [NSObject : AnyObject] ]{
        var plist = [ [NSObject : AnyObject] ]()
        for var index = 0; index < count; ++index {
            var item = commentSeed()
            item["objectIdentifier"] = index
            let peopleIndex = index % users.count
            item["originatorName"] = self.users[peopleIndex]
            item["title"] = ("\(self.users[peopleIndex])'s Important Comment")
            item["text"] = ("\(self.users[peopleIndex])'s funny comment")
            item["originatorId"] = self.users[peopleIndex]
            let pictureIndex = index % images.count
            item["imageId"] = self.images[pictureIndex]
            
            var latitude = item["latitude"] as! Double
            item["latitude"] = latitude - 0.1 * Double(index)
            var longitude = item["longitude"] as! Double
            item["longitude"] = longitude - 0.1 * Double(index)
            if (index == 0) || (index % 4 != 0) {
                item["latitude"] = 0
                item["longitude"] = 0
            }
            if index % 5 != 0 {
                item.removeValueForKey("imageId")
            }
            
            
            plist.append(item)
        }
        return plist
    }
    func commentSeed() -> [NSObject : AnyObject] {
        var seed = [NSObject : AnyObject]()
        seed["cursor"] = Int(0)
        seed["maxCount"] = Int(0)
        seed["createdAt"] = NSDate()
        seed["lastUpdated"] = NSDate()
        seed["location"] = "San Francisco"
        seed["latitude"] = Double(37.9)
        seed["longitude"] = Double(-121.9)
        return seed
    }
}
extension SimulatedDataSource2: WatchAPIProtocol {
    func retrieveRendevus(requestPlist: [NSObject : AnyObject]) -> [NSObject : AnyObject] {
        if let rendevuCollection = self.collections["Public Rendevus"] {
            var response = rendevuCollection.plist
            //response["items"] = [ [NSObject: AnyObject]]()
            return response
        }
        println("No collection found!")
        return [NSObject: AnyObject]()
    }
    func retrieveRendevuAndComments(requestPlist: [NSObject : AnyObject]) -> [NSObject : AnyObject] {
        if let rendevuCollection = self.collections["Public Rendevus"] {
            if let objectIdentifier = requestPlist["objectIdentifier"] as? Int {
                let items = rendevuCollection.items
                if items.count > objectIdentifier {
                    return items[objectIdentifier].plist
                }
            }
        }
        return [NSObject : AnyObject]()
    }
    func retrieveImage(imageId: String) -> UIImage? {
        return UIImage(named: imageId)
    }
}
