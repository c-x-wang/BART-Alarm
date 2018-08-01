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
    
//    var trip = Trip()
//    var alarmWillRingTime = Date()
    
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
        
//        let fetchRequest = NSFetchRequest(entityName: "Item")
//        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//        do {
//            try persistentStoreCoordinator.destroyPersistentStoreAtURL(persistentStoreURL, withType: NSSQLiteStoreType, options: nil)
//            
//        } catch {
//            // Error Handling
//        }
        
//        self.currentAlarmsTableView.reloadData()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        
////        self.currentAlarmsTableView.reloadData()
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        println("numberOfRowsInSection")
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentAlarmsCell") as! CurrentAlarmsTableViewCell

        let trip = trips[indexPath.row]
        
//        guard let trip = trips[indexPath.row] else {
//            return cell
//        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
//        guard let alarmTime = trip.alarmTime else {
////            return cell
//            enum MyError: Error {
//                case runtimeError(String)
//            }
//            throw MyError.runtimeError("life is sad")
//        }
        let formattedDate = formatter.string(from: trip.alarmTime!)
        cell.alarmTimeLabel.text = "Alarm will ring at: " + formattedDate
        return cell
        
        
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "listNotesTableViewCell", for: indexPath) as! ListNotesTableViewCell
        
//        let note = notes[indexPath.row]
//        cell.noteTitleLabel.text = note.title
//
//        cell.noteModificationTimeLabel.text = note.modificationTime?.convertToString() ?? "unknown"
//
//        let content = note.content
//        let contentLines = content?.components(separatedBy: "\n")
//        if let contentLines = contentLines {
//            cell.noteTruncatedLabel.text = contentLines[0]
//        } else {
//            cell.noteTruncatedLabel.text = content
//        }
//
//        return cell
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
