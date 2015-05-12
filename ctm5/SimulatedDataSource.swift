//
//  SimulatedDataSource.swift
//  ctm5
//
//  Created by Neil Weintraut on 5/10/15.
//  Copyright (c) 2015 Neil Weintraut. All rights reserved.
//

import Foundation

class SimulatedDataSource: NSObject {
    var rendevus: [WERendevu] = [WERendevu]()
    var rendevuCollection: WERendevuCollection? = nil
    override init() {
        super.init()
        //makeEm()
    }
    class var sharedInstance: SimulatedDataSource {
        struct Singleton {
            static let instance = SimulatedDataSource()
        }
        return Singleton.instance
    }
    var images = ["yashar.jpeg", "neil.jpeg", "umesh.jpeg", "beachparty.jpeg", "SuperBowl.png", "Namit.jpg", "Matthew.jpg", "airplane.jpeg", "Gigi.jpeg", "Pennye.jpg"]
    func makeRendevuCollection() -> WERendevuCollection {
        var plist = [NSObject : AnyObject]()
        plist["objectIdentifier"] = "Collection_Identifier_1"
        plist["text"] = "Description of Rendevu Demonstration Collection"
        plist["originatorId"] = "potentially some useful ID info"
        plist["originatorName"] = "Public Rendevus"
        plist["title"] = "Rendevu Demonstration Collection"
        plist["createdAt"] = NSDate()
        plist["lastUpdated"] = NSDate()
        plist["cursor"] = 0
        plist["maxCount"] = 20
        plist["location"] = "San Francisco"
        plist["latitude"] = Double(37.9)
        plist["longitude"] = Double(-121.9)
    
        
        
        var seed = [NSObject : AnyObject]()
        seed["objectIdentifier"] = "Rendevu_"
        seed["title"] = "Rendevu_Title_"
        seed["originatorId"] = "yasharsID"
        seed["originatorName"] = "Yashar"
        seed["text"] = "This is a fun rendevu"
        seed["cursor"] = Int(0)
        seed["maxCount"] = Int(20)
        seed["createdAt"] = NSDate()
        seed["lastUpdated"] = NSDate()
        seed["location"] = "San Diego"
        seed["latitude"] = Double(33.0)
        seed["longitude"] = Double(-116.5)
        seed["imageId"] = "yashar.jpeg"
        plist["items"] = createRendevus2(seed)

        var r = plist["items"] as! [ [NSObject : AnyObject] ]
        // println(r)
        return WERendevuCollection(plist: plist)
    }
    
    func createRendevus2(plist: [NSObject: AnyObject]) -> [ [ NSObject : AnyObject ] ]{
        var rendevus = [ [ NSObject : AnyObject ] ]()
        for var index = 0; index < 20; ++index {
            var item = [NSObject : AnyObject]()
            item = plist
            let pictureIndex = index % images.count
            item["imageId"] = self.images[pictureIndex]
            item["items"] = createComments2()
            rendevus.append(item)
        }
        return rendevus
    }
    
    func createComments2() -> [ [NSObject: AnyObject]] {
        var seed = [NSObject : AnyObject]()
        seed["objectIdentifier"] = "Comment_"
        seed["title"] = "Comment_Title_"
        seed["originatorId"] = "yasharsID"
        seed["originatorName"] = "Yashar"
        seed["text"] = "Comment text"
        seed["cursor"] = Int(0)
        seed["maxCount"] = Int(20)
        seed["createdAt"] = NSDate()
        seed["lastUpdated"] = NSDate()
        seed["location"] = "San Diego"
        seed["latitude"] = Double(33.0)
        seed["longitude"] = Double(-116.5)
        var comments = [ [NSObject: AnyObject]]()
        for var index = 0; index < 20; ++index {
            var item = [NSObject : AnyObject]()
            item = seed
            comments.append(item)
        }
        return comments
    }
    
    
    func makeEm() -> SimulatedDataSource {
        var dictionary = [NSObject : AnyObject]()
        dictionary["title"] = "Party"
        dictionary["serverObjectId"] = "0"
        dictionary["location"] = "Taj Mahal"
        dictionary["latitude"] = Double(37.1)
        dictionary["longitude"] = Double(-121.1)
        dictionary["imageId"] = "someId"
        dictionary["originatorId"] = "someId"
        dictionary["originatorName"] = "Yashar"
        dictionary["privacyType"] = WERendevuPrivacyType.Public.rawValue
        createRendevus(dictionary)
        return self
    }
    
