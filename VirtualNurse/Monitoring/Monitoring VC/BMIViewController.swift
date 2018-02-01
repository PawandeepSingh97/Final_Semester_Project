//
//  BMIViewController.swift
//  VirtualNurse
//
//  Created by Mohamed Imran on 1/1/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import UIKit
import TextFieldEffects
import Alamofire

class BMIViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var heightTextField: JiroTextField!
    @IBOutlet weak var weightTextField: JiroTextField!
    @IBOutlet weak var bmiValue: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    //Patient Data
    var patient:Patient?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //Call the Design Button function
        DesignSubmitButton()
        
        //Set the delegate for textfield
        self.heightTextField.delegate = self
        self.weightTextField.delegate = self
        
        //Add textfield action
        weightTextField.addTarget(self, action: #selector(BMIViewController.textFieldDidChange(_:)),
                            for: UIControlEvents.editingChanged)
        
        //Set date for the label
        dateLabel.text = helperClass().setDateLabelCurrentDate()
        
        //Add done button to keypad
        heightTextField.addDoneButtonToKeyboard(myAction:  #selector(self.heightTextField.resignFirstResponder))
        weightTextField.addDoneButtonToKeyboard(myAction:  #selector(self.weightTextField.resignFirstResponder))
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Hide the navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        //Hide the tab bar
        self.tabBarController?.tabBar.isHidden = true

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Show the navigation bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        //Show the tab bar
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        //Retrive patient nric and today's date
        let todayDate:String = helperClass().getTodayDate()
        let patientNric:String = (patient?.NRIC)!
        
        //Call the getFilteredMonitoringRecords in MonitoringDataManager to retrieve specific id in the monitoring records
        MonitoringDataManager().getFilteredMonitoringRecords(todayDate, patient!) { (monitoring) in
            
            //Retrieved results from Database
            let retrievedPatientNric = monitoring.nric
            let retrievedDateCreated = monitoring.dateCreated
            
            //If record exists in database
            if (retrievedPatientNric == patientNric && retrievedDateCreated == todayDate){
                print("record exists")
                
                //Get the azure table unique id
                let azureTableId = monitoring.id
                
                //Get the BMI value
                let BMI = Double(self.bmiValue.text!)!
                
                //Check if heightValue and weightValue is clocked in
                if (self.heightTextField.text!.isEmpty && self.weightTextField.text!.isEmpty){
                    self.showAlert(message: "Please check if you have entered height and weight value.")
                }
                //Check if the textfield are empty
                else if((self.heightTextField.text?.isEmpty)! || (self.weightTextField.text?.isEmpty)!){
                    //showAlert(message: "Please check your inputs")
                    self.showAlert(message: "Please check if you have entered height and weight value.")
                    self.bmiValue.text = "0"
                }
                else if !(self.heightTextField.text?.contains("."))!
                {
                    self.showAlert(message: "Please check if you have entered height meteres")
                    self.bmiValue.text = "0"
                }
                else{

                    //Declare updated parameters
                    let updatedParameters: Parameters = [
                        "bmi": BMI,
                        ]
                    
                    //Update the systolicBp and distolicBp in the monitoring record
                    MonitoringDataManager().patchMonitoringRecord(self.patient!,azureTableId,updatedParameters, success: { (success) in
                        print(success)
                    }) { (error) in
                        print(error)
                    }
                    
                    
                    
                    //Check if bmi is in healthy range
                    if (BMI < 18.5){
                        self.showAlert(message: "You are BMI is considered as underweight.")
                    }
                    else if(BMI >= 18.5 && BMI <= 24.9){
                        self.showAlert(message: "Good Job. Your bmi is in a healthy range")
                    }
                    else if(BMI >= 25 && BMI <= 29.9){
                        self.showAlert(message: "You are BMI is considered as overweight.")
                    }
                    else if(BMI >= 30){
                        self.showAlert(message: "You are BMI as considered obese.")
                    }
                }
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        //Check if the textfield are empty
        if((heightTextField.text?.isEmpty)! || (weightTextField.text?.isEmpty)!){
            //showAlert(message: "Please check your inputs")
            bmiValue.text = "0"
        }
        else{
            if (Double(weightTextField.text!) == nil){
                
            }
            else{
                //Calculating BMI
                var bmi:Double = Double(weightTextField.text!)! / Double(heightTextField.text!)!
                bmi = bmi / Double(heightTextField.text!)!
                
                //Setting the BMI value to text
                bmiValue.text = String(Int(bmi))
            }
            
        
        }
    }
    
    //Close the textfield after pressing return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
   
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        //Return to monitoring dashboard
        navigationController?.popViewController(animated: true)
        //Navigation to new page

    }
    
    //Designing a button programmatically
    func DesignSubmitButton(){
       // let borderAlpha : CGFloat = 0.7
        let cornerRadius : CGFloat = 5.0
        submitButton.frame = CGRect(x: 7, y: 660, width: 400, height: 50)
        submitButton.setTitle("SUBMIT", for: [])
        submitButton.setTitleColor(UIColor.white, for: [])
        submitButton.backgroundColor = UIColor(hex: 0x009688)
        submitButton.layer.cornerRadius = cornerRadius
        self.view.addSubview(submitButton)
    }
    
    //Show Alert
    func showAlert(message: String){
        DispatchQueue.main.async() {
            let alertController = UIAlertController(title: "BMI Monitoring", message:
                message, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

