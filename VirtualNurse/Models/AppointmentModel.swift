//
//  Appointment.swift
//  VirtualNurse
//
//  Created by Mohamed Taufik on 4/1/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import UIKit

class AppointmentModel: NSObject {

    var id: String;
    var nric: String;
    var doctorName: String;
    var date: String;
    var time: String
    
    
    
    init(_ id:String,_ nric:String, _ doctorName:String,_ date:String,
         _ time:String)
    {
        self.id = id;
        self.nric = nric;
        self.doctorName = doctorName;
        self.date = date;
        self.time = time;
       
        
    }
}
