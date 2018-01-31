//
//  LUISDataManager.swift
//  VirtualNurse
//
//  Created by VongolaKillerAir on 13/12/17.
//  Copyright © 2017 TeamSurvivor. All rights reserved.
//

import UIKit

class LUISDataManager: NSObject {

    /*
     Purpose : To query string and return intent and entities
     */
    public static func queryLUIS(query:String,onComplete:((_:Intent) -> Void)?)
    {
        
        
        let q  = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed);
        let url = "\(RestfulController.LUISEndPoint())\(q!)";
        
        HTTP.getJSON(url: url) { (json, response, error) in
            if error != nil
            {
                return
            }
            var result = json!;
            
            //get top scoring intent
            let itt = result["topScoringIntent"]["intent"].string!;
            let entities = result["entities"].array!;
            
            
//            if  let en = result["entities"].array {
//                //what was the entity in the utterenaces
//                let entitymentioned = en[0]["entity"].string!;
//                let entitytype = en[0]["type"].string!;
//                let entityvalue = en[0]["resolution"]["values"][0]["value"].string!;
//
//                print("*********************")
//                print("FROM LUIS")
//                print("UTTERENCE IS \(query)");
//                print("INTENT IS \(itt)")
//                print("ENTITY MENTIONED WAS \(entitymentioned), which is type of \(entitytype), and value is \(entityvalue) ");
//
//                print("*********************")
//            }
            
            
            let intent = Intent(itt,entities);
            onComplete?(intent);//once finish,return intent
            
        }
        
       // print(url);
    }
    
    
    
}
