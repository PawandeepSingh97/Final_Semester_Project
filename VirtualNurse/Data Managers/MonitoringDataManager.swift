//
//  MonitoringDataManager.swift
//  VirtualNurse
//
//  Created by Mohamed Imran on 31/12/17.
//  Copyright © 2017 TeamSurvivor. All rights reserved.
//

import Foundation
import Alamofire

class MonitoringDataManager: NSObject{
    
    //Declaring and Initialising HTTP headers
    let headers: HTTPHeaders = [
        "Content-Type": "application/json",
        "Accept": "application/json",
        "ZUMO-API-VERSION": "2.0.0"
    ]
    
    //Declaring and Initialising URL of Microsoft Azure monitoring database
    let url:String = "http://pawandeep-virtualnurse.azurewebsites.net/tables/Monitoring"
    
    //Declare default parameters
    let parameters: Parameters = [
        "nric": "S9822477G",
        "name": "Imran",
        "gender": "male",
        "age": 48,
        "education": "1",
        "currentSmoker": true,
        "cigsPerDay": -1,
        "bpMedicine": false,
        "prevalentStroke": false,
        "prevalentHypertension": true,
        "diabetes": true,
        "totalCholesterol": 0,
        "systolicBloodPressure": 0,
        "diastolicBloodPressure": 0,
        "bmi": 0,
        "heartRate": 0,
        "glucose": 0,
        "tenYearCHD": false,
        "dateCreated": HomeDashboardViewController().getTodayDate()
    ]
    
    
    
    //Returns all records in monitoring table based on dateCreated and nric
    func getFilteredMonitoringRecords(_ todayDate: String, _ patientNric:String, onComplete:((_ Monitoring: Monitoring) -> Void)?) {
        
        //Filter todayDate
        let filteredTodayDate = "dateCreated eq '\(todayDate)'"
        //Encode the todayDate
        let encodedTodayDate = filteredTodayDate.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        //Filtered PatientNric
        let filteredPatientNric = "and nric eq '\(patientNric)'"
        //Encode the patientNric
        let encodedPatientNric = filteredPatientNric.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        //Encoded Url
        let encodedUrl = "\(url)?$filter=\(encodedTodayDate!)\(encodedPatientNric!)"
        
        //Get request
        Alamofire.request(encodedUrl, headers: headers).responseJSON { (responseObject) -> Void in
            //print(responseObject)
            if responseObject.result.isSuccess {
                let responseJson = JSON(responseObject.result.value!)
                
                //Check if responseJson is empty
                if responseJson != []{
                    //Extract Json
                    let id = responseJson[0]["id"].string!
                    let nric = responseJson[0]["nric"].string!
                    let name = responseJson[0]["name"].string!
                    let gender = responseJson[0]["gender"].string!
                    let age = responseJson[0]["age"].int!
                    let education = responseJson[0]["education"].string!
                    let currentSmoker = responseJson[0]["currentSmoker"].bool!
                    let cigsPerDay = responseJson[0]["cigsPerDay"].int!
                    let bpMedicine = responseJson[0]["bpMedicine"].bool!
                    let prevalentStroke = responseJson[0]["prevalentStroke"].bool!
                    let prevalentHypertension = responseJson[0]["prevalentHypertension"].bool!
                    let diabetes = responseJson[0]["diabetes"].bool!
                    let totalCholesterol = responseJson[0]["totalCholesterol"].int!
                    let systolicBloodPressure = responseJson[0]["systolicBloodPressure"].double!
                    let diastolicBloodPressure = responseJson[0]["diastolicBloodPressure"].double!
                    let bmi = responseJson[0]["bmi"].double!
                    let heartRate = responseJson[0]["heartRate"].double!
                    let glucose = responseJson[0]["glucose"].int!
                    let tenYearCHD = responseJson[0]["tenYearCHD"].bool!
                    let dateCreated = responseJson[0]["dateCreated"].string!
    
                   
                    let monitoring = Monitoring(id,nric,name,gender,age,education,currentSmoker,cigsPerDay,bpMedicine,prevalentStroke,prevalentHypertension,diabetes,totalCholesterol,systolicBloodPressure,diastolicBloodPressure,bmi,heartRate,glucose,tenYearCHD,dateCreated);
                    print("retrieved")
                    onComplete?(monitoring)
                    }
                    //success(responseJson)
                  else{
                    print("Error no records created")
                    print("Created default records")
                

                    //If No records create new default records
                    self.postMonitoringRecord(success: { (JSONResponse) in

                        if (JSONResponse != []){
                        //Convert to Json
                        let responseJson = JSON(JSONResponse)

                        //Extract Json
                        let id = responseJson["id"].string!
                        let nric = responseJson["nric"].string!
                        let name = responseJson["name"].string!
                        let gender = responseJson["gender"].string!
                        let age = responseJson["age"].int!
                        let education = responseJson["education"].string!
                        let currentSmoker = responseJson["currentSmoker"].bool!
                        let cigsPerDay = responseJson["cigsPerDay"].int!
                        let bpMedicine = responseJson["bpMedicine"].bool!
                        let prevalentStroke = responseJson["prevalentStroke"].bool!
                        let prevalentHypertension = responseJson["prevalentHypertension"].bool!
                        let diabetes = responseJson["diabetes"].bool!
                        let totalCholesterol = responseJson["totalCholesterol"].int!
                        let systolicBloodPressure = responseJson["systolicBloodPressure"].double!
                        let diastolicBloodPressure = responseJson["diastolicBloodPressure"].double!
                        let bmi = responseJson["bmi"].double!
                        let heartRate = responseJson["heartRate"].double!
                        let glucose = responseJson["glucose"].int!
                        let tenYearCHD = responseJson["tenYearCHD"].bool!
                        let dateCreated = responseJson["dateCreated"].string!

                      
                        let monitoring = Monitoring(id,nric,name,gender,age,education,currentSmoker,cigsPerDay,bpMedicine,prevalentStroke,prevalentHypertension,diabetes,totalCholesterol,systolicBloodPressure,diastolicBloodPressure,bmi,heartRate,glucose,tenYearCHD,dateCreated);
                        onComplete?(monitoring)

                    }
                    else{
                            
                    }

                    }, failure: { (error) in
                        //print(error)
                    })
                    
                }
            }
            
        }
    }
    
