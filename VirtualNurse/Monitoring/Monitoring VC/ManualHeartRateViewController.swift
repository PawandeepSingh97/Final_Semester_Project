//
//  ManualHeartRateViewController.swift
//  VirtualNurse
//
//  Created by Mohamed Imran on 1/2/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import UIKit
import fluid_slider
import Alamofire

class ManualHeartRateViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var heartLabel: UILabel!
    @IBOutlet weak var heartSlider: Slider!
    @IBOutlet weak var submitButton: UIButton!
    var slidervalue = 0
    
    //Patient Data
    var patient:Patient?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Call the custom slider function
        DesignCustomSlider()
        
        //Call the Design Button function
        DesignSubmitButton()
        
        //Set date for the label
        dateLabel.text = helperClass().setDateLabelCurrentDate()
        
        
        
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
        
//        //Show the navigation bar
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        //Show the tab bar
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        //Show the navigation bar
        self.navigationController?.isNavigationBarHidden = true
        
        //Return to the monitoring dashboard
        navigationController?.popViewController(animated: true)
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
                
                //Get the heartRate value
                let heartRateValue = Double(self.heartLabel.text!)
                
                //Check if heart rate is clocked in
                if (heartRateValue! > 0.0){
                    
                    //Declare updated parameters
                    let updatedParameters: Parameters = [
                        "heartRate": heartRateValue!,
                        ]
                    
                    //Update the heartRate in the monitoring record
                    MonitoringDataManager().patchMonitoringRecord(self.patient!,azureTableId,updatedParameters, success: { (success) in
                        print(success)
                    }) { (error) in
                        print(error)
                    }
                    
                    //Check if heart rate is in healthy range
                    if (heartRateValue! >= 60.0 && heartRateValue! <= 100.0){
                        self.showAlert(message: "Good Job! You have a healthy heart rate.")
                    }
                    else{
                        self.showAlert(message: "Please keep yourself healthy. You have a unhealthy heart rate")
                    }
                    
                }
                else{
                    self.showAlert(message: "Please clock in your heart rate again.")
                }
            }
        }
        
        
        
    }
    
    //Custom Design of Slider
    func DesignCustomSlider() {
        
        let labelTextAttributes: [NSAttributedStringKey : Any] = [.font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.white]
        heartSlider.attributedTextForFraction = { fraction in
            let formatter = NumberFormatter()
            formatter.maximumIntegerDigits = 3
            formatter.maximumFractionDigits = 0
            let string = formatter.string(from: (fraction * 400) as NSNumber) ?? ""
            self.sliderValueSelected(value: string)
            return NSAttributedString(string: string, attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.black])
            
        }
        heartSlider.setMinimumLabelAttributedText(NSAttributedString(string: "0", attributes: labelTextAttributes))
        heartSlider.setMaximumLabelAttributedText(NSAttributedString(string: "400", attributes: labelTextAttributes))
        heartSlider.fraction = 0.5
        heartSlider.shadowOffset = CGSize(width: 0, height: 10)
        heartSlider.shadowBlur = 5
        heartSlider.shadowColor = UIColor(white: 0, alpha: 0.1)
        heartSlider.contentViewColor = UIColor(hex: 0xE91E63)
        heartSlider.valueViewColor = .white
        heartSlider.didBeginTracking = { [weak self] _ in
            self?.setLabelHidden(true, animated: true)
        }
        heartSlider.didEndTracking = { [weak self] _ in
            self?.setLabelHidden(false, animated: true)
        }
        
    }
    
    //Custom Slider
    private func setLabelHidden(_ hidden: Bool, animated: Bool) {
        let animations = {
            //self.label.alpha = hidden ? 0 : 1
        }
        if animated {
            UIView.animate(withDuration: 0.11, animations: animations)
        } else {
            animations()
        }
    }
    
    //Get the value of the slider
    func sliderValueSelected(value: String){
        slidervalue = Int(value)!
        //Set the slider value text to label
        heartLabel.text = String(slidervalue)
        
        
    }
    
    
    
    //Designing a button programmatically
    func DesignSubmitButton(){
        // let borderAlpha : CGFloat = 0.7
        let cornerRadius : CGFloat = 5.0
        submitButton.frame = CGRect(x: 7, y: 660, width: 400, height: 50)
        submitButton.setTitle("SUBMIT", for: [])
        submitButton.setTitleColor(UIColor.white, for: [])
        submitButton.backgroundColor = UIColor(hex: 0xE91E63)
        submitButton.layer.cornerRadius = cornerRadius
        self.view.addSubview(submitButton)
    }
    
    //Alert
    func showAlert(message: String){
        DispatchQueue.main.async() {
            let alertController = UIAlertController(title: "Heart Rate Monitoring", message:
                message, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    

}
