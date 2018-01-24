//
//  Dialog.swift
//  VirtualNurse
//
//  Created by VongolaKillerAir on 10/1/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import Foundation

class Dialog:NSObject
{
    var patient:Patient?;
    
    var dialog:String;
    var response:String = "";
    var entities:[JSON]?;
    
    init(methodToCall:String){
        self.dialog = methodToCall;
    }
    
    open func getDialog() -> String
    {
        response = "error";
        return response;
    }
    
    //HANDLE ERROR BY CREATING AN ERROR DIALOG
    open func error() -> String {
        print("ERROR");
        return "error";
    }
}
