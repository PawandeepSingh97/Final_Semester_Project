//
//  GlucoseViewController.swift
//  VirtualNurse
//
//  Created by Mohamed Imran on 1/1/18.
//  Copyright © 2018 TeamSurvivor. All rights reserved.
//

import UIKit
import fluid_slider
import Alamofire

class GlucoseViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var glucoseValueLabel: UILabel!
    @IBOutlet weak var glucoseSlider: Slider!
    @IBOutlet weak var submitButton: UIButton!
    var slidervalue = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Call the Design Submit Button Function
        DesignSubmitButton()
        
        //Call the Custom Slider
        DesignCustomSlider()
        
        //Set date for the label
        dateLabel.text = helperClass().setDateLabelCurrentDate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Hide the navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Show the navigation bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    
    //When submit button is clicked
    @IBAction func submitButtonClicked(_ sender: Any) {
        
//        //Retrive patient nric and today's date
//        let todayDate:String = helperClass().getTodayDate()
//        let patientNric:String = helperClass().getPatientNric()
//
//        //Call the getFilteredMonitoringRecords in MonitoringDataManager to retrieve specific id in the monitoring records
//        MonitoringDataManager().getFilteredMonitoringRecords(todayDate, patientNric) { (monitoring) in
//
//            //Retrieved results from Database
//            let retrievedPatientNric = monitoring.nric
//            let retrievedDateCreated = monitoring.dateCreated
//
//            //If record exists in database
//            if (retrievedPatientNric == patientNric && retrievedDateCreated == todayDate){
//                print("record exists")
//
//                //Get the azure table unique id
//                let azureTableId = monitoring.id
//
//                //Get the glucose value
                let glucoseValue = Int(self.glucoseValueLabel.text!)
                 MonitoringController().sumbitMonitoringValues(monitoringName:"glucose",monitoringValue: glucoseValue!)
//
//
//                    //Declare updated parameters
//                    let updatedParameters: Parameters = [
//                        "glucose": glucoseValue!,
//                        ]
//
//                    //Update the glucose in the monitoring record
//                    MonitoringDataManager().patchMonitoringRecord(azureTableId,updatedParameters, success: { (success) in
//                        print(success)
//                    }) { (error) in
//                        print(error)
//                    }
//
                    //Check if glucose is in healthy range
                    if (glucoseValue! >= 70 && glucoseValue! <= 100){
                        self.showAlert(message: "Good Job! You have a healthy glucose level")
                    }
                    else {
                        self.showAlert(message: "Please keep yourself healthy. You are having a unhealthy glucose level")
                    }
//
//            }
//        }
    }
    
    //When back button is tapped
    @IBAction func backButtonTapped(_ sender: Any) {
        //return to monitoring dashboard
        navigationController?.popViewController(animated: true)
    }
    
    //Custom Design of Slider
    func DesignCustomSlider() {
        
        let labelTextAttributes: [NSAttributedStringKey : Any] = [.font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.white]
        glucoseSlider.attributedTextForFraction = { fraction in
            let formatter = NumberFormatter()
            formatter.maximumIntegerDigits = 3
            formatter.maximumFractionDigits = 0
            let string = formatter.string(from: (fraction * 400) as NSNumber) ?? ""
            self.sliderValueSelected(value: string)
            return NSAttributedString(string: string, attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.black])
            
        }
        glucoseSlider.setMinimumLabelAttributedText(NSAttributedString(string: "0", attributes: labelTextAttributes))
        glucoseSlider.setMaximumLabelAttributedText(NSAttributedString(string: "400", attributes: labelTextAttributes))
        glucoseSlider.fraction = 0.5
        glucoseSlider.shadowOffset = CGSize(width: 0, height: 10)
        glucoseSlider.shadowBlur = 5
        glucoseSlider.shadowColor = UIColor(white: 0, alpha: 0.1)
        glucoseSlider.contentViewColor = UIColor(hex: 0x3F51B5)
        glucoseSlider.valueViewColor = .white
        glucoseSlider.didBeginTracking = { [weak self] _ in
            self?.setLabelHidden(true, animated: true)
        }
        glucoseSlider.didEndTracking = { [weak self] _ in
            self?.setLabelHidden(false, animated: true)
        }
        
    }
    
    //Custom slider
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
        //Get the value of the slider
        slidervalue = Int(value)!
        
        //Set the slider value text to label
        glucoseValueLabel.text = String(slidervalue)
        
        
    }
    
     //Designing a button programmatically
    func DesignSubmitButton(){
        let borderAlpha : CGFloat = 0.7
        let cornerRadius : CGFloat = 5.0
        submitButton.frame = CGRect(x: 7, y: 660, width: 400, height: 50)
        submitButton.setTitle("SUBMIT", for: [])
        submitButton.setTitleColor(UIColor.white, for: [])
        submitButton.backgroundColor = UIColor(hex: 0x3F51B5)
        submitButton.layer.cornerRadius = cornerRadius
        self.view.addSubview(submitButton)
    }
    
    //Show Alert
    func showAlert(message: String){
        DispatchQueue.main.async() {
            let alertController = UIAlertController(title: "Glucose Monitoring", message:
                message, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    

}

extension UIColor {
    
    convenience init(hex:Int, alpha:CGFloat = 1.0) {
        self.init(
            red:   CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8)  / 255.0,
            blue:  CGFloat((hex & 0x0000FF) >> 0)  / 255.0,
            alpha: alpha
        )
    }
    
}
