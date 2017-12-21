//
//  User.swift
//  VirtualNurse
//
//  Created by VongolaKillerAir on 20/12/17.
//  Copyright © 2017 TeamSurvivor. All rights reserved.
//

import UIKit

/*
 Class used to handle login authentication
 */
class User: NSObject
{
    let username:String;//username is NRIC
    let password:String;
    
     init(_ username:String,_ password:String) {
        self.username = username;
        self.password = password;
    }
}
