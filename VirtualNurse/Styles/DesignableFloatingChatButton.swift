//
//  DesignableFloatingChatButton.swift
//  VirtualNurse
//
//  Created by VongolaKillerAir on 7/1/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableFloatingChatButton: UIButton {

    @IBInspectable var cornerRadius:CGFloat = 0
        {
        didSet
        {
            self.layer.cornerRadius = cornerRadius;
        }
    }
    
//    @IBInspectable var isCircular:Bool = false
//        {
//        didSet
//        {
//            if isCircular
//            {
//                self.layer.cornerRadius = min(self.frame.size.height, self.frame.size.width) / 2.0
//                self.clipsToBounds = true
//            }
//            else
//            {
//                self.layer.cornerRadius = 0;
//                self.clipsToBounds = false;
//            }
//
//        }
//    }
    
//
    @IBInspectable var borderWidth:CGFloat = 0
        {
        didSet
        {
            self.layer.borderWidth = borderWidth;
        }
    }

    @IBInspectable var borderColor:UIColor = UIColor.clear
        {
        didSet
        {
            self.layer.borderColor = borderColor.cgColor;
        }
    }
//
    
    @IBInspectable var shadowColor:UIColor = UIColor.clear
        {
        didSet{
            self.layer.shadowColor = shadowColor.cgColor;
        }
    }
    
    @IBInspectable var shadowOffset:CGSize = CGSize(width: 0, height: 0 )
    {
        didSet
        {
            self.layer.shadowOffset = shadowOffset;
        }
    }
    
    @IBInspectable var shadowRadius:CGFloat = 0
        {
        didSet{
            self.layer.shadowRadius = shadowRadius;
        }
    }
    
    @IBInspectable var shadowOpacity:Float = 0
        {
        didSet{
            self.layer.shadowOpacity = shadowOpacity;
        }
    }
    
    
    

}
