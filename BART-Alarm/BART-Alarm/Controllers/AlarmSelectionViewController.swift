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
import UserNotifications

class AlarmSelectionViewController: UIViewController {
    
    @IBOutlet weak var routeLabel: UILabel!
    @IBOutlet weak var startEndStationsLabel: UILabel!
    @IBOutlet weak var tripLengthLabel: UILabel!
    @IBOutlet weak var trainDeparturePicker: UIDatePicker!
    @IBOutlet weak var alarmMinutesPicker: UIDatePicker!
    
    var trip: Trip?
    let notifCount = UserDefaults.standard.integer(forKey: "notifCount")
    
    @IBAction func CreateButtonTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "unwindToHomeCreate", sender: sender)
        
        let content = UNMutableNotificationContent()
        content.title = "Destination Approaching"
//        content.subtitle = "subtitle"
        content.body = "Train will arrive at \((trip?.endLocation)!) in \(Int(alarmMinutesPicker.countDownDuration)/60) minutes"
        content.badge = 1
//        content.sound =
        
        let calendar = NSCalendar.current
        trip?.alarmTime = trainDeparturePicker.date.addingTimeInterval((self.trip?.tripLength)! - alarmMinutesPicker.countDownDuration)
        print(trip?.alarmTime)
        
        let unitFlags: Set<Calendar.Component> = [.hour, .minute]
        let components = calendar.dateComponents(unitFlags, from: (trip?.alarmTime)!)
        
        UserDefaults.standard.set(notifCount + 1, forKey: "notifCount")
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: "timerDone\(notifCount)", content: content, trigger: trigger)
        print("timerDone\(notifCount)")
        
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
//        HomeViewController().moveCurrentAlarm()
    }
    
    func calculateTripTime() {
        
        let apiToContact = "http://api.bart.gov/api/sched.aspx?cmd=routesched&route=" + (self.trip?.routeNumber)! + "&key=MW9S-E7SL-26DU-VV8V&json=y"
        var stationTimesArray = [Date]()
        
        if let path = Bundle.main.path(forResource: "route-" + (self.trip?.routeNumber)! + "-schedule", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let json = try JSON(data: data)
//                print("jsonData:\(json)")
                
                for i in 1...300 {
                    
                    let stationTimesData = json["root"]["route"]["train"][i]["stop"].arrayValue
                    var valid = false
                    
                    for station in stationTimesData {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "h:mm a"
                        let origTime = station["@origTime"].stringValue
                        
                        if origTime != "" {
                            let date = dateFormatter.date(from: origTime)
                            stationTimesArray.append(date!)
                            valid = true
                        } else {
                            stationTimesArray = []
                            valid = false
                            break
                        }
                    }
                    
                    if valid == true { break }
                }
                
                self.trip?.tripLength = stationTimesArray[Int((self.trip?.endLocationIndex)!)].timeIntervalSince(stationTimesArray[Int((self.trip?.startLocationIndex)!)])
                print(self.trip?.tripLength)
                if (self.trip?.tripLength)! <= 0 {
                    self.trip?.tripLength *= -1
                }
                print(self.trip?.tripLength)
                self.tripLengthLabel.text = "Trip length: " + String(Int((self.trip?.tripLength)! / 60)) + " minutes"
                
                
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
        
//        Alamofire.request(apiToContact).validate().responseJSON() { response in
//            switch response.result {
//            case .success:
//                if let value = response.result.value {
//                    let json = JSON(value)
//
//                    for i in 1...300 {
//
//                        let stationTimesData = json["root"]["route"]["train"][i]["stop"].arrayValue
//                        var valid = false
//
//                        for station in stationTimesData {
//                            let dateFormatter = DateFormatter()
//                            dateFormatter.dateFormat = "h:mm a"
//                            let origTime = station["@origTime"].stringValue
//
//                            if origTime != "" {
//                                let date = dateFormatter.date(from: origTime)
//                                stationTimesArray.append(date!)
//                                valid = true
//                            } else {
//                                stationTimesArray = []
//                                valid = false
//                                break
//                            }
//                        }
//
//                        if valid == true { break }
//                    }
//
//                    self.trip?.tripLength = stationTimesArray[Int((self.trip?.endLocationIndex)!)].timeIntervalSince(stationTimesArray[Int((self.trip?.startLocationIndex)!)])
//                    print(self.trip?.tripLength)
//                    if (self.trip?.tripLength)! <= 0 {
//                        self.trip?.tripLength *= -1
//                    }
//                    print(self.trip?.tripLength)
//                    self.tripLengthLabel.text = "Trip length: " + String(Int((self.trip?.tripLength)! / 60)) + " minutes"
//
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        routeLabel.text = trip?.route
        startEndStationsLabel.text = (trip?.startLocation)! + " to " + (trip?.endLocation)!
        
        calculateTripTime()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        trip?.trainDepartureTime = trainDeparturePicker.date
        trip?.alarmTime = trainDeparturePicker.date.addingTimeInterval((self.trip?.tripLength)! - alarmMinutesPicker.countDownDuration)
        trip?.modificationTime = Date()
//        trip?.activated = true
        trip?.notifID = "timerDone\(notifCount)"
        print("save '\((trip?.notifID)!)'")
        CoreDataHelper.saveTrip()
    }
    
}
