//
//  Patient.swift
//  VirtualNurse
//
//  Created by VongolaKillerAir on 20/12/17.
//  Copyright © 2017 TeamSurvivor. All rights reserved.
//

import UIKit
class Patient: NSObject {
    
    //Good practice is in camelcase (first letter of word small case - e.g: firstName)
    var id:String;
    
    var NRIC:String;
    
    var name:String;
    
    //AGE , DUHHH
    var age:Int;
    
    var dateOfBirth:Date
    var race:String;
    var gender:String
    var bloodType:String;
    var height:Double;
    var weight:Double;
    
    var address:String;//maybe used as a struct instead
    var postalCode:Int;
    
    var telephoneNo:Int;
    var handphoneNo:Int;
    
    var illnessType:String;
    var allergies:String;
    var isSmoker:Bool;
    
    // is it possible to use NRIC as FK ?
    var nextOfKinID:String?;
    var medicationID:String?;

    
    
    
    init(_ id:String, _ nric:String,_ name:String,_ age:Int,
         _ dob:Date,_ race:String,_ gender:String, _ bloodtype:String,
         _ height:Double,_ weight:Double,_ address:String, _ postalCode:Int,
         _ telno:Int,_ hpno:Int,_ illnesstype:String,_ allergies:String,_ issmoker:Bool,
         _ nokID:String?, _ medID:String?)
    {
        self.id = id;
        
        self.NRIC = nric;
        self.name = name;
        self.age = age;
        
        self.dateOfBirth = dob;
        self.race = race;
        self.gender = gender;
        self.bloodType = bloodtype
        self.height = height;
        self.weight = weight;
        
        self.address = address;
        self.postalCode = postalCode;
        
        self.telephoneNo = telno;
        self.handphoneNo = hpno;
        
        self.illnessType = illnesstype;
        self.allergies = allergies;
        self.isSmoker = issmoker;
        
        self.nextOfKinID = nokID;
        self.medicationID = medID;
        
    }
}
