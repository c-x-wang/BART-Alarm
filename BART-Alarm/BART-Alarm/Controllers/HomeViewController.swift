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
//    @IBOutlet weak var currentAlarmsView: CurrentAlarmsView!
    @IBOutlet weak var historyAlarmsTableView: HistoryAlarmsTableView!

    var trips = [Trip]() {
        didSet {
//            currentAlarmsTableView.reloadData()
            historyAlarmsTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        currentAlarmsTableView.delegate = self
        currentAlarmsTableView.dataSource = self
        currentAlarmsTableView.rowHeight = 105
        currentAlarmsTableView.isScrollEnabled = false
        
//        currentAlarmsView.delegate = self

        historyAlarmsTableView.delegate = self
        historyAlarmsTableView.dataSource = self
        historyAlarmsTableView.rowHeight = 105

        trips = CoreDataHelper.retrieveTrips()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        if trips.first != nil {
//            currentAlarmsView.routeNameLabel.text = trips.first?.route
//            currentAlarmsView.routeStationsLabel.text = (trips.first?.startLocation)! + " to " + (trips.first?.endLocation)!
//            
//            let formatter = DateFormatter()
//            formatter.dateFormat = "h:mm a"
//            let formattedTrainDate = formatter.string(from: (trips.first?.trainDepartureTime)!)
//            let formattedAlarmDate = formatter.string(from: (trips.first?.alarmTime)!)
//            currentAlarmsView.trainDepartureTimeLabel.text = "Train departure: " + formattedTrainDate
//            currentAlarmsView.alarmTimeLabel.text = "Alarm: " + formattedAlarmDate
//        } else {
//            currentAlarmsView.routeNameLabel.text = ""
//            currentAlarmsView.routeStationsLabel.text = "No current alarm to display"
//            currentAlarmsView.trainDepartureTimeLabel.text = ""
//            currentAlarmsView.alarmTimeLabel.text = ""
//        }
        
        currentAlarmsTableView.reloadData()
        historyAlarmsTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let tripToDelete = trips[indexPath.row]
            CoreDataHelper.deleteTrip(trip: tripToDelete)
            
            trips = CoreDataHelper.retrieveTrips()
            self.viewWillAppear(false)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == currentAlarmsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentAlarmsCell") as! CurrentAlarmsTableViewCell
            
            let trip = trips[indexPath.row]
            
            cell.routeNameLabel.text = trip.route!
            cell.routeStationsLabel.text = trip.startLocation! + " to " + trip.endLocation!
            
            
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            let formattedTrainDate = formatter.string(from: trip.trainDepartureTime!)
            let formattedAlarmDate = formatter.string(from: trip.alarmTime!)
            cell.trainDepartureTimeLabel.text = "Train departure: " + formattedTrainDate
            cell.alarmTimeLabel.text = "Alarm: " + formattedAlarmDate
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryAlarmsCell") as! HistoryAlarmsTableViewCell
            
            let trip = trips[indexPath.row]
            
            cell.routeNameLabel.text = trip.route!
            cell.routeStationsLabel.text = trip.startLocation! + " to " + trip.endLocation!
            
            
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            let formattedTrainDate = formatter.string(from: trip.trainDepartureTime!)
            let formattedAlarmDate = formatter.string(from: trip.alarmTime!)
            cell.trainDepartureTimeLabel.text = "Train departure: " + formattedTrainDate
            cell.alarmTimeLabel.text = "Alarm: " + formattedAlarmDate
            
            return cell
        }
    }
    
    func moveCurrentAlarm() {
        print("move current alarm")
    }






    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    @IBAction func currentAlarmsViewButtonTapped(_ sender: Any) {
    }
    @IBAction func unwindToHomeScreen(_ segue: UIStoryboardSegue) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "unwindToHomeCreate":
            trips = CoreDataHelper.retrieveTrips()
            print("unwind to home from create")
            
        case "unwindToHomeCancel":
            print("unwind to home from cancel")
            
        default:
            print("unexpected segue identifier")
        }
    }


}
