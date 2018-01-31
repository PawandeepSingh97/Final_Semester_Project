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


    init(dialogToCall:String,patient:Patient) {
        super.init(dialogToCall: dialogToCall)
        self.patient = patient;
    }
    
}
