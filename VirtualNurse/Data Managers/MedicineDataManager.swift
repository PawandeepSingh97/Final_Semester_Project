//
//  MedicineDataManager.swift
//  mediTrack
//
//  Created by SURA's MacBookAir on 9/1/18.
//  Copyright © 2018 SURA's MacBookAir. All rights reserved.
//
import UIKit
import Foundation
import Alamofire


class MedicineDataManager : NSObject {
    
    //Declare a var to store the JSON response
  //  var jsonResponse:JSON = []
  //  var jsonResponse : JSON = []
    
    var jsonResponse : JSON = []
    
    
    //Declaring and Initialising HTTP headers
    let headers: HTTPHeaders = [
        "Content-Type": "application/json",
        "Accept": "application/json",
        "ZUMO-API-VERSION": "2.0.0"
    ]
    
    //Declaring and Initialising URL of Microsoft Azure database
    let url:String = "http://pawandeep-virtualnurse.azurewebsites.net/tables/Medication"
    
    
    //Declaring and Initialising Microsoft Azure table unique id
    //let azureTableId:String = "a55c6e5a-5b65-483f-9886-543f6d1e8702"
    
    //Returns all records in medicine infomation table based on name
    
    func getMedicineRecordsByName(_ medicineName : String, onComplete:((_ MedicineModel : MedicineModel) -> Void)?)   {
        
        let filteredMedicineName = "medName eq '\(medicineName)'"
        
        let encodedMedicineName = filteredMedicineName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let encodedUrl = "\(url)?$filter=\(encodedMedicineName!)"
        
        Alamofire.request(encodedUrl, headers: headers).responseJSON { (responseObject) -> Void in
            
            if responseObject.result.isSuccess {
                
                let responseJson = JSON(responseObject.result.value!)
                
                if responseJson != [] {
                    
                    print("Response JSON \(responseJson)")
                    
                    print(" result value \(responseJson.count)")
                    
                    for i in 0..<(responseJson.count){
                        
                        let id = responseJson[i]["id"].string!
                        let medName = responseJson[i]["medName"].string!
                        let medDescription = responseJson[i]["medDescription"].string!
                        let medPrecaution = responseJson[i]["medPrecaution"].string!
                        let medSideEffects = responseJson[i]["medSideEffects"].string!
                        let medCI = responseJson[i]["medCI"].string!
                        let medDosage = responseJson[i]["medDosage"].string!
                        
                        print("\(medDosage) mg")
                        
                        
//                        let Medicine = MedicineModel(id, medName, medDescription, medPrecaution, medSideEffects, medCI, medDosage);
                        
                        
                         let Medicine = MedicineModel(id, medName, medDescription, medDosage, medPrecaution, medSideEffects, medCI);
                        
                        onComplete?(Medicine)
                        
                        //(_ id : String,_ medicineName : String, _ medicineDesc : String, _ medicineDosage: String, _ medicinePrecautions: String, _ medicineSideEffects : String
                      //  , _ consumptionInstructions  : String)
                    }
                }
            }
        }
    }
    
    
    func getAllMedication( onComplete:((_ MedicineModel: MedicineModel) -> Void)?) {

     
        //Get request
        Alamofire.request(url, headers: headers).responseJSON { (responseObject) -> Void in
            print(responseObject.result.isSuccess)

            print("Entered")

            if responseObject.result.isSuccess {


                let responseJson = JSON(responseObject.result.value!)

                //Check if responseJson is empty
                if responseJson != []{
                    print("RESPONSE JSON\(responseJson)")
                    //Extract Json

                    print(" result value\(responseJson.count)")

                    for i in 0..<(responseJson.count){


                        let id = responseJson[i]["id"].string!
                        let medName = responseJson[i]["medName"].string!
                        let medDescription = responseJson[i]["medDescription"].string!
                        let medPrecaution = responseJson[i]["medPrecaution"].string!
                        let medSideEffects = responseJson[i]["medSideEffects"].string!
                        let medCI = responseJson[i]["medCI"].string!
                        let medDosage = responseJson[i]["medDosage"].string!


                        print("What the data returned to us :  \(responseJson[i])")


                        let Medication = MedicineModel(id ,medName ,  medDescription ,medDosage, medPrecaution, medSideEffects
                            ,  medCI)
                        
                        print(medName)
                        onComplete?(Medication)
                    }

                }

            }


        }
    }
    

 
}
