//
//  UserDataManager.swift
//  VirtualNurse
//
//  Created by VongolaKillerAir on 20/12/17.
//  Copyright © 2017 TeamSurvivor. All rights reserved.
//

import Foundation

class UserDataManager: NSObject {
    
    
    /**
     Check if user exits
    //if user exists,Call PatientDataManager to get Patient based on NRIC
     */
    static func getUser(user:User,
                 onComplete:((_ isUser: Bool) -> Void)?)
    {
        let username = user.username.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!;
        let password = user.password.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!;
        let url = "\(RestfulController.UserEndPoint())/\(username)&\(password)";
        
        print(url);
        
        HTTP.getJSON(url: url) {
            (json, response, err) in
            
            if err != nil
            {
                return ;
            }
            
            let user = json!;
            
            if user["isUser"].int == 0
            {
                onComplete?(false);
            }
            else if user["isUser"].int == 1
            {
                onComplete?(true);
            }
            
        }
        
    }//end method
    
}//end class
