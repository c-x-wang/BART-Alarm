//
//  AlarmSelectionViewController.swift
//  BART-Alarm
//
//  Created by Cindy Wang on 7/25/18.
//  Copyright © 2018 cxw. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage
import AlamofireNetworkActivityIndicator

class AlarmSelectionViewController: UIViewController {
    
    @IBOutlet weak var routeLabel: UILabel!
    @IBOutlet weak var startEndStationsLabel: UILabel!
    @IBOutlet weak var tripLengthLabel: UILabel!
    
    var trip = Trip()
    
    func calculateTripTime() {
        
        let apiToContact = "http://api.bart.gov/api/sched.aspx?cmd=routesched&route=" + self.trip.routeNumber + "&key=MW9S-E7SL-26DU-VV8V&json=y"
        var stationTimesArray = [String]()
        
        Alamofire.request(apiToContact).validate().responseJSON() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    let stationTimesData = json["root"]["route"]["train"][0]["stop"].arrayValue
                    
                    for station in stationTimesData {
                        stationTimesArray.append(station["@origTime"].stringValue)
                    }
                    print(stationTimesArray)
                    
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        routeLabel.text = trip.route
        startEndStationsLabel.text = trip.startLocation + " to " + trip.endLocation
        tripLengthLabel.text = "Trip length: " + trip.tripLength
        calculateTripTime()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
