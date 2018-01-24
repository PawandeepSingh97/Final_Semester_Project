//
//  CigaretteViewController.swift
//  VirtualNurse
//
//  Created by Mohamed Imran on 31/12/17.
//  Copyright © 2017 TeamSurvivor. All rights reserved.
//

import UIKit
import Alamofire

class CigaretteViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var totalCigarette: UILabel!
    var totalcountCigarette = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Call the Design Button function
        DesignSubmitButton()
        
        //Set date for the label
        dateLabel.text = helperClass().setDateLabelCurrentDate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Hide navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Show navigation bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    
    //Minus Cigarrette
    @IBAction func minusCigarette(_ sender: Any) {
        
        //If the count of cigarrette is not 0 then minus
        if (totalcountCigarette != 0){
            totalcountCigarette = totalcountCigarette - 1
            totalCigarette.text = String(totalcountCigarette)
        }
       
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        //return to monitoringdashboard
        navigationController?.popViewController(animated: true)
    }
    
    //Add Cigarrette
    @IBAction func addCigarette(_ sender: Any) {
        totalcountCigarette = totalcountCigarette + 1
        totalCigarette.text = String(totalcountCigarette)
    }
    
    //Submit Button Pressed
    @IBAction func submitButtonPressed(_ sender: Any) {
        print("\(totalcountCigarette) This is the totalcountCigarette")
        
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
                
                //Get the cig value
                let cigValue = Int(self.totalCigarette.text!)
                
        
                    //Declare updated parameters
                    let updatedParameters: Parameters = [
                        "cigsPerDay": cigValue!,
                        ]
                    
                    //Update the cigsPerDay in the monitoring record
                    MonitoringDataManager().patchMonitoringRecord(azureTableId,updatedParameters, success: { (success) in
                        print(success)
                    }) { (error) in
                        print(error)
                    }
                
                self.showAlert(message: "Inserted Successfully")
                
            }
        }
        

      
        
    }
    
    //Designing a button programmatically
    func DesignSubmitButton(){
        
        let borderAlpha : CGFloat = 0.7
        let cornerRadius : CGFloat = 5.0
        submitButton.frame = CGRect(x: 7, y: 500, width: 400, height: 50)
        submitButton.setTitle("SUBMIT", for: [])
        submitButton.setTitleColor(UIColor.white, for: [])
        submitButton.backgroundColor = UIColor(hex: 0xFF9800)
        submitButton.layer.cornerRadius = cornerRadius
        self.view.addSubview(submitButton)
    }
    
    
    //Alert
    func showAlert(message: String){
        DispatchQueue.main.async() {
        let alertController = UIAlertController(title: "Cigarette Monitoring", message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        }
    }

}
