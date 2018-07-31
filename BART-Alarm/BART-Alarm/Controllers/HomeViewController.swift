//
//  HomeViewController.swift
//  BART-Alarm
//
//  Created by Cindy Wang on 7/25/18.
//  Copyright © 2018 cxw. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
//    @IBAction func unwindToHome(segue:UIStoryboardSegue) { print("IM BACK!!!") }
    @IBOutlet weak var currentAlarmsTableView: CurrentAlarmsTableView!
    
    var trip = Trip()
    var alarmWillRingTime = Date()

    override func viewDidLoad() {
        super.viewDidLoad()

        currentAlarmsTableView.delegate = self
        currentAlarmsTableView.dataSource = self
//        self.authorArticlesTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @IBAction func unwindToHomeScreen(_ segue: UIStoryboardSegue) {
//        print("Here")
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        println("numberOfRowsInSection")
        return 1 //self.articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentAlarmsCell") as! CurrentAlarmsTableViewCell
////        cell.articles = self.articles?[indexPath.row]
////        println("cellForRowAtIndexPath")
//        
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        let formattedDate = formatter.string(from: alarmWillRingTime)
        cell.alarmTimeLabel.text = formattedDate
        return cell
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
