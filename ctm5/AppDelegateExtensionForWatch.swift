//
//  AppDelegateExtensionForWatch.swift
//  ctm5
//
//  Created by Neil Weintraut on 5/10/15.
//  Copyright (c) 2015 Neil Weintraut. All rights reserved.
//

import UIKit

extension AppDelegate {
    func application(application: UIApplication, handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]?, reply: (([NSObject : AnyObject]!) -> Void)!) {
        if let plist: [NSObject : AnyObject] = userInfo {
            if let requestTypeString = plist["requestType"] as? String {
                if let requestType = WERequestType(rawValue: requestTypeString) {
                    switch requestType {
                    case .Rendevus:
                        WERequestHandler.sharedInstance.getRendevus(plist, reply: reply)
                    case .Rendevu:
                        WERequestHandler.sharedInstance.getRendevu(plist, reply: reply)
                    case .Comments:
                        WERequestHandler.sharedInstance.getComments(plist, reply: reply)
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
    class var sharedInstance: WERequestHandler {
        struct Singleton {
            static let instance = WERequestHandler()
        }
        return Singleton.instance
    }
    func getRendevus(plist: [NSObject: AnyObject], reply: ([NSObject : AnyObject]!) -> Void) -> Void {
        println("Need to implement getRendevus()")
    }
    func getRendevu(plist: [NSObject: AnyObject], reply: ([NSObject : AnyObject]!) -> Void) -> Void {
        println("Need to implement getRendevu()")
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
    func getImage(plist: [NSObject: AnyObject], reply: ([NSObject : AnyObject]!) -> Void) -> Void {
        println("Need to implement getImage()")
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
}