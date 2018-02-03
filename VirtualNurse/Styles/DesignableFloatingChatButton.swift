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
    
    var badgeLabel = UILabel()
    
    var badge: String? {
        didSet {
            addBadgeToButon(badge: badge)
        }
    }
    
    public var badgeBackgroundColor = UIColor.red {
        didSet {
            badgeLabel.backgroundColor = badgeBackgroundColor
        }
    }
    
    public var badgeTextColor = UIColor.white {
        didSet {
            badgeLabel.textColor = badgeTextColor
        }
    }
    
    public var badgeFont = UIFont.systemFont(ofSize: 12.0) {
        didSet {
            badgeLabel.font = badgeFont
        }
    }
    
    public var badgeEdgeInsets: UIEdgeInsets? {
        didSet {
            addBadgeToButon(badge: badge)
        }
    }
    

    
    func addBadgeToButon(badge: String?) {
        badgeLabel.text = badge
        badgeLabel.textColor = badgeTextColor
        badgeLabel.backgroundColor = badgeBackgroundColor
        badgeLabel.font = badgeFont
        badgeLabel.sizeToFit()
        badgeLabel.textAlignment = .center
        let badgeSize = badgeLabel.frame.size
        
        let height = max(18, Double(badgeSize.height) + 5.0)
        let width = max(height, Double(badgeSize.width) + 10.0)
        
        var vertical: Double?, horizontal: Double?
        if let badgeInset = self.badgeEdgeInsets {
            vertical = Double(badgeInset.top) - Double(badgeInset.bottom)
            horizontal = Double(badgeInset.left) - Double(badgeInset.right)
            
            let x = (Double(bounds.size.width) - 10 + horizontal!)
            let y = -(Double(badgeSize.height) / 2) - 10 + vertical!
            badgeLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        } else {
            let x = self.frame.width - CGFloat((width / 2.0))
            let y = CGFloat(-(height / 2.0))
            badgeLabel.frame = CGRect(x: x-5, y: y-10, width: CGFloat(width), height: CGFloat(height))
        }
        
        badgeLabel.layer.cornerRadius = badgeLabel.frame.height/2
        badgeLabel.layer.masksToBounds = true
        addSubview(badgeLabel)
        badgeLabel.isHidden = badge != nil ? false : true
    }
    

}
