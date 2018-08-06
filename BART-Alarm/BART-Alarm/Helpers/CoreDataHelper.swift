//
//  CoreDataHelper.swift
//  BART-Alarm
//
//  Created by Cindy Wang on 8/1/18.
//  Copyright © 2018 cxw. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import UserNotifications

struct CoreDataHelper {
    static let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        return context
    }()
    
    static func newTrip() -> Trip {
        let trip = NSEntityDescription.insertNewObject(forEntityName: "Trip", into: context) as! Trip
        
        return trip
    }
    
    static func saveTrip() {
        do {
            try context.save()
        } catch let error {
            print("Could not save \(error.localizedDescription)")
        }
    }
    
    static func deleteTrip(trip: Trip) {
        context.delete(trip)
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            var identifiers: [String] = []
            for notification:UNNotificationRequest in notificationRequests {
                if notification.identifier == trip.notifID {
                    identifiers.append(notification.identifier)
                    print("deleting \((trip.notifID)!)")
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
        
        saveTrip()
    }
    
    static func retrieveTrips() -> [Trip]{
        do {
            let fetchRequest = NSFetchRequest<Trip>(entityName: "Trip")
            var results = try context.fetch(fetchRequest)
            
//            for result in results {
//                if result.modificationTime == nil {
//                    CoreDataHelper.deleteTrip(trip: result)
//                    print("incomplete trip deleted cdh")
//                }
//            }
            
            if results.count > 1 {
                for result in results {
//                    print("checking results")
                    if result.modificationTime == nil {
                        CoreDataHelper.deleteTrip(trip: result)
                        print("incomplete trip deleted cdh2")
                    }
                }
                results.sort { $0.modificationTime! > $1.modificationTime! }
            }
//            results.sort { $0.alarmTime! > $1.alarmTime! }
            
            return results
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")
            
            return []
        }
    }
}
