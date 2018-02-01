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
    
    //Patient Data
    var patient:Patient?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Call DesignSubmitButton Function
        DesignSubmitButton()
   
        //Set delegates of textfield
        self.systolicBp.delegate = self;
        self.distolicBp.delegate = self;
        
        //Set date for the label
        dateLabel.text = helperClass().setDateLabelCurrentDate()
        
        //Add done button to keypad
        systolicBp.addDoneButtonToKeyboard(myAction:  #selector(self.systolicBp.resignFirstResponder))
        distolicBp.addDoneButtonToKeyboard(myAction:  #selector(self.distolicBp.resignFirstResponder))
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
        
        //Hide the tab bar
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Show the navigationbar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        //Show the tab bar
        self.tabBarController?.tabBar.isHidden = false
        
    }

    @IBAction func submitButtonClicked(_ sender: Any) {
        //Retrive patient nric and today's date
        let todayDate:String = helperClass().getTodayDate()
        let patientNric:String = (patient?.NRIC)!
        
        print("Patient Nric\(patientNric)")
        
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
                
                //Get the systolicbp value
                let systolicBpValue = Double(self.systolicBp.text!)
                //Get the distolicbp value
                let distolicBpValue = Double(self.distolicBp.text!)
                
                //Check if systolicBp and distolicBp is clocked in
                if (self.systolicBp.text!.isEmpty || self.distolicBp.text!.isEmpty){
                    self.showAlert(message: "Please check if you have entered systolicBp and distolicBp value.")
                }
                //Check if systolicBp and distolicBp is clocked in
                else if (systolicBpValue! < 90 || distolicBpValue! < 40){
                    self.showAlert(message: "Please check whether you entered valid systolicBp and distolicBp value.")
                }
                //Check if systolicBp and distolicBp is clocked in
                else if (systolicBpValue! > 240 || distolicBpValue! > 160){
                   self.showAlert(message: "Please check whether you entered valid systolicBp and distolicBp value.")
                }
                else{
                    
                    //Declare updated parameters
                    let updatedParameters: Parameters = [
                        "systolicBloodPressure": systolicBpValue!,
                        "diastolicBloodPressure": distolicBpValue!,
                    ]
                    
                    //Update the systolicBp and distolicBp in the monitoring record
                    MonitoringDataManager().patchMonitoringRecord(self.patient!,azureTableId,updatedParameters, success: { (success) in
                        print(success)
                    }) { (error) in
                        print(error)
                    }
                    
                    self.showAlert(message: "Inserted Successfully")
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

extension UITextField{
    
    func addDoneButtonToKeyboard(myAction:Selector?){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: myAction)
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
}
