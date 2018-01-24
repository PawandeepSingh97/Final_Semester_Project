//
//  ViewAppointmentCollectionViewCell.swift
//  VirtualNurse
//
//  Created by Mohamed Taufik on 31/12/17.
//  Copyright © 2017 TeamSurvivor. All rights reserved.
//

import UIKit

protocol ViewAppointmentCollectionViewCellDelegate: class {
    func delete(cell: ViewAppointmentCollectionViewCell)
}

class ViewAppointmentCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: ViewAppointmentCollectionViewCellDelegate?
    @IBOutlet weak var doctorName: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var date: UILabel!
    
    
    @IBOutlet weak var deleteButtonBackgroundView: UIVisualEffectView!
    
    
    @IBAction func deleteButtonDidTap(_ sender: Any) {
        delegate?.delete(cell: self)
    }
    
    override func awakeFromNib() {
        deleteButtonBackgroundView.isHidden = true
    }
    
    var isEditing: Bool = false {
        didSet{

            deleteButtonBackgroundView.isHidden = !isEditing
        }
    }
    
}
