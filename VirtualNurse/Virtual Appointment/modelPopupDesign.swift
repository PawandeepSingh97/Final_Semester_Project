//
//  modelPopupDesign.swift
//  VirtualNurse
//
//  Created by Mohamed Taufik on 5/1/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import UIKit

@IBDesignable class modelPopupDesign: UIView {

    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
}
