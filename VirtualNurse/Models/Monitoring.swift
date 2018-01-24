//
//  Monitoring.swift
//  VirtualNurse
//
//  Created by Mohamed Imran on 4/1/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import UIKit

class Monitoring: NSObject {
    
    //Declaring of variables
    var id:String
    var nric:String
    var name:String
    var gender:String
    var age:Int
    var education:String
    var currentSmoker:Bool
    var cigsPerDay:Int
    var bpMedicine:Bool
    var prevalentStroke:Bool
    var prevalentHypertension:Bool
    var diabetes:Bool
    var totalCholesterol:Int
    var systolicBloodPressure:Double
    var diastolicBloodPressure:Double
    var bmi:Double
    var heartRate:Double
    var glucose:Int
    var tenYearCHD:Bool
    var dateCreated:String
    
        
    //Declaring constructor
    init(_ id:String, _ nric:String, _ name:String, _ gender:String, _ age:Int, _ education:String, _ currentSmoker:Bool, _ cigsPerDay:Int, _ bpMedicine:Bool, _ prevalentStroke:Bool, _ prevalentHypertension:Bool, _ diabetes:Bool, _ totalCholesterol:Int, _ systolicBloodPressure:Double, _ diastolicBloodPressure:Double, _ bmi:Double, _ heartRate:Double, _ glucose:Int, _ tenYearCHD:Bool, _ dateCreated:String)
    {
        self.id = id
        self.nric = nric
        self.name = name
        self.gender = gender
        self.age = age
        self.education = education
        self.currentSmoker = currentSmoker
        self.cigsPerDay = cigsPerDay
        self.bpMedicine = bpMedicine
        self.prevalentStroke = prevalentStroke
        self.prevalentHypertension = prevalentHypertension
        self.diabetes = diabetes
        self.totalCholesterol = totalCholesterol
        self.systolicBloodPressure = systolicBloodPressure
        self.diastolicBloodPressure = diastolicBloodPressure
        self.bmi = bmi
        self.heartRate = heartRate
        self.glucose = glucose
        self.tenYearCHD = tenYearCHD
        self.dateCreated = dateCreated
    }
  
    
    
    
    
    

}



