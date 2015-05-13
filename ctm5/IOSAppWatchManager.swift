//
//  IOSAppWatchManager.swift
//  ctm5
//
//  Created by Neil Weintraut on 5/10/15.
//  Copyright (c) 2015 Neil Weintraut. All rights reserved.
//

import UIKit
import AVFoundation

class IOSAppWatchManager: NSObject {
    var sharedStorageManager = WESharedStorageManager.sharedInstance
    
    class var sharedInstance: IOSAppWatchManager {
        struct Singleton {
            static let instance = IOSAppWatchManager()
        }
        return Singleton.instance
    }

    
    func logInOutUser(userServerObjectId: String?, loggedInUserName: String?) -> Void {
        if let sharedDefaults = NSUserDefaults(suiteName: self.sharedStorageManager.appGroup) {
            if userServerObjectId != nil {
                sharedDefaults.setObject(userServerObjectId!, forKey: self.sharedStorageManager.sharedDefaultsLoggedInUserKey)
                if loggedInUserName != nil {
                    sharedDefaults.setObject(loggedInUserName!, forKey: self.sharedStorageManager.sharedDefaultsLoggedInUserName)
                }
            } else {
                sharedDefaults.removeObjectForKey(self.sharedStorageManager.sharedDefaultsLoggedInUserKey)
                sharedDefaults.removeObjectForKey(self.sharedStorageManager.sharedDefaultsLoggedInUserName)
            }
            sharedDefaults.synchronize()
        } else {
            println("Did not get sharedDefaults in WatchManager")
        }
    }
    func transferSizedImage(image: UIImage, derivedImage: WEDerivedImage) -> String? {
        if let sizedImage = sizedUIImage(image, targetSize: derivedImage.size) {
            let fileManager = self.sharedStorageManager.fileManager
            if let sharedURL = self.sharedStorageManager.sharedStoreDirectoryURL {
                let data = UIImagePNGRepresentation(sizedImage)
                if data != nil {
                    if (data.length) > self.sharedStorageManager.maxWatchImageSize {
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
    func createImageName(imageId: String, size: CGSize) -> String {
        return "\(imageId)_\(size.width)x\(size.height)"
    }
    
}
