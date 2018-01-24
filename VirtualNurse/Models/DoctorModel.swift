//
//  DoctorModel.swift
//  VirtualNurse
//
//  Created by Mohamed Taufik on 9/1/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import UIKit

class DoctorModel: NSObject {

    var id: String;
    var patientName: String;
    var patientNric: String;
    var doctorName: String;
    var date: String;
    var time: String;
    var doctorSpeciality: String;
    
    
    
    init(_ id:String,_ patientName:String,_ patientNric:String, _ doctorName:String,_ date:String,
         _ time:String, _ doctorSpeciality:String)
    {
        self.id = id;
        self.patientName = patientName;
        self.patientNric = patientNric;
        self.doctorName = doctorName;
        self.date = date;
        self.time = time;
        self.doctorSpeciality = doctorSpeciality;
        
    }
}
