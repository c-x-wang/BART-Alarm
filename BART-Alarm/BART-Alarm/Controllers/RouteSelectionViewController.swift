//
//  RouteSelectionViewController.swift
//  BART-Alarm
//
//  Created by Cindy Wang on 7/24/18.
//  Copyright © 2018 cxw. All rights reserved.
//

import UIKit
import DropDown
import SwiftyJSON
import Alamofire
import AlamofireImage
import AlamofireNetworkActivityIndicator

class RouteSelectionViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mapPhoto: UIImageView!
    @IBOutlet weak var chooseRouteButton: UIButton!
//    @IBOutlet weak var chooseRouteField: UITextField!
    
    var trip: Trip?
    var route: String = ""
    var routeNumber: String = ""
    
    let routeDropDown = DropDown()
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.routeDropDown
        ]
    }()
    
    @IBAction func chooseRouteTapped(_ sender: Any) {
        routeDropDown.show()
    }
//    @IBAction func chooseRouteFieldTapped(_ sender: Any) {
//        routeDropDown.show()
//    }
    
    func setupRouteDropDown() {
        routeDropDown.anchorView = chooseRouteButton
//        routeDropDown.anchorView = chooseRouteField
        
        routeDropDown.bottomOffset = CGPoint(x: 0, y: 30) // chooseRouteButton.bounds.height)
        routeDropDown.direction = .bottom
        
//        let apiToContact = "http://api.bart.gov/api/route.aspx?cmd=routes&key=MW9S-E7SL-26DU-VV8V&json=y"
        var routeNames = [String]()
        var routeNumbers = [String]()
        
        if let path = Bundle.main.path(forResource: "routes", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let json = try JSON(data: data)
//                print("jsonData:\(json)")
                
                let routesData = json["root"]["routes"]["route"].arrayValue
                
                for route in routesData {
                    if route["number"].intValue % 2 == 0 {
                        routeNames.append(route["name"].stringValue)
                        routeNumbers.append(route["number"].stringValue)
                    }
                }
                
                self.routeDropDown.dataSource = routeNames
                
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
//                    let routesData = json["root"]["routes"]["route"].arrayValue
//
//                    for route in routesData {
//                        if route["number"].intValue % 2 == 0 {
//                            routeNames.append(route["name"].stringValue)
//                            routeNumbers.append(route["number"].stringValue)
//                        }
//                    }
//
//                    self.routeDropDown.dataSource = routeNames
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
        
        routeDropDown.selectionAction = { [weak self] (index, item) in
            self?.chooseRouteButton.setTitle(item, for: .normal)
//            self?.chooseRouteField.text = item
            self?.route = item
            self?.routeNumber = routeNumbers[index]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRouteDropDown()
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return mapPhoto
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "showStationSelection":
            let vc = segue.destination as! StationSelectionViewController
            let trip = CoreDataHelper.newTrip()
            trip.route = self.route
            trip.routeNumber = self.routeNumber
            vc.trip = trip
            
        case "unwindToHomeCancel":
            print("cancel:")
            if trip != nil {
                CoreDataHelper.deleteTrip(trip: trip!)
            }
            
        default:
            print("unexpected segue identifier")
        }
    }
 
    @IBAction func nextButtonTapped(_ sender: Any) {
        if self.chooseRouteButton.currentTitle == "Choose Route" {
            let alert = UIAlertController(title: "Error", message: "Please select all fields on this screen.", preferredStyle: .alert)
            
    //        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        } else {
            performSegue(withIdentifier: "showStationSelection", sender: sender)
        }
    }
    
}
