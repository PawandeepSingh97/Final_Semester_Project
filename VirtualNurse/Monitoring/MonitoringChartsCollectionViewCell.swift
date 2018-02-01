//
//  MonitoringChartsCollectionViewCell.swift
//  VirtualNurse
//
//  Created by Mohamed Imran on 30/1/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import UIKit

class MonitoringChartsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var monitoringTodayValue: UILabel!
    @IBOutlet weak var line: LineChart!
    @IBOutlet weak var monitoringName: UILabel!
    
}
