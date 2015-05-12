//
//  AppDelegateExtensionForWatch.swift
//  ctm5
//
//  Created by Neil Weintraut on 5/10/15.
//  Copyright (c) 2015 Neil Weintraut. All rights reserved.
//

import UIKit
import AVFoundation

extension AppDelegate {
    func application(application: UIApplication, handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]?, reply: (([NSObject : AnyObject]!) -> Void)!) {
        if let plist: [NSObject : AnyObject] = userInfo {
            if let requestTypeString = plist["requestType"] as? String {
                if let requestType = WERequestType(rawValue: requestTypeString) {
                    switch requestType {
                    case .Rendevus:
                        WERequestHandler.sharedInstance.getRendevus(plist, reply: reply)
                    case .RendevuWithComments:
                        WERequestHandler.sharedInstance.getRendevuWithComments(plist, reply: reply)
                    case .Users:
                        WERequestHandler.sharedInstance.getComment(plist, reply: reply)
                    case .Image:
                        WERequestHandler.sharedInstance.getImage(plist, reply: reply)
                    case .LoginId:
                        WERequestHandler.sharedInstance.getLoginId(plist, reply: reply)
                    case .CreateComment:
                        WERequestHandler.sharedInstance.createComment(plist, reply: reply)
                    case .CreateRendevu:
                        WERequestHandler.sharedInstance.createRendevu(plist, reply: reply)
                    }
                }
            }
        }
    }
}


class WERequestHandler {
    var collection: WatchAPIProtocol = SimulatedDataSource2.sharedInstance
    var storageManager = WESharedStorageManager.sharedInstance
    class var sharedInstance: WERequestHandler {
        struct Singleton {
            static let instance = WERequestHandler()
        }
        return Singleton.instance
    }
    init() {
        // self.collection.makeRendevuCollection()
    }
    func getRendevus(plist: [NSObject: AnyObject], reply: ([NSObject : AnyObject]!) -> Void) -> Void {
        reply(self.collection.retrieveRendevus(plist))
        // reply (self.collection.rendevuCollection!.plist )
    }
    func getRendevuWithComments(requestPlist: [NSObject: AnyObject], reply: ([NSObject : AnyObject]!) -> Void) -> Void {
        if let objectIdentifier = requestPlist["objectIdentifier"] as? String {
            reply(self.collection.retrieveRendevuAndComments(requestPlist))
        } else {
            reply([NSObject: AnyObject]())
        }
    }
    func getComments(plist: [NSObject: AnyObject], reply: ([NSObject : AnyObject]!) -> Void) -> Void {
        println("Need to implement getComments()")
    }
    func getComment(plist: [NSObject: AnyObject], reply: ([NSObject : AnyObject]!) -> Void) -> Void {
        println("Need to implement getComment()")
    }
    func getUsers(plist: [NSObject: AnyObject], reply: ([NSObject : AnyObject]!) -> Void) -> Void {
        println("Need to implement getUsers()")
    }
    func getImage(requestPlist: [NSObject: AnyObject], reply: ([NSObject : AnyObject]!) -> Void) -> Void {
        var plistResponse = [NSObject : AnyObject]()
        if let imageId = requestPlist["imageId"] as? String {
            if let width = requestPlist["width"] as? CGFloat {
                if let height = requestPlist["height"] as? CGFloat {
                    if let image = retrieveImage(imageId) {
                        let derivedImage = WEDerivedImage(imageId: imageId, width: width, height: height)
                        if let transferredImageName = self.transferSizedImage(image, derivedImage: derivedImage) {
                            plistResponse["derivedImageName"] = derivedImage.derivedImageName
                        } else {
                            println("\(derivedImage.derivedImageName) Transfer failed")
                        }
                        reply(plistResponse)
                        return
                    } else {
                        println("\(imageId) not found")
                    }
                }
            }
        }
        println("Failed to get an image")
        reply(plistResponse)
    }
    func getLoginId(plist: [NSObject: AnyObject], reply: ([NSObject : AnyObject]!) -> Void) -> Void {
        println("Need to implement getLoginId()")
    }
    func createComment(plist: [NSObject: AnyObject], reply: ([NSObject : AnyObject]!) -> Void) -> Void {
        println("Need to implement CreateComment()")
    }
    func createRendevu(plist: [NSObject: AnyObject], reply: ([NSObject : AnyObject]!) -> Void) -> Void {
        println("Need to implement CreateComment()")
    }

    
    func retrieveImage(imageId: String) -> UIImage? {
        return self.collection.retrieveImage(imageId)
//        return UIImage(named: imageId)
    }
    func transferSizedImage(image: UIImage, derivedImage: WEDerivedImage) -> String? {
        
        if let sizedImage = sizedUIImage(image, targetSize: derivedImage.size) {
            let fileManager = storageManager.fileManager
            if let sharedURL = storageManager.sharedStoreDirectoryURL {
                let data = UIImagePNGRepresentation(sizedImage)
                if data != nil {
                    if (data.length) > 200000 {
                        println("Warning, image: \(derivedImage.imageId), image Size of \(data.length). Too big; tossing")
                    } else {
                        let derivedImageName: String = derivedImage.derivedImageName
                        let url: NSURL = sharedURL.URLByAppendingPathComponent(derivedImageName)
                        var error: NSError? = nil
                        if data.writeToURL(url, options: NSDataWritingOptions.AtomicWrite, error: &error) {
                            if error == nil {
                                return derivedImageName
                            } else {
                                println(error)
                            }
                        }
                    }
                }
            }
        }
        return nil
    }
    func sizedUIImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        var targetRect: CGRect = CGRectMake(0, 0, targetSize.width, targetSize.height)
        let rect: CGRect = AVMakeRectWithAspectRatioInsideRect(image.size, targetRect)
        let size: CGSize = CGSizeMake(rect.width, rect.height) // Target size of the scaled images
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of the main screen
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        
        image.drawInRect(CGRect(origin: CGPointZero, size: size))
        var scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
    }
    
}