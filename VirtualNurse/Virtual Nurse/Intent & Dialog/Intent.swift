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
    var entities:[JSON]?;
    
    var dialog:String!;
    var topic:String!;
    
    init(_ intentname:String,_ intententities:[JSON]?) {
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
    

    /*
     Process the dates from the entities
     and return them as a entity class
     **/
    func processEntity() -> Entity?
    {
        
        if let en = entities //unwrapped
        {
            if en.count > 0 //check if got value
            {
                
                let entityFromUtterences = en[0]["entity"].string!;
                
                let values = en[0]["resolution"]["values"][0];
                let entityType = values["type"].string!;
                var entityValues:[String] = []; //stores the date
                if entityType == "date"
                {
                        entityValues.append(values["value"].string!)
                    
                }
                else if entityType == "daterange" {
                    
                    entityValues.append(values["start"].string!)
                    entityValues.append(values["end"].string!)
                }
                
            
                if entityValues.count == 2
                {
                    print("entity from utterence is \(entityFromUtterences), type is \(entityType) and value is start: \(entityValues[0]), end:\(entityValues[1])");
                    
                    
                }
                else if entityValues.count == 1
                {
                    print("entity from utterence is \(entityFromUtterences), type is \(entityType) and value is \(entityValues[0])");
                }
                
                return Entity(efu: entityFromUtterences, et: entityType, ev: entityValues);
                
            }
        }
        return nil
    }
    

}
