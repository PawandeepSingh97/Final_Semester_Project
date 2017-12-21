//
//  RestfulController.swift
//  VirtualNurse
//
//  Created by VongolaKillerAir on 30/11/17.
//  Copyright © 2017 TeamSurvivor. All rights reserved.
//

import Foundation

public class RestfulController
{
    public static let BaseUrl = "http://pawandeep-virtualnurse.azurewebsites.net";
    public static let ver:[String:String] = ["zumo-api-version": "2.0.0"];
    public static var restfulURL:String = "";
    
    
//    public static func getTodoItem() -> String
//    {
//        restfulURL = "\(BaseUrl)/tables/TodoItem";
//        return restfulURL;
//    }
    

    public static func UserEndPoint() -> String
    {
        restfulURL = "\(BaseUrl)/User";
        return restfulURL;
    }
    
    /*
     Since can access via the easy table default api
     and custom api , specify either calling endpoint from custom( means your own code) or table
     */
    public static func PatientEndPointBy(Type:String) -> String
    {
        if(Type == "custom")
        {
            restfulURL = "\(BaseUrl)/Patient";
            return restfulURL;
            
        }else
        {
            restfulURL = "\(BaseUrl)/tables/Patient";
            return restfulURL;
        }
        
        
    }
    
    
    public static func LUISEndPoint() -> String
    {
        restfulURL = "https://westus.api.cognitive.microsoft.com/luis/v2.0/apps/6d6b801b-472e-4f39-b85d-3e5f88cac15c?subscription-key=fc0d98628f84459bb6a52c18339a3068&verbose=true&timezoneOffset=0&q=";
        return restfulURL;
    }
    
}
