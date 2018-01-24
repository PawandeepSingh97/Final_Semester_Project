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
    
    
    var medNames : String = ""
    var rowValues : [String] = [String]()
    let loadValues = "Loading..."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMedicineDetails()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        nameLbl.text? = medNames
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // function which which retrieves medicine object from database via model
    
    func getMedicineDetails() {
        
        
        LoadingIndicatorView.show(loadValues)
        
        // send the medicine name parameter to data manager
        MedicineDataManager().getMedicineRecordsByName(medNames) { (Medicine)  in
            
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
        }
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
