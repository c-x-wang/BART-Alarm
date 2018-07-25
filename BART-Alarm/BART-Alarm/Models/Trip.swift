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
    var trainID: String
    var startLocation: String
    var endLocation: String
    var tripLength: String
    var alarmMinutes: Int // change to time file types?
    
    init() {
        self.route = "default"
        self.routeNumber = "default"
        self.trainID = "default"
        self.startLocation = "default"
        self.endLocation = "default"
        self.tripLength = "default"
        self.alarmMinutes = -1
    }
}
