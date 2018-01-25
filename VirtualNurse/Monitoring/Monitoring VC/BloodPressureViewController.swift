//
//  BloodPressureViewController.swift
//  VirtualNurse
//
//  Created by Mohamed Imran on 1/1/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import UIKit
import TextFieldEffects
import Alamofire

class BloodPressureViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var measureButton: UIButton!
    @IBOutlet weak var systolicBp: JiroTextField!
    @IBOutlet weak var distolicBp: JiroTextField!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Call DesignSubmitButton Function
        DesignSubmitButton()
   
        //Set delegates of textfield
        self.systolicBp.delegate = self;
        self.distolicBp.delegate = self;
        
        //Set date for the label
        dateLabel.text = helperClass().setDateLabelCurrentDate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Close the textfield after pressing return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Hide the navigationbar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Show the navigationbar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }

    @IBAction func submitButtonClicked(_ sender: Any) {
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
                
                //Get the systolicbp value
                let systolicBpValue = Double(self.systolicBp.text!)
                //Get the distolicbp value
                let distolicBpValue = Double(self.distolicBp.text!)
                
                //Check if systolicBp and distolicBp is clocked in
                if (self.systolicBp.text!.isEmpty && self.distolicBp.text!.isEmpty){
                    self.showAlert(message: "Please check if you have entered systolicBp and distolicBp value.")
                }
                else{
                    
                    //Declare updated parameters
                    let updatedParameters: Parameters = [
                        "systolicBloodPressure": systolicBpValue!,
                        "diastolicBloodPressure": distolicBpValue!,
                    ]
                    
                    //Update the systolicBp and distolicBp in the monitoring record
                    MonitoringDataManager().patchMonitoringRecord(azureTableId,updatedParameters, success: { (success) in
                        print(success)
                    }) { (error) in
                        print(error)
                    }
                    
                    //Check if systolicBp and distolicBp is in healthy range
                    if (systolicBpValue! < 120 && distolicBpValue! < 80){
                        self.showAlert(message: "Good Job! You have a healthy systolicBp and distolicBp")
                    }
                    else if(systolicBpValue! > 140 && distolicBpValue! < 90){
                        self.showAlert(message: "Please keep yourself healthy. You are having high blood pressure")
                    }
                    else{
                        self.showAlert(message: "Inserted Successfully")
                    }
                }
            }
        }

    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        //Return to monitoring dashboard
         navigationController?.popViewController(animated: true)
    }
    
    //Designing a button programmatically
    func DesignSubmitButton(){
       // let borderAlpha : CGFloat = 0.7
        let cornerRadius : CGFloat = 5.0
        measureButton.frame = CGRect(x: 7, y: 660, width: 400, height: 50)
        measureButton.setTitle("SUBMIT", for: [])
        measureButton.setTitleColor(UIColor.white, for: [])
        measureButton.backgroundColor = UIColor(hex: 0xF44336)
        measureButton.layer.cornerRadius = cornerRadius
        self.view.addSubview(measureButton)
    }
    
    //Show Alert
    func showAlert(message: String){
        DispatchQueue.main.async() {
            let alertController = UIAlertController(title: "Blood Pressure Monitoring", message:
                message, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    


}