    var testImagesNames = ["beachparty.jpeg", "umesh.jpeg", "yashar.jpeg", "neil.jpeg"]
    func createRendevus(dictionary: [NSObject : AnyObject]) -> Void {
        
        var actual = [NSObject : AnyObject]()
        var mod = testImagesNames.count
        for var i = 0; i<20; ++i {
            actual["createdAt"] = NSDate()
            var title = dictionary["title"] as! String
            actual["title"] = "\(i)_\(title)"
            
            var id = dictionary["serverObjectId"] as! String
            actual["serverObjectId"] = "\(i)"
            
            var location = dictionary["location"] as! String
            actual["location"] = "\(i)_\(location)"
            
            var latitude = dictionary["latitude"] as! Double
            actual["latitude"] = latitude + 0.1 * Double(i)
            
            var longitude = dictionary["longitude"] as! Double
            actual["longitude"] = longitude + 0.1 * Double(i)
            
            actual["privacyType"] = dictionary["privacyType"]
            
            var imageId = dictionary["imageId"] as! String
            actual["imageId"] = "\(i)_\(imageId)"
            actual["imageId"] = testImagesNames[i % mod]
            
            actual["originatorId"] = dictionary["originatorId"]
            actual["originatorName"] = dictionary["originatorName"]
            
            
            actual["lastUpdated"] = NSDate()
            let rendevu = WERendevu(plist: actual)
            rendevu.items = self.createComments(i, count: 18)
            rendevus.append(rendevu)
            
        }
    }
    func createComments(index: Int, count: Int) -> [WEComment] {
        var response = [WEComment]()
        let seed = NSMutableDictionary()
        
        seed["serverObjectId"] = "0"
        seed["commentText"] = " \(index) Said Something that was this long"
        seed["commenterName"] =  "\(index) Goober"
        seed["commenterId"] = " \(index) A1"
        seed["createdAt"] = NSDate()
        seed["commentType"] = WECommentType.text.rawValue
        seed["imageId"] = "\(index)_imageId"
        seed["location"] = "\(index) San Diego"
        seed["latitude"] = Double(33.0)
        seed["longitude"] = Double(-116.5)
        for var i = 0; i < count ; ++i {
            var data = [NSObject : AnyObject]()
            var comment = seed["commentText"] as! String
            data["commentText"] = "\(i) \(comment)"
            
            var serverObjectId = seed["serverObjectId"] as! String
            data["serverObjectId"] = "\(i)"
            
            var commenterName = seed["commenterName"] as! String
            data["commenterName"] = "\(i) \(commenterName)"
            
            var commenterId = seed["commenterId"] as! String
            data["commenterId"] = "\(i) \(commenterId)"
            
            var time = seed["createdAt"] as! NSDate
            data["createdAt"] = time
            
            if (i != 0) && (i % 5 == 0) {
                var imageId = seed["imageId"] as! String
                data["imageId"] = "\(i)_\(imageId)"
            }
            
            var location = seed["location"] as! String
            data["location"] = "\(i) \(location)"
            
            data["lastUpdated"] = NSDate()
            data["recipientId"] = "SomeGoober"
            
            var latitude = seed["latitude"] as! Double
            data["latitude"] = latitude - 0.1 * Double(i)
            var longitude = seed["longitude"] as! Double
            data["longitude"] = longitude - 0.1 * Double(i)
            if (i == 0) || (i % 4 != 0) {
                data["latitude"] = 0
                data["longitude"] = 0
            }
            
            /*
            var type = seed["commentType"] as! String
            data["type"] = type
            if i  % 4 == 0 {
            data["commentType"] = WECommentType.map.rawValue
            }
            if i % 5 == 1 {
            data["commentType"] = WECommentType.image.rawValue
            }
            */
            
            let newComment = WEComment(plist: data)
            response.append(newComment)
        }
        return response
    }
    
}