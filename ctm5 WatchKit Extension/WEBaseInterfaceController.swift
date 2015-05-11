//
//  WEBaseInterfaceController.swift
//  ctm5
//
//  Created by Neil Weintraut on 5/11/15.
//  Copyright (c) 2015 Neil Weintraut. All rights reserved.
//

import Foundation
import WatchKit

class WEBaseInterfaceController: WKInterfaceController {
    let manager = WEManager.sharedInstance
    var device = WKInterfaceDevice.currentDevice()
    var controllerIdentifier: String? = nil
    var rowName: String? = nil
    var active: Bool = false
    var networkStatus: WENetworkStatus = WENetworkStatus.NotLoaded
    
    override func willActivate() {
        super.willActivate()
        self.active = true
    }
    override func didDeactivate() {
        self.active = false
        super.didDeactivate()
    }
    func resizeTable(table: WKInterfaceTable,  newSize: Int, rowTypeName: String) -> Void {
        var presentTableSize = table.numberOfRows
        if presentTableSize == newSize { return }
        if presentTableSize == 0 {
            table.setNumberOfRows(newSize, withRowType: rowTypeName)
        } else if presentTableSize < newSize {
            let indexSet: NSIndexSet = NSIndexSet(indexesInRange: NSMakeRange(0, newSize - presentTableSize))
            table.insertRowsAtIndexes(indexSet, withRowType: rowTypeName)
        } else {
            let indexSet: NSIndexSet = NSIndexSet(indexesInRange: NSMakeRange(newSize, presentTableSize - newSize))
            table.removeRowsAtIndexes(indexSet)
        }
    }
    
    func fetchImage(imageToFetch: WEDerivedImage, callback: (transferredImageName: String) -> Void ) -> Void {
        var userInfo = imageToFetch.plist
        userInfo["requestType"] = WERequestType.Image.rawValue
        if self.active {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                WKInterfaceController.openParentApplication(userInfo , reply: { (plist: [NSObject : AnyObject]!, error: NSError!) -> Void in
                    if error == nil {
                        if let transferredImageName = plist["derivedImageName"] as? String {
                            if let image: UIImage = self.manager.getImageFromSharedStorage(transferredImageName) {
                                if !self.device.addCachedImage(image , name: transferredImageName) {
                                    self.manager.setCacheToBeReset()
                                } else {
                                    callback(transferredImageName: transferredImageName)
                                }
                            } else {
                                println("Failed to get image \(transferredImageName)")
                            }
                        }
                    } else {
                        println(error.localizedDescription)
                    }
                })
            })
        }
    }
}

enum WENetworkStatus {
    case Loading
    case Failed
    case Loaded
    case NotLoaded
}