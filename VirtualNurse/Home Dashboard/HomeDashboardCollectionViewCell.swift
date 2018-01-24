//
//  HomeDashboardCollectionViewCell.swift
//  VirtualNurse
//
//  Created by Mohamed Imran on 24/1/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

//
//  MonitoringCollectionViewCell.swift
//  VirtualNurse
//
//  Created by Mohamed Imran on 30/12/17.
//  Copyright © 2017 TeamSurvivor. All rights reserved.
//

import UIKit

//Creating a button action method
protocol HomeDashboardCollectionViewCellDelegate {
    func didCellButtonTapped(cell: HomeDashboardCollectionViewCell)
    
}

class HomeDashboardCollectionViewCell: UICollectionViewCell {
    
    var delegate: HomeDashboardCollectionViewCellDelegate!
    @IBOutlet weak var monitoringImages: UIImageView!
    @IBOutlet weak var monitoringNames: UILabel!
    //    @IBOutlet weak var measureButton: UIButton!
    //    @IBOutlet weak var circleLogo: UIImageView!
    @IBOutlet weak var monitoringValue: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Designing a button programmitically
        let borderAlpha : CGFloat = 0.7
        let cornerRadius : CGFloat = 5.0
        //        measureButton.frame = CGRect(x: 13, y: 120, width: 100, height: 30)
        //        measureButton.setTitle("MEASURE", for: [])
        //        measureButton.setTitleColor(UIColor.white, for: [])
        //        measureButton.backgroundColor = UIColor.clear
        //        measureButton.layer.borderWidth = 1.0
        //        measureButton.layer.borderColor = UIColor.blue.cgColor
        //        measureButton.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        //        measureButton.layer.cornerRadius = cornerRadius
        monitoringNames.textAlignment = .center
        
    }
    
    //Button click action method
    @IBAction func measureButtonClicked(_ sender: Any) {
        delegate?.didCellButtonTapped(cell: self)
    }
    
    
    
    
}

