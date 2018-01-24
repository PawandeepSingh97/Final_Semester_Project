//
//  MedicineModel.swift
//  mediTrack
//
//  Created by SURA's MacBookAir on 8/1/18.
//  Copyright © 2018 SURA's MacBookAir. All rights reserved.
//

import Foundation


class MedicineModel {
    
    
    //    var rowName = ["Description","Dosage","Precautions","Side Effects","Consumption Instructions"]
    var id  : String;
    var medicineName : String = ""
    var medicineDesc : String = ""
    var medicineDosage : String = ""
    var medicinePrecautions : String = ""
    var medicineSideEffects : String = ""
    var consumptionInstructions : String = ""
    
    init(_ id : String,_ medicineName : String, _ medicineDesc : String, _ medicineDosage: String, _ medicinePrecautions: String, _ medicineSideEffects : String
        , _ consumptionInstructions  : String) {
        
        
    self.id = id
    self.medicineName = medicineName
    self.medicineDesc = medicineDesc
    self.medicineDosage = medicineDosage
    self.medicinePrecautions = medicinePrecautions
    self.medicineSideEffects = medicineSideEffects
    self.consumptionInstructions = consumptionInstructions
        
        
    
    }
    

//    init(_ medicineName : String, _ medicineDesc : String, _ medicineDosage: String, _ medicinePrecautions: String, _ medicineSideEffects : String
//        , _ consumptionInstructions  : String) {
//        
//        
//        
//        self.medicineName = medicineName
//        self.medicineDesc = medicineDesc
//        self.medicineDosage = medicineDosage
//        self.medicinePrecautions = medicinePrecautions
//        self.medicineSideEffects = medicineSideEffects
//        self.consumptionInstructions = consumptionInstructions
//        
//        
//        
//    }
    
}
