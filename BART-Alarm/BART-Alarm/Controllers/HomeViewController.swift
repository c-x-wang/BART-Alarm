//
//  HomeViewController.swift
//  BART-Alarm
//
//  Created by Cindy Wang on 7/25/18.
//  Copyright © 2018 cxw. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var currentAlarmsTableView: CurrentAlarmsTableView!
    
    var trips = [Trip]() {
        didSet {
            currentAlarmsTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        currentAlarmsTableView.delegate = self
        currentAlarmsTableView.dataSource = self
        
        trips = CoreDataHelper.retrieveTrips()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentAlarmsCell") as! CurrentAlarmsTableViewCell

        let trip = trips[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        let formattedDate = formatter.string(from: trip.alarmTime!)
        cell.alarmTimeLabel.text = "Alarm will ring at: " + formattedDate
        
        return cell
    }
    
    

    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func unwindToHomeScreen(_ segue: UIStoryboardSegue) {
        print("Here")
        trips = CoreDataHelper.retrieveTrips()
    }
 

}
