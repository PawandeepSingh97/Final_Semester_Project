//
//  AppointmentDialog.swift
//  VirtualNurse
//
//  Created by VongolaKillerAir on 10/1/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import UIKit

class AppointmentDialog:Dialog {
    
    //var Appointment
    init(methodToCall:String,patient:Patient) {
        super.init(methodToCall: methodToCall)
        self.patient = patient;
    }
    
    override func getDialog() -> String {
        switch self.dialog {
        case "Get":
            self.response =  getAppointment(by: Date());
        default:
            self.response =  error();
        }
        
        return response;
    }
    
    func getAppointment(by:Date) -> String {
        return "Your appointment is in test";
    }
    

}
