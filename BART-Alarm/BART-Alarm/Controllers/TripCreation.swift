//
//  TripCreation.swift
//  BART-Alarm
//
//  Created by Cindy Wang on 7/24/18.
//  Copyright © 2018 cxw. All rights reserved.
//

import UIKit
import DropDown

class TripCreation: UIViewController {
    
    @IBOutlet weak var chooseRouteButton: UIButton!
    
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
    
    func setupDropDowns() {
        setupRouteDropDown()
        
        // dataSource setup
        startStationDropDown.dataSource = ["station", "station2", "uh"]
        endStationDropDown.dataSource = ["end pls", "station of death", "no"]
    }
    
    func setupRouteDropDown() {
        routeDropDown.anchorView = chooseRouteButton
        
        routeDropDown.bottomOffset = CGPoint(x: 0, y: chooseRouteButton.bounds.height)
        
        routeDropDown.dataSource = ["uh", "pls", "work"]
        
        routeDropDown.selectionAction = { [weak self] (index, item) in
            self?.chooseRouteButton.setTitle(item, for: .normal)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDropDowns()
    }
    
}
