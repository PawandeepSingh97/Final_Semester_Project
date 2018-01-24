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
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.navigationBar.barTintColor = UIColor(red: 54, green: 150, blue: 247);
       
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        self.view.layer.add(transition, forKey: kCATransition)
        
        
        let image = UIImage(named: "slideChatMenu");
        
        let imageview = UIImageView(image: image);
        imageview.frame = CGRect(x: view.center.x, y: navigationBar.frame.size.height+20, width: 20, height: 20);
        
        
        imageview.contentMode = .top;
        imageview.isUserInteractionEnabled = true;
        
      //  let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.connected(_:)))
        
        //imageview.addGestureRecognizer(tapGestureRecognizer)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureRecognizerHandler(_:)));
        
        imageview.addGestureRecognizer(panGesture);
       
        
        //imageview.addGe
        imageview.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.view.addSubview(imageview);
//        imageview.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        imageview.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        imageview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        imageview.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true;
        
        
        
        
        let horConstraint = NSLayoutConstraint(item: imageview, attribute: .centerX, relatedBy: .equal,
                                               toItem: navigationBar, attribute: .centerX,
                                               multiplier: 1.0, constant: 0.0);
//        
        let yConstraint = NSLayoutConstraint(item: imageview, attribute: .centerY, relatedBy: .equal, toItem: navigationBar, attribute: .centerY, multiplier: 1, constant: navigationBar.frame.size.height-5);
        
        // Get the superview's layout
        //let margins = view.layoutMarginsGuide
        //imageview.topAnchor.constraint(equalTo: navigationBar.centerYAnchor, constant: navigationBar.frame.size.height+20);
        
        
        
        
        //NSLayoutConstraint.activate([horConstraint,yConstraint])
        view.addConstraints([horConstraint,yConstraint])
        //.addConstraints([horConstraint,yConstraint])
        
        let cvc = ChatViewController();
        cvc.patient = patient;
        self.pushViewController(cvc, animated: true);
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @objc func connected(_ sender:AnyObject){
        
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFromTop
        transition.subtype = kCATransitionFade;
        self.view.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: true, completion: nil);
        
    }
    
    
    // define a variable to store initial touch position
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    
    @objc func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view?.window)
        
        if sender.state == UIGestureRecognizerState.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizerState.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizerState.ended || sender.state == UIGestureRecognizerState.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

