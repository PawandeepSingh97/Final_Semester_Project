//
//  Appointment.swift
//  VirtualNurse
//
//  Created by Mohamed Taufik on 31/12/17.
//  Copyright © 2017 TeamSurvivor. All rights reserved.
//

import Foundation

class Appointment
    
{
    var doctorName = ""
    var time = ""
    var date = ""
    
    init(_ doctorName: String, _ time: String, _ date: String)
    {
        self.doctorName = doctorName
        self.time = time
        self.date = date
        
    }
}
