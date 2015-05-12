//
//  WECommentRow.swift
//  ctm5
//
//  Created by Neil Weintraut on 5/11/15.
//  Copyright (c) 2015 Neil Weintraut. All rights reserved.
//

import Foundation
import WatchKit

class WECommentRow: WEBaseRow {
    @IBOutlet weak var originatorNameLabel: WKInterfaceLabel!
    @IBOutlet weak var createdAtLabel: WKInterfaceLabel!
    @IBOutlet weak var textLabel: WKInterfaceLabel!
    @IBOutlet weak var itemMap: WKInterfaceMap!
    @IBOutlet weak var itemImage: WKInterfaceImage!

    
    override init() {
        super.init()
        self.rowName = "CommentRow"
        self.imageWidth = 60.0
        self.imageHeight = 60.0
    }
    
    override func configure(model: WEBaseModel) -> WEDerivedImage? {
        if let comment = model as? WEComment {
            if let text = comment.text { self.textLabel.setText(text)}
            if let originatorName = comment.originatorName { self.originatorNameLabel.setText(originatorName)}
            if let createdAt = comment.createdAt {
                self.createdAtLabel.setText(comment.dateFormatter.stringFromDate(createdAt))
            }
            if (comment.latitude == 0.0) && (comment.longitude == 0.0) {
                self.itemMap.setHidden(true)
            } else {
                self.setUpMap(self.itemMap, comment: comment)
            }
            self.itemImage.setHidden(true)
            if let imageId = comment.imageId {
                self.derivedImage = WEDerivedImage(imageId: imageId, width: self.imageWidth, height: self.imageHeight)
                if let size = device.cachedImages[self.derivedImage!.derivedImageName] as? Int {
                    if size > 0 {
                        self.itemImage.setImageNamed(self.derivedImage!.derivedImageName)
                        self.itemImage.setHidden(false)
                        return nil
                    }
                }
                return self.derivedImage
            }
        }
        return nil
    }
    func setUpMap(map: WKInterfaceMap, comment: WEComment) {
        if let coordinate = comment.locationCoordinate() {
            if let region = comment.locationCoorindateRegion() {
                map.setRegion(region)
                map.addAnnotation(coordinate, withPinColor: WKInterfaceMapPinColor.Green)
            }
        }
    }
}
