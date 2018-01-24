//
//  PatientDialog.swift
//  VirtualNurse
//
//  Created by VongolaKillerAir on 4/1/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import UIKit


//HERE WILL STORE CONVERSATIONS REGARDING PATIENT
//E.G WHO IS THE PATIENT,PATIENT DOB,BMI,...
class PatientDialog: Dialog {
    
//TODO HAVE DIFFERENT DIALOGS
//TO HAVE DIFFERENT CONVERSATION,STORE CONVERSATION IN ARRAY AND RANDOMLY ACCESS THEM


    init(methodToCall:String,patient:Patient) {
        super.init(methodToCall: methodToCall)
        self.patient = patient;
    }
    
    override func getDialog() -> String {
        
        
        if patient == nil
        {
            return error();
        }
        
        switch self.dialog {
        case "Get":
          self.response =  getInformation();
        default:
         self.response =  error();
        }
        
        return response;
    }
    
    func getInformation() -> String
    {
        
        
        return "Hi,you are \(patient!.name)";
    }
    
    override func error() -> String {
        print("ERROR");
        return "error";
    }
    
}
