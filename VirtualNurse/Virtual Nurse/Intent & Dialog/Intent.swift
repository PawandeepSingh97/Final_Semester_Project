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
    var name:String;
    var entities:[JSON];
    
    var dialog:String!;
    var topic:String!;
    
    init(_ intentname:String,_ intententities:[JSON]) {
        self.name = intentname;
        self.entities = intententities;
    }
    
    
    //PROCESS INTENT
    //This will determine,which dialog and topic the intent is
     func processIntent()
    {
        var strings = name.components(separatedBy: ".");
        topic = strings[0];
        
        if strings.count == 1
        {
            dialog = "";
        }else
        {
                dialog = strings[1];
        }
        
        
        
        //Do switch case here to pass or in a vc ??
    }
    
    

}
