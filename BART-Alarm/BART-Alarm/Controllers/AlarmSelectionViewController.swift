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
    
    var trip = Trip()
    
    @IBAction func CreateButtonTapped(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
        
        self.activateAlarm()
        self.runTimer()
    }
    
    func calculateTripTime() {
        
        let apiToContact = "http://api.bart.gov/api/sched.aspx?cmd=routesched&route=" + self.trip.routeNumber + "&key=MW9S-E7SL-26DU-VV8V&json=y"
        var stationTimesArray = [Date]()
        
        Alamofire.request(apiToContact).validate().responseJSON() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    let stationTimesData = json["root"]["route"]["train"][0]["stop"].arrayValue
                    
                    for station in stationTimesData {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "h:mm a"
                        let date = dateFormatter.date(from: station["@origTime"].stringValue)
                        stationTimesArray.append(date!)
                    }
                    print(stationTimesArray)
                    self.trip.tripLength = stationTimesArray[self.trip.endLocationIndex].timeIntervalSince(stationTimesArray[self.trip.startLocationIndex])
                    print(self.trip.tripLength)
                    self.tripLengthLabel.text = "Trip length: " + String(Int(self.trip.tripLength / 60)) + " minutes"
                    
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
        
//        let formatter = DateFormatter()
//        formatter.dateFormat = "h:mm"
//        let formattedDate = formatter.string(from: trip.tripLength)
//        tripLengthLabel.text = "Trip length: " + formattedDate
        calculateTripTime()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
        })
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(false)
//
//        calculateTripTime()
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let vc = segue.destination as! HomeViewController
//        vc.trip = self.trip
    }
 
    
    // ALARM
    
    @IBOutlet weak var trainDeparturePicker: UIDatePicker!
    @IBOutlet weak var alarmMinutesPicker: UIDatePicker!
    
    var seconds: TimeInterval = 5
    
//    var timer = Timer()
    var isTimerRunning = false
    
    func activateAlarm() {
        seconds = self.trip.tripLength - alarmMinutesPicker.countDownDuration
        print(seconds)
    }
    
    func runTimer() {
//        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(AlarmSelectionViewController.updateTimer)), userInfo: nil, repeats: true)
        let alarmTime = self.trainDeparturePicker.date + TimeInterval(20)
        var timer = Timer(fireAt: alarmTime, interval: 5, target: self, selector: (#selector(AlarmSelectionViewController.updateTimer)), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .commonModes)
    }
    
    @objc func updateTimer() {
//        self.seconds -= 1
        print("hell yeah")
        
        
    }
    
    @IBAction func testButtonPressed(_ sender: Any) {
        let content = UNMutableNotificationContent()
        content.title = "title"
        content.subtitle = "subtitle"
        content.body = "body"
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 20, repeats: false)
        let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
}
