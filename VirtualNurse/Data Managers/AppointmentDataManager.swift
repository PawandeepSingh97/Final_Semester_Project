//
//  AppointmentDataManager.swift
//  VirtualNurse
//
//  Created by Mohamed Taufik on 4/1/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class AppointmentDataManager: NSObject {

    var appointmentArray = [AnyObject]()
    
    //Declare a var to store the JSON response
    var jsonResponse:JSON = []
    
    //Declaring and Initialising HTTP headers
    let headers: HTTPHeaders = [
        "Content-Type": "application/json",
        "Accept": "application/json",
        "ZUMO-API-VERSION": "2.0.0"
    ]
    
    //Declaring and Initialising appointment URL of Microsoft Azure database
    let url:String = "http://pawandeep-virtualnurse.azurewebsites.net/tables/Appointment"
    
    //Declaring and Initialising doctor URL of Microsoft Azure database
    let url2:String = "http://pawandeep-virtualnurse.azurewebsites.net/tables/Doctor"
    
    //Declaring and Initialising Microsoft Azure table unique id
    //let azureTableId:String = "a55c6e5a-5b65-483f-9886-543f6d1e8702"
    
    //Returns all records in appoinement table based on nric
    func getAppointmentByNRIC( _ patientNric:String, onComplete:((_ AppointmentModel: AppointmentModel) -> Void)?) {
        
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
                        
                        let id = responseJson[i]["id"].string!
                        let nric = responseJson[i]["nric"].string!
                        let doctorName = responseJson[i]["doctorName"].string!
                        let date = responseJson[i]["date"].string!
                        let time = responseJson[i]["Time"].string!
                        
                        print("doctor name1 \(nric)")
                        print("nric1 \(doctorName)")
                        print("date1 \(date)")
                        print("time1 \(time)")
                        
                        
                        
                        let Appointment = AppointmentModel(id,nric,doctorName,date,time);
                        onComplete?(Appointment)
                    }
                    
                   
                    
                }
            

            }
            
        }
    }
    
    //Post a appointment record
    func postAppointmentRecord(_ parameters: Parameters, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        
        
        //Post Request
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            
            //print(responseObject)
            
            //If results returns success
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
    
    //Patch a appointment record
    func patchAppointmentRecord(_ azureTableId: String, _ parameters: Parameters, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        
        let URL = "\(url)/\(azureTableId)"
        //Post Request
        Alamofire.request(URL, method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            
            //print(responseObject)
            
            //If results returns success
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
    
    //Returns all records in appointment table based on date and time
    func getAppointmentByDateTime( _ date: String, _ time:String ,onComplete:((_ AppointmentModel: AppointmentModel) -> Void)?) {
        
        //
        let filteredPatientDate = "date eq '\(date)' and time eq '\(time)'"
        //
        let encodedPatientDate = filteredPatientDate.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        //Encoded Url
        let encodedUrl = "\(url)?$filter=\(encodedPatientDate!)"
        
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
                        
                        let id = responseJson[i]["id"].string!
                        let nric = responseJson[i]["nric"].string!
                        let doctorName = responseJson[i]["doctorName"].string!
                        let date = responseJson[i]["date"].string!
                        let time = responseJson[i]["Time"].string!
                        
                        print("doctor name1 \(nric)")
                        print("nric1 \(doctorName)")
                        print("date1 \(date)")
                        print("time1 \(time)")

                        let Appointment = AppointmentModel(id,nric,doctorName,date,time);
                        onComplete?(Appointment)
                    }
                    
                    
                    
                }
                
                
            }
            
        }
    }
    
    //Delete a appointment record
    func DeleteAppointmentRecord(_ azureTableId: String, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        
        let URL = "\(url)/\(azureTableId)"
        //Post Request
        Alamofire.request(URL, method: .delete , encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            
            //print(responseObject)
            
            //If results returns success
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
    
    //Returns all records in appoinement table based on nric and name
    func getDoctorIDByNameNric( _ patientNric:String, _ patientName:String, _ doctorName:String, onComplete:((_ DoctorModel: DoctorModel) -> Void)?) {
        
        

        let filteredDoctor = "patientNric eq '\(patientNric)' and patientName eq '\(patientName)' and doctorName eq '\(doctorName)'"
        
        let encodedfilteredDoctor = filteredDoctor.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        //Encoded Url
        let encodedUrl = "\(url2)?$filter=\(encodedfilteredDoctor!)"

        
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
                        
                        let id = responseJson[i]["id"].string!
                        let patientNric = responseJson[i]["patientNric"].string!
                        let patientName = responseJson[i]["patientName"].string!
                        let doctorName = responseJson[i]["doctorName"].string!
                        let date = responseJson[i]["date"].string!
                        let time = responseJson[i]["time"].string!
                        let doctorSpeciality = responseJson[i]["doctorSpeciality"].string!
                        
                        let Doctor = DoctorModel(id,patientNric,patientName,doctorName,date,time,doctorSpeciality);
                        onComplete?(Doctor)
                    }
                    
                    
                    
                }
                
                
            }
            
        }
    }
    
    //Patch a doctor record
    func patchDoctorRecord(_ azureTableId: String, _ parameters: Parameters, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        
        let URL = "\(url2)/\(azureTableId)"
        //Post Request
        Alamofire.request(URL, method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            
            //print(responseObject)
            
            //If results returns success
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
    
    
    
    //Returns time records in appoinement table based on doctor and date
    func getTimeByDoctorDate( _ doctorName:String, _ date:String , onComplete:((_ AppointmentModel: AppointmentModel) -> Void)?) {
        
        //Filtered time
        let filteredTime = "doctorName eq '\(doctorName)' and date eq '\(date)'"
        //Encode the time
        let encodedTime = filteredTime.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        //Encoded Url
        let encodedUrl = "\(url)?$filter=\(encodedTime!)"
        
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
                        
                        let id = responseJson[i]["id"].string!
                        let nric = responseJson[i]["nric"].string!
                        let doctorName = responseJson[i]["doctorName"].string!
                        let date = responseJson[i]["date"].string!
                        let time = responseJson[i]["Time"].string!
                        
                        print("doctor name1 \(nric)")
                        print("nric1 \(doctorName)")
                        print("date1 \(date)")
                        print("time1 \(time)")
                        
                        
                        
                        let Appointment = AppointmentModel(id,nric,doctorName,date,time);
                        onComplete?(Appointment)
                    }
                    
                    
                    
                }
                
                
            }
            
        }
    }
    
    //Returns all records in Doctor table based on nric and doctorName
    func getDoctorTableByNricDocName( _ patientNric:String, _ doctorName:String ,onComplete:((_ DoctorModel: DoctorModel) -> Void)?) {
        
        
        
        let filteredDoctor = "patientNric eq '\(patientNric)' and doctorName eq '\(doctorName)' "
        
        let encodedfilteredDoctor = filteredDoctor.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        //Encoded Url
        let encodedUrl = "\(url2)?$filter=\(encodedfilteredDoctor!)"
        
        
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
                        
                        let id = responseJson[i]["id"].string!
                        let patientNric = responseJson[i]["patientNric"].string!
                        let patientName = responseJson[i]["patientName"].string!
                        let doctorName = responseJson[i]["doctorName"].string!
                        let date = responseJson[i]["date"].string!
                        let time = responseJson[i]["time"].string!
                        let doctorSpeciality = responseJson[i]["doctorSpeciality"].string!
                        
                        let Doctor = DoctorModel(id,patientNric,patientName,doctorName,date,time,doctorSpeciality);
                        onComplete?(Doctor)
                    }
                    
                    
                    
                }
                
                
            }
            
        }
    }

    
    
    //Returns all records in Doctor table based on nric
    func getDoctorTableByNric( _ patientNric:String, onComplete:((_ DoctorModel: DoctorModel) -> Void)?) {
        
        
        
        let filteredDoctor = "patientNric eq '\(patientNric)' "
        
        let encodedfilteredDoctor = filteredDoctor.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        //Encoded Url
        let encodedUrl = "\(url2)?$filter=\(encodedfilteredDoctor!)"
        
        
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
                        
                        let id = responseJson[i]["id"].string!
                        let patientNric = responseJson[i]["patientNric"].string!
                        let patientName = responseJson[i]["patientName"].string!
                        let doctorName = responseJson[i]["doctorName"].string!
                        let date = responseJson[i]["date"].string!
                        let time = responseJson[i]["time"].string!
                        let doctorSpeciality = responseJson[i]["doctorSpeciality"].string!
                        
                        let Doctor = DoctorModel(id,patientNric,patientName,doctorName,date,time,doctorSpeciality);
                        onComplete?(Doctor)
                    }
                    
                    
                    
                }
                
                
            }
            
        }
    }
    
    //Post a doctor record
    func postDoctorRecord(_ parameters: Parameters, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        
        
        //Post Request
        Alamofire.request(url2, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            
            //print(responseObject)
            
            //If results returns success
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
    
    //Delete a doctor record
    func DeleteDoctorRecord(_ azureTableId: String, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        
        let URL = "\(url2)/\(azureTableId)"
        //Post Request
        Alamofire.request(URL, method: .delete , encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            
            //print(responseObject)
            
            //If results returns success
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
    
    //Returns all records in Doctor table based on nric and doctorName
    func getDoctorTableByNricName( _ patientNric:String, _ doctorName:String ,onComplete:((_ DoctorModel: DoctorModel) -> Void)?) {
        
        
        
        let filteredDoctor = "patientNric eq '\(patientNric)' and doctorName eq '\(doctorName)' "
        
        let encodedfilteredDoctor = filteredDoctor.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        //Encoded Url
        let encodedUrl = "\(url2)?$filter=\(encodedfilteredDoctor!)"
        
        
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
                        
                        let id = responseJson[i]["id"].string!
                        let patientNric = responseJson[i]["patientNric"].string!
                        let patientName = responseJson[i]["patientName"].string!
                        let doctorName = responseJson[i]["doctorName"].string!
                        let date = responseJson[i]["date"].string!
                        let time = responseJson[i]["time"].string!
                        let doctorSpeciality = responseJson[i]["doctorSpeciality"].string!
                        
                        let Doctor = DoctorModel(id,patientNric,patientName,doctorName,date,time,doctorSpeciality);
                        onComplete?(Doctor)
                    }
                    
                    
                    
                }
                
                
            }
            
        }
    }
    
    //Returns all records in Doctor table based on nric and doctorName
    func getDoctorTableByAll( _ patientNric:String, _ doctorName:String ,  _ time:String ,  _ date:String ,onComplete:((_ DoctorModel: DoctorModel) -> Void)?) {
        
        
        
        let filteredDoctor = "patientNric eq '\(patientNric)' and doctorName eq '\(doctorName)' and time eq '\(time)' and date eq '\(date)' "
        
        let encodedfilteredDoctor = filteredDoctor.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        //Encoded Url
        let encodedUrl = "\(url2)?$filter=\(encodedfilteredDoctor!)"
        
        
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
                        
                        let id = responseJson[i]["id"].string!
                        let patientNric = responseJson[i]["patientNric"].string!
                        let patientName = responseJson[i]["patientName"].string!
                        let doctorName = responseJson[i]["doctorName"].string!
                        let date = responseJson[i]["date"].string!
                        let time = responseJson[i]["time"].string!
                        let doctorSpeciality = responseJson[i]["doctorSpeciality"].string!
                        
                        let Doctor = DoctorModel(id,patientNric,patientName,doctorName,date,time,doctorSpeciality);
                        onComplete?(Doctor)
                    }
                    
                    
                    
                }
                
                
            }
            
        }
    }


}
