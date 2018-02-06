//
//  Locations.swift
//  LocationTrackingBackgroundiOS
//
//  Created by Chathura Hettiarachchi on 2/5/18.
//  Copyright © 2018 Chathura Hettiarachchi. All rights reserved.
//

import Foundation
import OLCOrm

@objc class Locations: OLCModel {
    
    @objc var Id: NSNumber?
    @objc var timeStamp: String?
    @objc var lat: String?
    @objc var lan: String?
    
    init(timeStamp: String, lat: String, lan: String) {
        super.init()
        
        self.timeStamp = timeStamp
        self.lat = lat
        self.lan = lan
    }
    
    override init() {
        super.init()
    }
}
