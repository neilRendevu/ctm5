//
//  WEDerivedImage.swift
//  ctm5
//
//  Created by Neil Weintraut on 5/10/15.
//  Copyright (c) 2015 Neil Weintraut. All rights reserved.
//

import UIKit
import AVFoundation
import WatchKit

class WEDerivedImage: NSObject {
    var imageId: String
    var width: CGFloat
    var height: CGFloat
    var derivedImageName: String {
        return WEDerivedImage.derivedImageName(imageId, size: size)
    }
    var size: CGSize {
        get {
            return CGSize(width: width, height: height)
        }
    }
    
    init(imageId: String, width: CGFloat, height: CGFloat) {
        self.imageId = imageId
        self.width = width
        self.height = height
    }
    class func derivedImageName(imageId: String, size: CGSize) -> String {
        return "\(imageId)_\(Int(size.width))x\(Int(size.height))"
    }
    func sizedUIImage(image: UIImage) -> UIImage? {
        var targetRect: CGRect = CGRectMake(0, 0, self.width, self.height)
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
    
    class func createImstance(plist: [NSObject : AnyObject]) -> WEDerivedImage? {
        var derivedImage: WEDerivedImage? = nil
        if let imageId = plist["imageId"] as? String {
            if let width = plist["width"] as? CGFloat {
                if let height = plist["height"] as? CGFloat {
                    derivedImage = WEDerivedImage(imageId: imageId, width: width, height: height)
                }
            }
        }
        return derivedImage
    }
    var plist: [NSObject: AnyObject]! {
        var plist = [NSObject: AnyObject]()
        plist["imageId"] = self.imageId
        plist["width"] = self.width
        plist["height"] = self.height
        plist["derivedImageName"] = self.derivedImageName
        return plist
    }
    func toString() -> String {
        var string: String = "WEDerivedInage: "
        string += "imageId: \(imageId), derivedName: \(derivedImageName), width: \(width), height: \(height), size: \(size)"
        return string
    }
}
