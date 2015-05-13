//
//  WatchAPIProtocol.swift
//  ctm5
//
//  Created by Neil Weintraut on 5/12/15.
//  Copyright (c) 2015 Neil Weintraut. All rights reserved.
//

import UIKit

protocol WatchAPIProtocol {
    func retrieveRendevus(requestPlist: [NSObject : AnyObject]) -> [NSObject : AnyObject]
    func retrieveRendevuAndComments(requestPlist: [NSObject : AnyObject]) -> [NSObject : AnyObject]
    func retrieveImage(imageId: String) -> UIImage?
    func addAComment(requestPlist: [NSObject: AnyObject]) -> Void
}
