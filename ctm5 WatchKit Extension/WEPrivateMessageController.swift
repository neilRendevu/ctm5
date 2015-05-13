//
//  WEPrivateMessageController.swift
//  ctm5
//
//  Created by Neil Weintraut on 5/12/15.
//  Copyright (c) 2015 Neil Weintraut. All rights reserved.
//

import Foundation
import WatchKit

class WEPrivateMessageController: WEBaseInterfaceController {

    @IBOutlet weak var targetNameLabel: WKInterfaceLabel!
    var privateComment: WEPrivateComment? = nil
    @IBAction func messageButtonPressed() {
        if let privateComment = self.privateComment {
            if let sourceComment = privateComment.sourceComment {
                if let originatorId = sourceComment.originatorId {
                    if let originatorName = sourceComment.originatorName {
                        let suggestions = ["Hi!", "Funny"]
                        self.presentTextInputControllerWithSuggestions(suggestions , allowedInputMode: WKTextInputMode.AllowEmoji) { (response: [AnyObject]!) -> Void in
                            if response != nil && response.count > 0 {
                                if let text = response[0] as? String {
                                    var response = [NSObject : AnyObject]()
                                    privateComment.targetId = originatorId
                                    privateComment.targetName = originatorName
                                    privateComment.text = text
                                    println("Made it to here")
                                    self.dismissController()
                                }
                            }
                        }
                    }
                }
            }
        }

    }
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        self.controllerIdentifier = "PrivateMessageController"
        if let comment = context as? WEPrivateComment {
            self.privateComment = comment
        }
    }
    override func willActivate() {
        super.willActivate()
        if let privateComment = self.privateComment {
            if let sourceComment = privateComment.sourceComment {
                if let originatorId = sourceComment.originatorId {
                    if let originatorName = sourceComment.originatorName {
                        self.targetNameLabel.setText(originatorName)
                    }
                    return
                }
            }
        }
        dismissController()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        self.privateComment = nil
    }
}
