//
//  PatientDataManager.swift
//  VirtualNurse
//
//  Created by VongolaKillerAir on 22/12/17.
//  Copyright © 2017 TeamSurvivor. All rights reserved.
//

import UIKit
import Alamofire

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

    
    //Declare a var to store the JSON response
    var jsonResponse:JSON = []
    
    //Declaring and Initialising HTTP headers
    let headers: HTTPHeaders = [
        "Content-Type": "application/json",
        "Accept": "application/json",
        "ZUMO-API-VERSION": "2.0.0"
    ]
    
    //Declaring and Initialising appointment URL of Microsoft Azure database
    let url:String = "http://pawandeep-virtualnurse.azurewebsites.net/tables/Patient"
    
    
    func getPatientByNRIC( _ patientNric:String, onComplete:((_ Patient: Patient) -> Void)?) {
        
        //Filtered PatientNric
        let filteredPatientNric = "nric eq '\(patientNric)'"
        //Encode the patientNric
        let encodedPatientNric = filteredPatientNric.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        //Encoded Url
        let encodedUrl = "\(url)?$filter=\(encodedPatientNric!)"
        
        //Get request
        Alamofire.request(encodedUrl, headers: headers).responseJSON { (responseObject) -> Void in
            
            if responseObject.result.isSuccess {
                
                
                let responseJson = JSON(responseObject.result.value!)
                
                //Check if responseJson is empty
                if responseJson != []{
                    print("RESPONSE JSON\(responseJson)")
                    //Extract Json
                    
                    print(" result value\(responseJson.count)")
                    
                    for i in 0..<(responseJson.count){
                        
                        let id = responseJson[i]["id"].string!;
                        let nric = responseJson[i]["nric"].string!;
                        let name = responseJson[i]["name"].string!;
                        let dob = responseJson[i]["dob"].string!;
                        let age = responseJson[i]["age"].int!;
                        let race = responseJson[i]["race"].string!;
                        let gender = responseJson[i]["gender"].string!;
                        let bloodtype = responseJson[i]["bloodType"].string!;
                        let height = responseJson[i]["height"].double!;
                        let weight = responseJson[i]["weight"].double!;
                        let address = responseJson[i]["address"].string!;
                        let postalcode = responseJson[i]["postalCode"].int!;
                        let telno = responseJson[i]["telNo"].int!;
                        let hpno = responseJson[i]["handphoneNo"].int!;
                        let illnesstype = responseJson[i]["illnessType"].string!;
                        let allergies = responseJson[i]["allergies"].string!;
                        let issmoker = responseJson[i]["isSmoker"].bool!;
                        let nokid = responseJson[i]["nokID"].string!;
                        let medicationid = responseJson[i]["medicationID"].string!;
                        
                        //convert string to date
                        let dateFor: DateFormatter = DateFormatter()
                        dateFor.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                        let DOB = dateFor.date(from: dob)!;
                        let calendar = Calendar.current
                        let components = calendar.dateComponents([.year, .month, .day, .hour], from: DOB)
                        let finalDate = calendar.date(from:components);
                        
                        print("patient1 \(id)")
                        print("patient1 \(nric)")
                        print("patient1 \(name)")
                        
                        let patient = Patient(id, nric, name, age, finalDate!, race, gender, bloodtype, height, weight, address, postalcode, telno, hpno, illnesstype, allergies,issmoker, nokid, medicationid);
                        onComplete?(patient)
                    }
                    
                    
                    
                }
                
                
            }
            
        }
    }

}
