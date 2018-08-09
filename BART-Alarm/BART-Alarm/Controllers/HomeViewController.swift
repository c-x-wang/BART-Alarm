//
//  HomeViewController.swift
//  BART-Alarm
//
//  Created by Cindy Wang on 7/25/18.
//  Copyright © 2018 cxw. All rights reserved.
//

import UIKit
import CoreData
//import UserNotifications

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

//    @IBOutlet weak var currentAlarmsTableView: CurrentAlarmsTableView!
//    @IBOutlet weak var currentAlarmsView: CurrentAlarmsView!
    @IBOutlet weak var historyAlarmsTableView: HistoryAlarmsTableView!
    @IBOutlet weak var titleView: UIView!
    
    var trips = [Trip]() {
        didSet {
//            currentAlarmsTableView.reloadData()
            historyAlarmsTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        

        historyAlarmsTableView.delegate = self
        historyAlarmsTableView.dataSource = self
        historyAlarmsTableView.rowHeight = 105

        trips = CoreDataHelper.retrieveTrips()
//        print(trips)
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
        } else {
            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData(_:)), name: NSNotification.Name("ReloadNotification"), object: nil)
    }
    
    @objc func reloadData(_ notification: Notification?) {
        print("pls reload \(Date())")
        self.historyAlarmsTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
//    @objc func willEnterForeground() {
//        print("print if willEnterForeground() is called")
//        self.historyAlarmsTableView.reloadData()
//    }

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

        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryAlarmsCell") as! HistoryAlarmsTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let trip = trips[indexPath.row]
//        print(trip)
        
        cell.routeNameLabel.text = " " + trip.route!
        cell.routeStationsLabel.text = trip.startLocation! + " to " + trip.endLocation!
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        let formattedTrainDate = formatter.string(from: trip.trainDepartureTime!)
        let formattedAlarmDate = formatter.string(from: trip.alarmTime!)
        cell.trainDepartureTimeLabel.text = "Train departure: " + formattedTrainDate
        cell.alarmTimeLabel.text = formattedAlarmDate //"Alarm: " + formattedAlarmDate
        
        let now = Date()
        if (trip.alarmTime?.timeIntervalSince1970)! - 20 <= now.timeIntervalSince1970 {
            cell.routeNameLabel.textColor = UIColor.gray
            cell.routeStationsLabel.textColor = UIColor.gray
            cell.trainDepartureTimeLabel.textColor = UIColor.gray
            cell.alarmTimeLabel.textColor = UIColor.gray
        } else {
            cell.routeNameLabel.textColor = UIColor.black
            cell.routeStationsLabel.textColor = UIColor.black
            cell.trainDepartureTimeLabel.textColor = UIColor.black
            cell.alarmTimeLabel.textColor = UIColor.black
        }
        
        return cell
//        }
    }
    
//    func moveCurrentAlarm() {
//        print("move current alarm")
//    }






    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "showDisplayAlarm":
            if let indexPath = historyAlarmsTableView.indexPathForSelectedRow {
                let selectedRow = indexPath.row
                let vc = segue.destination as! DisplayAlarmViewController
                vc.trip = self.trips[selectedRow]
                print(vc.trip)
            }
//            let vc = segue.destination as! DisplayAlarmViewController
//            vc.trip = trips[(historyAlarmsTableView.indexPathForSelectedRow?.row)!]
//            print(vc.trip)
            
        default:
            print("unexpected segue identifier")
        }
    }

    @IBAction func currentAlarmsViewButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "showDisplayAlarm", sender: sender)
        print("display alarm")
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
