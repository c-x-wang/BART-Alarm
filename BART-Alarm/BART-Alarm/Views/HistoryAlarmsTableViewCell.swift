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
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        backgroundColor = UIColor.clear
//        
//        self.backView.layer.borderWidth = 0
//        self.backView.layer.cornerRadius = 5
//        self.backView.layer.borderColor = UIColor.black.cgColor
//        self.backView.layer.masksToBounds = true
//        
//        self.layer.shadowOpacity = 0.18
//        self.layer.shadowOffset = CGSize(width: 0, height: 2)
//        self.layer.shadowRadius = 2
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.masksToBounds = false
        
//        let shadowSize : CGFloat = 5.0
//        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2, y: -shadowSize / 2, width: self.frame.size.width + shadowSize, height: self.frame.size.height + shadowSize))
//        self.layer.masksToBounds = false
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//        self.layer.shadowOpacity = 0.18
//        self.layer.shadowPath = shadowPath.cgPath
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
