//
//  PromptChatView.swift
//  VirtualNurse
//
//  Created by VongolaKillerAir on 30/1/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import UIKit

class PromptChatView: UIStackView {
    
    
    var yesButton:UIButton?
    var noButton:UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.spacing = 2;
        self.distribution = .fillEqually;
        
        yesButton = UIButton(type: .roundedRect)
        noButton = UIButton(type: .roundedRect)
        
        yesButton?.setTitle("YES", for: .normal);
        noButton?.setTitle("NO", for: .normal);
        
        self.addArrangedSubview(yesButton!);
        self.addArrangedSubview(noButton!);
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    self.messageInputBar.topStackView.distribution = .fillProportionally;
//    self.messageInputBar.topStackView.spacing = 0;
//    self.messageInputBar.topStackView.axis = .horizontal;
//    self.messageInputBar.topStackView.alignment = .center;
//    self.messageInputBar.topStackView.isOpaque = false;
//    self.messageInputBar.topStackView.backgroundColor = .clear;
//    self.messageInputBar.topStackViewPadding = .init(top: 5, left: 5, bottom: 5, right: 5);
//
//    let v = UIStackView();
//    v.spacing = 2;
//    v.distribution = .fillEqually;
//
//
//    let btn = UIButton(type: .roundedRect);
//    btn.setTitle("YES", for: .normal)
//    //btn.setTitle("YES", for: .highlighted)
//    //btn.backgroundColor = .blue;
//    // btn.showsTouchWhenHighlighted = true;
//    btn.frame = CGRect(x: 0, y: 0, width: 80, height: 50);
//
//
//    let btn2 = UIButton(type: .roundedRect)
//    btn2.setTitle("NO", for: .normal);
//    // btn2.setTitle("NO", for: .highlighted)
//    //btn2.backgroundColor = .red;
//    //btn2.showsTouchWhenHighlighted = true;
//    btn2.frame = CGRect(x: 80, y: 0, width: 80, height: 50);
//
//    btn.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside);
//    btn2.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside);
//
//    v.addArrangedSubview(btn)
//    v.addArrangedSubview(btn2)
//
//    self.messageInputBar.topStackView.addArrangedSubview(v);
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
