//
//  BaseTabBarViewController.swift
//  VirtualNurse
//
//  Created by VongolaKillerAir on 1/2/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import UIKit


protocol PatientDelegate {
    func getPatient() -> Patient;
}


class BaseTabBarViewController: UITabBarController {
    //create chat button here
    private let chatBtn = DesignableFloatingChatButton(type: .custom);
    var buttonOrigin : CGPoint = CGPoint(x: 0, y: 0);
    
    var patientDelegate: PatientDelegate?;
    
    var chatView = ChatNavigationViewController();
    //make sure pass patient data
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chatBtn.setImage(UIImage(named:"Nurse_Logo"), for:.normal);
        chatBtn.frame = CGRect(x: 300, y: 550, width: 75, height: 75);
        chatBtn.addBadgeToButon(badge: "1");
        view.addSubview(chatBtn);
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(buttonDrag(pan:)))
        self.chatBtn.addGestureRecognizer(gesture);
        
        chatBtn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside);
    }
    
    
    
    @objc func buttonAction(sender: UIButton!) {
        var patient = patientDelegate?.getPatient();
        chatView.patient = patient;
        present(chatView, animated: true, completion: nil)
    }
    
    @objc func buttonDrag(pan: UIPanGestureRecognizer) {
        if pan.state == .began {
            buttonOrigin = pan.location(in: chatBtn)
        }else {
            let location = pan.location(in: view) // get pan location
            
            //var topBar = self.navigationController?.navigationBar.frame.height
//            var bottomBar = self.tabBar.frame.height;
        
            chatBtn.frame.origin = CGPoint(x: location.x - buttonOrigin.x, y: location.y - buttonOrigin.y)
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
