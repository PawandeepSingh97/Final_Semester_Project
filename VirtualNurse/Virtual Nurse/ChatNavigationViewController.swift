//
//  ChatNavigationViewController.swift
//  VirtualNurse
//
//  Created by VongolaKillerAir on 26/12/17.
//  Copyright © 2017 TeamSurvivor. All rights reserved.
//

import UIKit

class ChatNavigationViewController: UINavigationController {

    var patient:Patient?;
    var cvc:ChatViewController?;
    
    private var imageview:UIImageView?;
    
    
    // define a variable to store initial touch position
    private var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        
        self.navigationItem.setHidesBackButton(true, animated: false);
        //SET BAR COLOR TO BLUE
        self.navigationBar.barTintColor = UIColor(red: 54, green: 150, blue: 247);
       
        //ENABLE TRANSITION
        slideUpTransition();
        
        //INSERT SLIDER IMAGE
        let image = UIImage(named: "slideChatMenu");
         imageview = UIImageView(image: image);
        imageview?.frame = CGRect(x: view.center.x, y: navigationBar.frame.size.height+20, width: 40, height: 40);
        imageview?.contentMode = .top;
        imageview?.isUserInteractionEnabled = true;

        //SET GESTURE TO IMAGE VIEW
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureRecognizerHandler(_:)));
        imageview?.addGestureRecognizer(panGesture);

        self.view.addSubview(imageview!);
        //imageview?.translatesAutoresizingMaskIntoConstraints = false;
        imageview?.translatesAutoresizingMaskIntoConstraints = false;
        
    //SET CONSTRAINT TO IMAGEVIEW
//
//
//
        let horConstraint = NSLayoutConstraint(item: imageview!, attribute: .centerX, relatedBy: .equal,toItem: view, attribute: .centerX,multiplier: 1.0, constant:0);
//
        let verConstraint = NSLayoutConstraint(item: imageview!, attribute: .top, relatedBy: .equal, toItem: navigationBar, attribute: .bottom, multiplier: 1, constant:0);
//
//

        view.addConstraints([horConstraint,verConstraint]);
        
        //DISPLAY CHAT
        cvc = ChatViewController();
        cvc?.patient = patient;
        self.pushViewController(cvc!, animated: true);
        
        
        // Do any additional setup after loading the view.
    }
    
    
    private func slideUpTransition() {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        self.view.layer.add(transition, forKey: kCATransition)
    }
    

    
    //GESTURE TO DETERMINE WHERE USER IS SLIDING
    @objc func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view?.window)
        
        if sender.state == UIGestureRecognizerState.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizerState.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height);
            }
        } else if sender.state == UIGestureRecognizerState.ended || sender.state == UIGestureRecognizerState.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

