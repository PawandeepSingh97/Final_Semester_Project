//
//  MonitoringController.swift
//  VirtualNurse
//
//  Created by Mohamed Imran on 21/1/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import Foundation
import Alamofire

class MonitoringController{
    
    func sumbitMonitoringValues(patient:Patient ,monitoringName:String,monitoringValue:Int)->Int{
        //Retrive patient nric and today's date
        let todayDate:String = helperClass().getTodayDate()
        let patientNric:String = patient.NRIC
        
        //Call the getFilteredMonitoringRecords in MonitoringDataManager to retrieve specific id in the monitoring records
        MonitoringDataManager().getFilteredMonitoringRecords(todayDate, patient) { (monitoring) in
            
            //Retrieved results from Database
            let retrievedPatientNric = monitoring.nric
            let retrievedDateCreated = monitoring.dateCreated
            
            //If record exists in database
            if (retrievedPatientNric == patientNric && retrievedDateCreated == todayDate){
                print("record exists")
                
                //Get the azure table unique id
                let azureTableId = monitoring.id
                
                //Declare updated parameters
                let updatedParameters: Parameters = [
                    monitoringName: monitoringValue,
                    ]
                
                //Update the cholesterol in the monitoring record
                MonitoringDataManager().patchMonitoringRecord(patient,azureTableId,updatedParameters, success: { (success) in
                    print(success)
                }) { (error) in
                    print(error)
                }
                
            
            }
        }
        
        return monitoringValue
    }
    
    //Check if monitoring record exists if not create one
    func checkIfRecordExists(patient: Patient, onComplete:((_ Monitoring: Monitoring) -> Void)?){
        
        let todayDate:String = helperClass().getTodayDate()
        let patientNric:String = patient.NRIC
        
        //Call the getFilteredMonitoringRecords in MonitoringDataManager to retrieve monitoring records
        MonitoringDataManager().getFilteredMonitoringRecords(todayDate, patient) { (monitoring) in
            //Retrieved results from Database
            let retrievedPatientNric = monitoring.nric
            let retrievedDateCreated = monitoring.dateCreated
            
            //If record exists in database
            if (retrievedPatientNric == patientNric && retrievedDateCreated == todayDate){
                print("record exists")
                
                onComplete?(monitoring)
            }
        }
        
    }
    
    
}
