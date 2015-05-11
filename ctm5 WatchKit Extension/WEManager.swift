//
//  WEManager.swift
//  ctm5
//
//  Created by Neil Weintraut on 5/11/15.
//  Copyright (c) 2015 Neil Weintraut. All rights reserved.
//

import Foundation
import WatchKit

class WEManager: NSObject {
    let storageManager = WESharedStorageManager.sharedInstance
    let device = WKInterfaceDevice.currentDevice()
    var loggedInUserServerId: String? = nil
    var priorLoggedInUserKey: String = "PriofLoggedInUserKey"
    var resetCacheKey: String = "ResetCache"
  
    class var sharedInstance: WEManager {
        struct Singleton {
            static let instance = WEManager()
        }
        return Singleton.instance
    }

    func setCacheToBeReset() {
        println("Cache set to be reset")
        if let sharedDefaults = NSUserDefaults(suiteName: self.storageManager.appGroup) {
            sharedDefaults.setObject(true, forKey: self.resetCacheKey)
            sharedDefaults.synchronize()
        }
    }
    func checkCache() {
        if let sharedDefaults =  NSUserDefaults(suiteName: self.storageManager.appGroup) {
            if let resetCache = sharedDefaults.objectForKey(resetCacheKey) as? Bool {
                if resetCache {
                    WKInterfaceDevice.currentDevice().removeAllCachedImages()
                    sharedDefaults.setObject(false, forKey: self.resetCacheKey)
                    sharedDefaults.synchronize()
                }
            }
        }
    }
    func getImageFromSharedStorage(derivedImageName: String) -> UIImage? {
        if let url: NSURL = storageManager.sharedStoreDirectoryURL {
            let fileURL: NSURL = url.URLByAppendingPathComponent(derivedImageName)
            if let path: String = fileURL.path {
                if storageManager.fileManager.fileExistsAtPath(path) {
                    if let image: UIImage = UIImage(contentsOfFile: path) {
                        return image
                    } else {
                        println("no image: \(path)")
                    }
                } else {
                    println("File does not exist: \(path)")
                }
            }
        }
        return nil
    }
    func removeImageFromSharedStorage(derivedImageName: String) -> Void {
        if let url: NSURL = storageManager.sharedStoreDirectoryURL {
            let fileURL: NSURL = url.URLByAppendingPathComponent(derivedImageName)
            if let urlString: String = fileURL.absoluteString {
                var error: NSError? = nil
                self.storageManager.fileManager.removeItemAtPath(urlString, error: &error)
                if error != nil {println(error)}
            }
        }
    }

}
extension WEManager {
    func checkLoginStatus() -> WELoginStatus {
        if let sharedDefaults = NSUserDefaults(suiteName: self.storageManager.appGroup) {
            if let loggedInUserServerId = sharedDefaults.objectForKey(storageManager.sharedDefaultsLoggedInUserKey) as? String {
                self.loggedInUserServerId = loggedInUserServerId
                if let priorLoggedInUser = sharedDefaults.objectForKey(self.priorLoggedInUserKey) as? String {
                    self.priorLoggedInUserKey = priorLoggedInUser
                    if priorLoggedInUser == loggedInUserServerId {
                        println("Logged in; same as prior user")
                        // in this, can save/use existing info; not implemented yet. Neil
                        return WELoginStatus.sameLogIn
                    } else {
                        println("Logged in; not the same as prior user")
                        return WELoginStatus.newLogIn
                    }
                }
            } else {
                println("Not logged in")
            }
        } else {
            println("Did not get sharedDefaults in WEManager")
        }
        return WELoginStatus.notLoggedIn
    }
}
enum WELoginStatus {
    case notLoggedIn
    case newLogIn
    case sameLogIn
}