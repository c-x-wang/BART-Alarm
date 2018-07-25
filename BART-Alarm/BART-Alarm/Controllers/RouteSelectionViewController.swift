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

class RouteSelectionViewController: UIViewController {
    
    @IBOutlet weak var chooseRouteButton: UIButton!
    
    var trip = Trip()
    
    let routeDropDown = DropDown()
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.routeDropDown
        ]
    }()
    
    @IBAction func chooseRouteTapped(_ sender: Any) {
        routeDropDown.show()
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
            self?.trip.route = item
            print(self?.trip.route ?? "default val")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRouteDropDown()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        _ = segue.destination as! StationSelectionViewController
//        Pass the selected object to the new view controller.
     }
 
    
}