    //Post a monitoring record
    func postMonitoringRecord(success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
       
        //Post Request
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            
            //print(responseObject)
            
            //If results returns success
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            //If results returns failure
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
    
    //Update a monitoring record
    func patchMonitoringRecord(_ azureTableId: String, _ parameters: Parameters, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        
        //Update the url by passing the azureTableId
        let updatedUrl = "\(url)/\(azureTableId)"
        
        //Patch Request
        Alamofire.request(updatedUrl, method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            
            //print(responseObject)
            
            //If results returns success
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            //If results returns success
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
    
    //Returns all records in monitoring table based on dateCreated and nric
    func getFilteredMonitoringRecordsBasedOnDate(_ todayDate: String, _ endDate: String, _ patientNric:String, onComplete:((_ Monitoring: Monitoring) -> Void)?) {
        
        print(todayDate)
        print(endDate)
        //Filter todayDate
        let filteredTodayDate = "dateCreated le '\(endDate)'"
        
        
        //Encode the todayDate
        let encodedTodayDate = filteredTodayDate.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        //Filtered PatientNric
        let filteredPatientNric = "and nric eq '\(patientNric)'"
        //Encode the patientNric
        let encodedPatientNric = filteredPatientNric.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        //Encoded Url
        let encodedUrl = "\(url)?$filter=\(encodedTodayDate!)\(encodedPatientNric!)"
        
        print("getFilteredMonitoringRecordsBasedOnDate\(encodedUrl)")
        
        //Get request
        Alamofire.request(encodedUrl, headers: headers).responseJSON { (responseObject) -> Void in
            //print(responseObject)
            if responseObject.result.isSuccess {
                let responseJson = JSON(responseObject.result.value!)
                //Check if responseJson is empty
                if responseJson != []{
                    
                    for i in 0..<(responseJson.count){
                    
                    //Extract Json
                    let id = responseJson[i]["id"].string!
                    let nric = responseJson[i]["nric"].string!
                    let name = responseJson[i]["name"].string!
                    let gender = responseJson[i]["gender"].string!
                    let age = responseJson[i]["age"].int!
                    let education = responseJson[i]["education"].string!
                    let currentSmoker = responseJson[i]["currentSmoker"].bool!
                    let cigsPerDay = responseJson[i]["cigsPerDay"].int!
                    let bpMedicine = responseJson[i]["bpMedicine"].bool!
                    let prevalentStroke = responseJson[i]["prevalentStroke"].bool!
                    let prevalentHypertension = responseJson[i]["prevalentHypertension"].bool!
                    let diabetes = responseJson[i]["diabetes"].bool!
                    let totalCholesterol = responseJson[i]["totalCholesterol"].int!
                    let systolicBloodPressure = responseJson[i]["systolicBloodPressure"].double!
                    let diastolicBloodPressure = responseJson[i]["diastolicBloodPressure"].double!
                    let bmi = responseJson[i]["bmi"].double!
                    let heartRate = responseJson[i]["heartRate"].double!
                    let glucose = responseJson[i]["glucose"].int!
                    let tenYearCHD = responseJson[i]["tenYearCHD"].bool!
                    let dateCreated = responseJson[i]["dateCreated"].string!
                    
                    
                    let monitoring = Monitoring(id,nric,name,gender,age,education,currentSmoker,cigsPerDay,bpMedicine,prevalentStroke,prevalentHypertension,diabetes,totalCholesterol,systolicBloodPressure,diastolicBloodPressure,bmi,heartRate,glucose,tenYearCHD,dateCreated);
                    print("retrieved filtered Date")
                    onComplete?(monitoring)
                }
                    //success(responseJson)
                    
                }//end for loo[
                
            }
            
        }
    }
    
    
    
   
}

