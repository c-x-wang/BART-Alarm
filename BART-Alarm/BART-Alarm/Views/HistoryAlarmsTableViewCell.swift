//
//  HistoryAlarmsTableViewCell.swift
//  BART-Alarm
//
//  Created by Cindy Wang on 8/1/18.
//  Copyright © 2018 cxw. All rights reserved.
//

import UIKit

class HistoryAlarmsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var routeNameLabel: UILabel!
    @IBOutlet weak var routeStationsLabel: UILabel!
    @IBOutlet weak var trainDepartureTimeLabel: UILabel!
    @IBOutlet weak var alarmTimeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
