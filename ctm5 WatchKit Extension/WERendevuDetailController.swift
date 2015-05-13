//
//  WERendevuDetailController.swift
//  ctm5
//
//  Created by Neil Weintraut on 5/11/15.
//  Copyright (c) 2015 Neil Weintraut. All rights reserved.
//

import Foundation
import WatchKit

class WEPrivateComment {
    var sourceComment: WEComment? = nil
    var targetId: String? = nil
    var targetName: String? = nil
    var text: String? = nil
    var havePrivateMessage: Bool = false
}
class WERendevuDetailController: WEBaseInterfaceController {

    @IBOutlet weak var loginGroup: WKInterfaceGroup!
    @IBOutlet weak var collectionTitle: WKInterfaceLabel!
    @IBOutlet weak var mapCommentButtonGropu: WKInterfaceGroup!
    @IBOutlet weak var networkLoadingGroup: WKInterfaceGroup!
    @IBOutlet weak var networkLoadingStatusLabel: WKInterfaceLabel!
    @IBOutlet weak var noItemsGroup: WKInterfaceGroup!
    @IBOutlet weak var itemsTable: WKInterfaceTable!
    @IBOutlet weak var commentAddedGroup: WKInterfaceGroup!

    @IBAction func requestAddedButtonTapped() {
        self.commentAddedGroup.setHidden(true)
        self.showCommentAddedGroup = false
    }
    var showCommentAddedGroup: Bool = false
    var privateComment: WEPrivateComment? = nil
    
    var collection: WERendevu = WERendevu(plist: [NSObject : AnyObject]())
    var incommingCollection: WERendevu = WERendevu(plist: [NSObject : AnyObject]())
    var collectionRequestPlist: [NSObject : AnyObject] {
        get {
            return self.populateRequestPlist(self.collection, requestType: WERequestType.RendevuWithComments)
        }
    }
    func addACommentRequestPlist(commentText: String?, commentType: WECommentType) -> [NSObject : AnyObject] {
        var rendevu: WERendevu = self.collection
        var rendevuPlist = rendevu.plist
        rendevuPlist["requestType"] = WERequestType.CreateComment.rawValue
        var commentPlist = [NSObject : AnyObject]()
        if let text = commentText { commentPlist["text"] = text }
        commentPlist["originatorId"] = manager.loggedInUserServerId
        if let username = manager.loggedInUserName {
            commentPlist["originatorName"] = username
        }
        commentPlist["commentType"] = commentType.rawValue
        var newItems = [ [NSObject : AnyObject] ]()
        newItems.append( commentPlist )
        rendevuPlist["items"] = newItems
        return rendevuPlist
    }
    func sendPrivateComment() {
        if let privateComment = self.privateComment {
            self.privateComment = nil
            var rendevu: WERendevu = self.collection
            var rendevuPlist = rendevu.plist
            rendevuPlist["requestType"] = WERequestType.CreateComment.rawValue
            var commentPlist = [NSObject : AnyObject]()
            if let text = privateComment.text {commentPlist["text"] = text}
            if let targetId = privateComment.targetId { commentPlist["targetId"] = targetId }
            if let targetName = privateComment.targetName { commentPlist["targetName"] = targetName}
            commentPlist["originatorId"] = manager.loggedInUserServerId

            if let username = manager.loggedInUserName { commentPlist["originatorName"] = username}
            commentPlist["commentType"] = WECommentType.privateComment.rawValue
            var newItems = [ [NSObject : AnyObject] ]()
            newItems.append( commentPlist )
            rendevuPlist["items"] = newItems
            println("What's up")
            self.showCommentAddedGroup = true
            reload(rendevuPlist)
        }
    }
    
    @IBAction func mapButtonPressed() {
        var rendevuPlist: [NSObject : AnyObject] = self.addACommentRequestPlist(nil, commentType: WECommentType.map)
        self.showCommentAddedGroup = true
        reload(rendevuPlist)
    }
    
    @IBAction func commentButtonPressed() {
        let suggestions = ["Hi!", "Funny"]
        self.presentTextInputControllerWithSuggestions(suggestions , allowedInputMode: WKTextInputMode.AllowEmoji) { (response: [AnyObject]!) -> Void in
            if response != nil && response.count > 0 {
                if let text = response[0] as? String {
                    var rendevuPlist: [NSObject : AnyObject] = self.addACommentRequestPlist(text, commentType: WECommentType.text)
                    self.showCommentAddedGroup = true
                    self.reload(rendevuPlist)
                }
            }
        }
    }
    
    @IBAction func refreshButtonPressed() {
        self.reset()
    }

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        self.controllerIdentifier = "RendevuDetailController"
        self.rowName = "CommentRow"
        self.commentAddedGroup.setHidden(true)
        self.privateComment = nil
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
            if let privateComment = self.privateComment {
                self.sendPrivateComment()
            }
        } else {
            self.privateComment = nil
            self.reload(self.collectionRequestPlist)
        }
    }
    override func didDeactivate() {
        super.didDeactivate()
        // self.privateComment = nil
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
            self.commentAddedGroup.setHidden(true)
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
    func reload(userInfo: [NSObject : AnyObject]) {
        if self.networkStatus == WENetworkStatus.Loading { return }
        self.hardReload(userInfo)
    }
    
    func reset() {
        self.checkLoginStatus()
        self.reload(self.collectionRequestPlist)
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
                    if self.showCommentAddedGroup {
                        self.commentAddedGroup.setHidden(false)
                        self.showCommentAddedGroup = false
                    }
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
    func addComment(commentText: String) {
        var rendevu: WERendevu = self.collection
        var rendevuPlist = rendevu.plist
        rendevuPlist["requestType"] = WERequestType.CreateComment.rawValue
        var commentPlist = [NSObject : AnyObject]()
        commentPlist["text"] = commentText
        commentPlist["originatorIdentifier"] = manager.loggedInUserServerId
    }
    func hardReload(userInfo: [NSObject : AnyObject]) {
        self.setAsLoading()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            //var userInfo: [NSObject : AnyObject] = self.populateRequestPlist(self.collection, requestType: WERequestType.RendevuWithComments)
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
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        if let items = self.collection.items as? [WEComment] {
            if rowIndex < items.count {
                let comment: WEComment = items[rowIndex]
                self.privateComment = WEPrivateComment()
                self.privateComment?.sourceComment = comment
                presentControllerWithName("PrivateMessageController", context: self.privateComment!)
            }
        }
    }
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


