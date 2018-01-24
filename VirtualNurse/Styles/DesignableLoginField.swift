//
//  DesignableLoginField.swift
//  VirtualNurse
//
//  Created by VongolaKillerAir on 7/1/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableLoginField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    //var to store image
    @IBInspectable var leftImage:UIImage?
        {
        didSet{
            updateView();
        }
    }
    
    //var to set left padding
    @IBInspectable var leftPadding:CGFloat = 0
        {
        didSet{
            updateView();
        }
    }
    
    @IBInspectable var cornerRadius:CGFloat = 0
        {
        didSet{
            layer.cornerRadius = cornerRadius;
        }
    }
    
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
    
    
    
    
    func updateView() {
        
        let border = CALayer()
        let width = CGFloat(0.5);
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        
        if let image = leftImage
        {
            leftViewMode = .always//display image
            
            //set image view to store image,                    20 x 20 image size
            let imageView = UIImageView(frame: CGRect(x: leftPadding, y: 0, width: 20, height: 20));
            imageView.image = image;
            
            var width = leftPadding + 20;
            
            if borderStyle == UITextBorderStyle.none || borderStyle == UITextBorderStyle.line
            {
                width = width + 5;
            }
            
                                                    // set width 25 to have extra padding
            let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20));
            view.addSubview(imageView);
            
            
            
            leftView = view;
            
        }
        else //if image is nil
        {

            leftViewMode = .never;
        }
    }
    
    
    let PlaceHolderpadding = UIEdgeInsets(top: 0, left: 0 , bottom: 0, right: 0);
    
   
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, PlaceHolderpadding)
    }

    
    
    
    

}
