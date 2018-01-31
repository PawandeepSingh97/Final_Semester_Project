//
//  ReminderModel.swift
//  mediTrack
//
//  Created by SURA's MacBookAir on 30/1/18.
//  Copyright © 2018 SURA's MacBookAir. All rights reserved.
//

import Foundation

class ReminderModel {
    
    
    var id : String;
    var medicineName : String = ""
    var isEnabled : Bool
    var morningTime : String = ""
    var afternoonTime : String = ""
    var eveningTime : String = ""
    

    init(_ id : String,_ medicineName : String,_ isEnabled : Bool,_ morningTime : String, afternoonTime : String, eveningTime : String) {
        
        self.id = id
        self.medicineName = medicineName
        self.isEnabled = isEnabled
        self.morningTime = morningTime
        self.afternoonTime = afternoonTime
        self.eveningTime = eveningTime
    }
    
}
