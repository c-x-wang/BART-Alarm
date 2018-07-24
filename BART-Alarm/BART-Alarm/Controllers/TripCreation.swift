//
//  TripCreation.swift
//  BART-Alarm
//
//  Created by Cindy Wang on 7/24/18.
//  Copyright © 2018 cxw. All rights reserved.
//

//import Foundation
import UIKit
import DropDown
import SwiftyJSON
import Alamofire
import AlamofireImage
import AlamofireNetworkActivityIndicator

class TripCreation: UIViewController {
    
    @IBOutlet weak var chooseRouteButton: UIButton!
    @IBOutlet weak var chooseStartButton: UIButton!
    @IBOutlet weak var chooseEndButton: UIButton!
    
    let routeDropDown = DropDown()
    let startStationDropDown = DropDown()
    let endStationDropDown = DropDown()
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.routeDropDown,
            self.startStationDropDown,
            self.endStationDropDown
        ]
    }()
    
    @IBAction func chooseRouteTapped(_ sender: Any) {
        routeDropDown.show()
    }
    @IBAction func chooseStartTapped(_ sender: Any) {
        startStationDropDown.show()
    }
    @IBAction func chooseEndTapped(_ sender: Any) {
        endStationDropDown.show()
    }
    
    func setupDropDowns() {
        setupRouteDropDown()
        setupStartStationDropDown()
        setupEndStationDropDown()
    }
    
    func setupRouteDropDown() {
        routeDropDown.anchorView = chooseRouteButton
        
        routeDropDown.bottomOffset = CGPoint(x: 0, y: 30) // chooseRouteButton.bounds.height)
        
        let apiToContact = "http://api.bart.gov/api/route.aspx?cmd=routes&key=MW9S-E7SL-26DU-VV8V&json=y"
        var routesArray = [String]()
        
        Alamofire.request(apiToContact).validate().responseJSON() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    let routesData = json["root"]["routes"]["route"].arrayValue
                    
                    for route in routesData {
                        routesArray.append(route["name"].stringValue)
                    }
                    
                    self.routeDropDown.dataSource = routesArray
                }
            case .failure(let error):
                print(error)
            }
        }
        
        routeDropDown.selectionAction = { [weak self] (index, item) in
            self?.chooseRouteButton.setTitle(item, for: .normal)
        }
    }
    
    func setupStartStationDropDown() {
        startStationDropDown.anchorView = chooseStartButton
        
        startStationDropDown.bottomOffset = CGPoint(x: 0, y: 30) // chooseStartButton.bounds.height)
        
        startStationDropDown.dataSource = ["station", "station2", "uh"]
        
        startStationDropDown.selectionAction = { [weak self] (index, item) in
            self?.chooseStartButton.setTitle(item, for: .normal)
        }
    }
    
    func setupEndStationDropDown() {
        endStationDropDown.anchorView = chooseEndButton
        
        endStationDropDown.bottomOffset = CGPoint(x: 0, y: 30) //chooseEndButton.bounds.height)
        
        endStationDropDown.dataSource = ["end pls", "station of death", "no"]
        
        endStationDropDown.selectionAction = { [weak self] (index, item) in
            self?.chooseEndButton.setTitle(item, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDropDowns()
    }
    
}
