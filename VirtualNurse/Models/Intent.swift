//
//  Intent.swift
//  VirtualNurse
//
//  Created by VongolaKillerAir on 13/12/17.
//  Copyright © 2017 TeamSurvivor. All rights reserved.
//

import UIKit

/*
 Class will store intent from LUIS query
 
 */
class Intent: NSObject {
    var intentName:String;
    var intentDialog:String;
    var intentEntities:[String];
    
    init(_ intentname:String,_ intentdialog:String,_ intententities:[String]) {
        self.intentName = intentname;
        self.intentDialog = intentdialog;
        self.intentEntities = intententities;
    }
    
    
    //PROCESS INTENT ??
    
    
    

}
