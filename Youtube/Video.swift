//
//  Video.swift
//  Youtube
//
//  Created by Che Blankenship on 7/8/17.
//  Copyright © 2017 Che Blankenship. All rights reserved.
//

import UIKit


class Video: NSObject {
    
    var thumbnailImageName: String?
    var title: String?
    var date: NSDate?
    var numberOfViews: NSNumber?
    // Channel class をVideo class の子クラスにする
    var channel: Channel?
}


class Channel: NSObject {

    var name : String?
    var profileImageName: String?
    
}
