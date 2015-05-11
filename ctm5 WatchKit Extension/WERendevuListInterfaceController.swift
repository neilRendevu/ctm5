//
//  WERendevuListInterfaceController.swift
//  ctm5
//
//  Created by Neil Weintraut on 5/11/15.
//  Copyright (c) 2015 Neil Weintraut. All rights reserved.
//

import Foundation
import WatchKit

class WERendevuListInterfaceController: WEBaseInterfaceController {
    
    @IBOutlet weak var loginGroup: WKInterfaceGroup!
    @IBOutlet weak var networkLoadingGroup: WKInterfaceGroup!
    @IBOutlet weak var networkLoadingStatusLabel: WKInterfaceLabel!
    @IBOutlet weak var listTable: WKInterfaceTable!
    @IBOutlet weak var refreshButton: WKInterfaceButton!
    @IBOutlet weak var noRendevusGroup: WKInterfaceGroup!
    
    @IBAction func refreshButtonPressed() {
        self.reset()
    }
    var collection: WERendevuCollection = WERendevuCollection(plist: [NSObject: AnyObject]())
    var incomingCollection: WERendevuCollection = WERendevuCollection(plist: [NSObject: AnyObject]())
//    var incomingItems: [WERendevu] = [WERendevu]()
    override func awakeWithContext(context: AnyObject?) {
        self.controllerIdentifier = "RendevuListController"
        self.rowName = "RendevuRow"
        super.awakeWithContext(context)
        if let rendevuCollection = context as? WERendevuCollection {
            self.collection = rendevuCollection
            self.incomingCollection = rendevuCollection
            self.setAsLoaded(true)
        } else {
            self.networkStatus = WENetworkStatus.NotLoaded
        }
    }
    override func willActivate() {
        super.willActivate()
        self.checkLoginStatus()
        println("activate")
        if self.networkStatus == WENetworkStatus.Loaded {
            println("populate")
            populateInterface()
        } else {
            println("reload")
            self.reload()
        }
    }
    
    func setAsLoaded(awake: Bool) {
        self.networkStatus = WENetworkStatus.Loaded
        if self.active || awake {
            self.networkLoadingGroup.setHidden(true)
            self.noRendevusGroup.setHidden(true)
        }
    }
    func setAsLoading() {
        self.networkStatus = WENetworkStatus.Loading
        if self.active {
            self.noRendevusGroup.setHidden(true)
            self.networkLoadingStatusLabel.setText("Loading")
            self.networkLoadingGroup.setHidden(false)
        }
    }
    func setAsFailed() {
        self.networkStatus = WENetworkStatus.Failed
        if self.active {
            self.noRendevusGroup.setHidden(true)
            self.networkLoadingStatusLabel.setText("No Access")
            self.networkLoadingGroup.setHidden(false)
        }
    }
    
    func checkLoginStatus() -> Bool {
        if manager.checkLoginStatus() != WELoginStatus.notLoggedIn {
            if self.active {
                self.loginGroup.setHidden(true)
            }
            return true
        } else {
            if self.active {
                self.loginGroup.setHidden(false)
            }
            return false
        }
    }
    func reload() {
        if self.networkStatus == WENetworkStatus.Loading { return }
        self.hardReload()
    }
    func hardReload() {
        self.setAsLoading()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            var userInfo = [NSObject : AnyObject]()
            userInfo["requestType"] = WERequestType.Rendevus.rawValue
            if self.active {
                WKInterfaceController.openParentApplication(userInfo, reply: { (plist: [NSObject : AnyObject]!, error: NSError!) -> Void in
                    if error == nil {
                        if plist != nil {
            
                                var newCollection = WERendevuCollection(plist: plist)
                                if self.networkStatus != WENetworkStatus.Loaded {
                                    self.incomingCollection = newCollection
                                    self.setAsLoaded(false)
                                    if self.active {
                                        self.populateInterface()
                                    }
                                }
                            
                        }
                    } else {
                        println(error)
                    }
                })
            } else {
                self.networkStatus = WENetworkStatus.NotLoaded
            }
        })
    }
    
    func reset() {
        self.checkLoginStatus()
        self.reload()
    }
    func populateInterface() {
        if self.networkStatus == WENetworkStatus.Loaded {
            var newCollection = self.incomingCollection
            if self.active {
                self.resizeTable(self.listTable, newSize: newCollection.items.count, rowTypeName: self.rowName!)
                if newCollection.items.count == 0 {
                    self.noRendevusGroup.setHidden(false)
                } else {
                    self.noRendevusGroup.setHidden(true)
                    for (index, item) in enumerate(newCollection.items) {
                        if self.active {
                            if let row = listTable.rowControllerAtIndex(index) as? WERendevuRow {
                                let imageToFetch: WEDerivedImage? = row.configure(item)
                                if imageToFetch != nil {
                                    println("Fetching Image \(imageToFetch)")
                                    self.fetchImage(imageToFetch!, callback: sequenceThroughRowTypes)
                                }
                            }
                        }
                    }
                }
                self.collection = newCollection
            }
        }
    }
}
// MARK: - Table Management
extension WERendevuListInterfaceController {
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        if rowIndex < self.collection.items.count {
            let rendevu = self.collection.items[rowIndex]
            pushControllerWithName("RendevuDetailController", context: rendevu)
        }
    }
    func sequenceThroughRowTypes(transferredImageName: String) -> Void {
        if self.active {
            for var index: Int = 0; index < self.listTable.numberOfRows; ++index {
                if let row = self.listTable.rowControllerAtIndex(index) as? WERendevuRow {
                    if let derivedImage: WEDerivedImage = row.derivedImage {
                        if derivedImage.derivedImageName == transferredImageName {
                            row.rowImage.setImageNamed(transferredImageName)
                        }
                    }
                }
            }
        }
    }
}
