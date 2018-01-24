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
    
    func sumbitMonitoringValues(monitoringName:String,monitoringValue:Int)->Int{
        //Retrive patient nric and today's date
        let todayDate:String = helperClass().getTodayDate()
        let patientNric:String = helperClass().getPatientNric()
        
        //Call the getFilteredMonitoringRecords in MonitoringDataManager to retrieve specific id in the monitoring records
        MonitoringDataManager().getFilteredMonitoringRecords(todayDate, patientNric) { (monitoring) in
            
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
                MonitoringDataManager().patchMonitoringRecord(azureTableId,updatedParameters, success: { (success) in
                    print(success)
                }) { (error) in
                    print(error)
                }
                
            
            }
        }
        
        return monitoringValue
    }
    
    //Check if monitoring record exists if not create one
    func checkIfRecordExists(onComplete:((_ Monitoring: Monitoring) -> Void)?){
        
        let todayDate:String = helperClass().getTodayDate()
        let patientNric:String = helperClass().getPatientNric()
        
        //Call the getFilteredMonitoringRecords in MonitoringDataManager to retrieve monitoring records
        MonitoringDataManager().getFilteredMonitoringRecords(todayDate, patientNric) { (monitoring) in
            //Retrieved results from Database
            let retrievedPatientNric = monitoring.nric
            let retrievedDateCreated = monitoring.dateCreated
            
            //If record exists in database
            if (retrievedPatientNric == patientNric && retrievedDateCreated == todayDate){
                print("record exists")
                
                  //Virtual NurseLogic
//                //Check if monitored, if monitored change from default logo to tick logo
//                if (monitoring.systolicBloodPressure != 0){
//                    self.monitoringImages[0] = self.monitoredTicks[0]
//                }
//                if (monitoring.glucose != 0){
//                    self.monitoringImages[1] = self.monitoredTicks[1]
//                }
//                if (monitoring.heartRate != 0){
//                    self.monitoringImages[2] = self.monitoredTicks[2]
//                }
//                if (monitoring.cigsPerDay != -1){
//                    self.monitoringImages[3] = self.monitoredTicks[3]
//                }
//                if (monitoring.bmi != 0){
//                    self.monitoringImages[4] = self.monitoredTicks[4]
//                }
//                if (monitoring.totalCholesterol != 0){
//                    self.monitoringImages[5] = self.monitoredTicks[5]
//                }

                onComplete?(monitoring)
            }
        }
        
    }
    
    
}
