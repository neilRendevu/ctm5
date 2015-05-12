//
//  WERendevuDetailController.swift
//  ctm5
//
//  Created by Neil Weintraut on 5/11/15.
//  Copyright (c) 2015 Neil Weintraut. All rights reserved.
//

import Foundation
import WatchKit

class WERendevuDetailController: WEBaseInterfaceController {

    @IBOutlet weak var loginGroup: WKInterfaceGroup!
    @IBOutlet weak var collectionTitle: WKInterfaceLabel!
    @IBOutlet weak var mapCommentButtonGropu: WKInterfaceGroup!
    @IBOutlet weak var networkLoadingGroup: WKInterfaceGroup!
    @IBOutlet weak var networkLoadingStatusLabel: WKInterfaceLabel!
    @IBOutlet weak var noItemsGroup: WKInterfaceGroup!
    @IBOutlet weak var itemsTable: WKInterfaceTable!
    
    var collection: WERendevu = WERendevu(plist: [NSObject : AnyObject]())
    var incommingCollection: WERendevu = WERendevu(plist: [NSObject : AnyObject]())
    
    @IBAction func mapButtonPressed() {
    }
    
    @IBAction func commentButtonPressed() {
    }
    
    @IBAction func refreshButtonPressed() {
        self.reset()
    }

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        self.controllerIdentifier = "RendevuDetailController"
        self.rowName = "CommentRow"
        if let rendevu = context as? WERendevu {
            self.collection = rendevu
            self.incommingCollection = rendevu
            self.setAsLoaded(true)
        } else {
            self.networkStatus = WENetworkStatus.NotLoaded
        }
        
    }
    override func willActivate() {
        super.willActivate()
        self.checkLoginStatus()
        if self.networkStatus == WENetworkStatus.Loaded {
            populateInterface()
        } else {
            self.reload()
        }
        
    }
    func setAsLoaded(awake: Bool) {
        self.networkStatus = WENetworkStatus.Loaded
        if self.active || awake {
            self.noItemsGroup.setHidden(true)
            self.networkLoadingGroup.setHidden(true)
        }
    }
    func setAsLoading() {
        self.networkStatus = WENetworkStatus.Loading
        if self.active {
            self.noItemsGroup.setHidden(true)
            //self.collectionTitle.setHidden(true)
            self.networkLoadingStatusLabel.setText("Loading")
            self.networkLoadingGroup.setHidden(false)
        }
    }
    func setAsFailed() {
        self.networkStatus = WENetworkStatus.Failed
        if self.active {
            self.noItemsGroup.setHidden(true)
            self.networkLoadingStatusLabel.setText("No Access")
            self.networkLoadingGroup.setHidden(false)
            self.collectionTitle.setHidden(true)
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
    
    func reset() {
        self.checkLoginStatus()
        self.reload()
    }
    
    func populateInterface() {
        if self.networkStatus == WENetworkStatus.Loaded {
            var newCollection = self.incommingCollection
            if self.active {
                self.setTitle("Rendevus")
                self.resizeTable(self.itemsTable, newSize: newCollection.items.count, rowTypeName: self.rowName!)
                
                self.collection = newCollection
                if let collectionName = newCollection.title {
                    self.collectionTitle.setText(collectionName)
                } else {
                    self.collectionTitle.setText("Oops. No Title")
                }
                if newCollection.items.count == 0 {
                    self.noItemsGroup.setHidden(false)
                } else {
                    self.noItemsGroup.setHidden(true)
                    for (index, item) in enumerate(newCollection.items) {
                        if self.active {
                            if let row = itemsTable.rowControllerAtIndex(index) as? WECommentRow {
                                let imageToFetch: WEDerivedImage? = row.configure(item)
                                if imageToFetch != nil {
                                    println("Fetching Image \(imageToFetch)")
                                    self.fetchImage(imageToFetch!, callback: sequenceThroughRowTypes)
                                }
                            } else {
                                println("No row found")
                            }
                        }
                    }
                }
            }
        }
    }

    func hardReload() {
        self.setAsLoading()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            var userInfo: [NSObject : AnyObject] = self.populateRequestPlist(self.collection, requestType: WERequestType.RendevuWithComments)
            if self.active {
                WKInterfaceController.openParentApplication(userInfo , reply: { (plist: [NSObject: AnyObject]!, error: NSError!) -> Void in
                    if self.active {
                        if error == nil {
                            if plist != nil {
                                var newCollection = WERendevu(plist: plist)
                                if self.networkStatus != WENetworkStatus.Loaded {
                                    self.incommingCollection = newCollection
                                    self.setAsLoaded(false)
                                    if self.active {
                                        self.populateInterface()
                                        return
                                    }
                                } else {
                                    return
                                }
                            }
                        } else {
                            println("Error in openParent response: \(error)")
                        }
                    }
                    if self.networkStatus != WENetworkStatus.Loaded {
                        self.networkStatus = WENetworkStatus.NotLoaded
                    }
                })
            } else {
                if self.networkStatus != WENetworkStatus.Loaded
                {
                    self.networkStatus = WENetworkStatus.NotLoaded
                }
            }
        })
    }
}
// MARK: - TABLE MANAGEMENT
extension WERendevuDetailController {
    func sequenceThroughRowTypes(transferredImageName: String) -> Void {
        if self.active {
            for var index: Int = 0; index < self.itemsTable.numberOfRows; ++index {
                if let row = self.itemsTable.rowControllerAtIndex(index) as? WECommentRow {
                    if let derivedImage: WEDerivedImage = row.derivedImage {
                        if derivedImage.derivedImageName == transferredImageName {
                            row.itemImage.setImageNamed(transferredImageName)
                        }
                    }
                }
            }
        }
    }
}

