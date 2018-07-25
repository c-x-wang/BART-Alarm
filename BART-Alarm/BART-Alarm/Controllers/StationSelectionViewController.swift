//
//  StationSelectionViewController.swift
//  BART-Alarm
//
//  Created by Cindy Wang on 7/25/18.
//  Copyright © 2018 cxw. All rights reserved.
//

import UIKit
import DropDown
import SwiftyJSON
import Alamofire
import AlamofireImage
import AlamofireNetworkActivityIndicator

class StationSelectionViewController: UIViewController {
    
    @IBOutlet weak var routeLabel: UILabel!
    @IBOutlet weak var chooseStartButton: UIButton!
    @IBOutlet weak var chooseEndButton: UIButton!
    
    var trip = Trip()
    
    let startStationDropDown = DropDown()
    let endStationDropDown = DropDown()
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.startStationDropDown,
            self.endStationDropDown
        ]
    }()
    
    @IBAction func chooseStartTapped(_ sender: Any) {
        startStationDropDown.show()
    }
    @IBAction func chooseEndTapped(_ sender: Any) {
        endStationDropDown.show()
    }
    
    func setupStartStationDropDown() {
        print("route: " + self.trip.route)
        print("route number: " + self.trip.routeNumber)
        
        startStationDropDown.anchorView = chooseStartButton
        
        startStationDropDown.bottomOffset = CGPoint(x: 0, y: 30) // chooseStartButton.bounds.height)
        
        let apiToContact = "http://api.bart.gov/api/route.aspx?cmd=routeinfo&route=" + self.trip.routeNumber + "&key=MW9S-E7SL-26DU-VV8V&json=y"
        var stationsArray = [String]()

        Alamofire.request(apiToContact).validate().responseJSON() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)

                    let stationsData = json["root"]["routes"]["route"]["config"]["station"].arrayValue

                    for station in stationsData {
                        stationsArray.append(station.stringValue)
                    }

                    self.startStationDropDown.dataSource = stationsArray
                }
            case .failure(let error):
                print(error)
            }
        }
        
        startStationDropDown.selectionAction = { [weak self] (index, item) in
            self?.chooseStartButton.setTitle(item, for: .normal)
            self?.trip.startLocation = item
            self?.trip.startLocationIndex = index
            print(self?.trip.startLocation)
        }
    }
    
    func setupEndStationDropDown() {
        endStationDropDown.anchorView = chooseEndButton
        
        endStationDropDown.bottomOffset = CGPoint(x: 0, y: 30) //chooseEndButton.bounds.height)
        
        let apiToContact = "http://api.bart.gov/api/route.aspx?cmd=routeinfo&route=" + self.trip.routeNumber + "&key=MW9S-E7SL-26DU-VV8V&json=y"
        var stationsArray = [String]()
        
        Alamofire.request(apiToContact).validate().responseJSON() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    let stationsData = json["root"]["routes"]["route"]["config"]["station"].arrayValue
                    
                    for station in stationsData {
                        stationsArray.append(station.stringValue)
                    }
                    
                    self.endStationDropDown.dataSource = stationsArray
                }
            case .failure(let error):
                print(error)
            }
        }
        
        endStationDropDown.selectionAction = { [weak self] (index, item) in
            self?.chooseEndButton.setTitle(item, for: .normal)
            self?.trip.endLocation = item
            self?.trip.endLocationIndex = index
            print(self?.trip.endLocation)
        }
    }
    
//    func calculateTripTime() {
//        
//        let apiToContact = "http://api.bart.gov/api/sched.aspx?cmd=routesched&route=" + self.trip.routeNumber + "&key=MW9S-E7SL-26DU-VV8V&json=y"
//        var stationTimesArray = [String]()
//        
//        Alamofire.request(apiToContact).validate().responseJSON() { response in
//            switch response.result {
//            case .success:
//                if let value = response.result.value {
//                    let json = JSON(value)
//                    
//                    let stationTimesData = json["root"]["route"]["train"]["stop"].arrayValue
//                    
//                    for station in stationTimesData {
//                        stationTimesArray.append(station["@origTime"].stringValue)
//                    }
//                    print(stationTimesArray)
//                    
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        routeLabel.text = trip.route
        
        setupStartStationDropDown()
        setupEndStationDropDown()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AlarmSelectionViewController
        vc.trip = self.trip
    }
    

}
