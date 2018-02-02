//
//  medicineDetailController.swift
//  mediTrack
//
//  Created by SURA's MacBookAir on 23/1/18.
//  Copyright © 2018 SURA's MacBookAir. All rights reserved.
//

import UIKit

class medicineDetailController: UIViewController {

    // IBOutlets
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var dosageLbl: UILabel!
    @IBOutlet weak var precautionLbl: UILabel!
    @IBOutlet weak var sideEffectLbl: UILabel!
    @IBOutlet weak var ciLbl: UILabel!
    
    @IBOutlet weak var shareBtn: UIButton!
    var recievedArray : [String] = [String]()

    
    var medNames : String = ""
    var rowValues : [String] = [String]()
    let loadValues = "Loading..."
    
    override func viewDidLoad() {
        super.viewDidLoad()
         validatorFuncs()
        getMedicineDetails()
        
        shareBtn.layer.cornerRadius = 10.0
       

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        nameLbl.text? = medNames
       // validatorFuncs()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func uniqueElementsFrom<T: Hashable>(array: [T]) -> [T] {
        var set = Set<T>()
        let result = array.filter {
            guard !set.contains($0) else {
                return false
            }
            set.insert($0)
            return true
        }
        return result
    }
    
    func validatorFuncs(){
        
        MedicineDataManager().getAllMedication { (Medicine) in
            
            self.recievedArray.append(Medicine.medicineName)
            
            let uniqueMedicine = self.uniqueElementsFrom(array: self.recievedArray)
            
            for medicineChecker in uniqueMedicine {
                
                if   self.descriptionLbl.text != " " {
                    print("Correct Medicine Name!")
                }
                
               
        //       print("Hustlers108 HAI LOK SAN")
              //  else {
//                if (self.recievedArray.isEmpty == true){
//                    print("Error!")
//
//                    let alert = UIAlertController(title: "Please try again", message: "Try capturing the pill in a well - lit area & make sure it is a Diabetic medication. Thank You!", preferredStyle: UIAlertControllerStyle.alert)
//                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
//                    alert.addAction(UIAlertAction(title: "GO Back", style: UIAlertActionStyle.default, handler: { (_) in
//                        self.navigationController?.popViewController(animated: true);
//                    }))
//                    self.present(alert, animated: true, completion: nil)
//
//                  //  LoadingIndicatorView.hide()
//              //  }
//                }
//
//                else {
//                    print("Salah")
//                }
            }
//            if uniqueMedicine.contains("") == true {
//                
//                self.navigationController?.popViewController(animated: true);
//            }
        }
        
        
    }
    
    
    // function which which retrieves medicine object from database via model
    
    func getMedicineDetails() {
        
        LoadingIndicatorView.show(loadValues)
        
        MedicineDataManager().getMedicineRecordsByName(medNames) { (Medicine) in
            
            
            print("Meance of Society")
            
            
            self.descriptionLbl.text = Medicine.medicineDesc
            self.dosageLbl.text = Medicine.medicineDosage
            self.precautionLbl.text = Medicine.medicinePrecautions
            self.sideEffectLbl.text = Medicine.medicineSideEffects
            self.ciLbl.text = Medicine.consumptionInstructions
            
            
            // appends array from medicine objects
            self.rowValues = ["\(Medicine.medicineDesc)","\(Medicine.medicineDosage)","\(Medicine.medicinePrecautions)","\(Medicine.medicineSideEffects)","\(Medicine.consumptionInstructions)"]
            
            //testing purposes, please ignore
            print("Imran \(self.rowValues)")
            
            LoadingIndicatorView.hide()
            
            print("Boyz n the Hood")
            
            
            
        }
        // send the medicine name parameter to data manager
       
    }
    
    @IBAction func shareBtn(_ sender: Any) {
        
        // text to share
        // set up activity view controller
        let textToShare = rowValues
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    

}
