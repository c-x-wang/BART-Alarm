//
//  Trip.swift
//  BART-Alarm
//
//  Created by Cindy Wang on 7/24/18.
//  Copyright © 2018 cxw. All rights reserved.
//

import UIKit

struct Trip {
    var route: String
    var routeNumber: String
    var startLocation: String
    var startLocationIndex: Int
    var endLocation: String
    var endLocationIndex: Int
    var tripLength: TimeInterval
    var alarmMinutes: Int // change to time file types?
    
    init() {
        self.route = "default"
        self.routeNumber = "default"
        self.startLocation = "default"
        self.startLocationIndex = -1
        self.endLocation = "default"
        self.endLocationIndex = -1
        self.tripLength = 0
        self.alarmMinutes = -1
    }
}
