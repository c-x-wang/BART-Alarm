//
//  AlarmSelectionViewController.swift
//  BART-Alarm
//
//  Created by Cindy Wang on 7/25/18.
//  Copyright © 2018 cxw. All rights reserved.
//

import UIKit

class AlarmSelectionViewController: UIViewController {
    
    @IBOutlet weak var routeLabel: UILabel!
    @IBOutlet weak var startEndStationsLabel: UILabel!
    @IBOutlet weak var tripLengthLabel: UILabel!
    
    var trip = Trip()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        routeLabel.text = trip.route
        startEndStationsLabel.text = trip.startLocation + " to " + trip.endLocation
        tripLengthLabel.text = "very long"
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
