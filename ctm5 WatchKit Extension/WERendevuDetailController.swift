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
        
    }
    func hardReload() {
        
    }
}
