//
//  PatientDataManager.swift
//  VirtualNurse
//
//  Created by VongolaKillerAir on 22/12/17.
//  Copyright © 2017 TeamSurvivor. All rights reserved.
//

import UIKit


//HANDLES PATIENT DATA FROM DB


class PatientDataManager: NSObject {
    
    static func getPatientBy(NRIC:String,
                              onComplete:((_ Patient: Patient) -> Void)?)
    {
        let nric = NRIC.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!;
        let url = "\(RestfulController.PatientEndPointBy(Type: "custom"))/\(nric)";
        
        HTTP.getJSON(url: url) { (json, response, err) in
            
            if err != nil
            {
                return;
            }
            
            let pt = json!;
            if pt != JSON.null
            {
                print(pt);
                let id = pt["id"].string!;
                let nric = pt["nric"].string!;
                let name = pt["name"].string!;
                let dob = pt["dob"].string!;
                let age = pt["age"].int!;
                let race = pt["race"].string!;
                let gender = pt["gender"].string!;
                let bloodtype = pt["bloodType"].string!;
                let height = pt["height"].double!;
                let weight = pt["weight"].double!;
                let address = pt["address"].string!;
                let postalcode = pt["postalCode"].int!;
                let telno = pt["telNo"].int!;
                let hpno = pt["handphoneNo"].int!;
                let illnesstype = pt["illnessType"].string!;
                let allergies = pt["allergies"].string!;
                let issmoker = pt["isSmoker"].bool!;
                let nokid = pt["nokID"].string!;
                let medicationid = pt["medicationID"].string!;
                
                //convert string to date
                let dateFor: DateFormatter = DateFormatter()
                dateFor.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                let DOB = dateFor.date(from: dob)!;
                let calendar = Calendar.current
                let components = calendar.dateComponents([.year, .month, .day, .hour], from: DOB)
                let finalDate = calendar.date(from:components);
                
                let patient = Patient(id, nric, name, age, finalDate!, race, gender, bloodtype, height, weight, address, postalcode, telno, hpno, illnesstype, allergies,issmoker, nokid, medicationid);
                
                onComplete?(patient);
                
            }else
            {
                
                print("error");
            }
        }
        
    }

}
