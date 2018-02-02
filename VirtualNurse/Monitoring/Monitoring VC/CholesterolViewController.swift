//
//  CholesterolViewController.swift
//  VirtualNurse
//
//  Created by Mohamed Imran on 31/12/17.
//  Copyright © 2017 TeamSurvivor. All rights reserved.
//

import UIKit
import fluid_slider
import Alamofire

class CholesterolViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cholesterolLabel: UILabel!
    @IBOutlet weak var cholesterolSlider: Slider!
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
        
        //Show the navigation bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        //Show the tab bar
        self.tabBarController?.tabBar.isHidden = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        //Return to the monitoring dashboard
         navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        
         let cholesterolValue = Int(self.cholesterolLabel.text!)

        

                //Check if cholesterolValue is in healthy range
                if (cholesterolValue! >= 70 && cholesterolValue! <= 100){
                    self.showAlert(message: "Cholesterol value inserted successfully.")
                    MonitoringController().sumbitMonitoringValues(patient:self.patient!,monitoringName:"totalCholesterol", monitoringValue: cholesterolValue!)
                }
                else if (cholesterolValue! < 70){
                    self.showAlert(message: "Please check whether you entered valid cholesterol value.")
                }
                    //Check if cholesterol is in healthy range
                else if (cholesterolValue! > 200){
                    self.showAlert(message: "Please check whether you entered valid cholesterol value.")
                }
                    //Check if cholesterol is in healthy range
                 else {
                    self.showAlert(message: "cholesterol value inserted successfully.")
                    MonitoringController().sumbitMonitoringValues(patient:self.patient!,monitoringName:"totalCholesterol", monitoringValue: cholesterolValue!)
                   }

        
    }
    
    //Custom Design of Slider
    func DesignCustomSlider() {
        
        let labelTextAttributes: [NSAttributedStringKey : Any] = [.font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.white]
        cholesterolSlider.attributedTextForFraction = { fraction in
            let formatter = NumberFormatter()
            formatter.maximumIntegerDigits = 3
            formatter.maximumFractionDigits = 0
            let string = formatter.string(from: (fraction * 400) as NSNumber) ?? ""
            self.sliderValueSelected(value: string)
            return NSAttributedString(string: string, attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .bold), .foregroundColor: UIColor.black])
            
        }
        cholesterolSlider.setMinimumLabelAttributedText(NSAttributedString(string: "0", attributes: labelTextAttributes))
        cholesterolSlider.setMaximumLabelAttributedText(NSAttributedString(string: "400", attributes: labelTextAttributes))
        cholesterolSlider.fraction = 0.5
        cholesterolSlider.shadowOffset = CGSize(width: 0, height: 10)
        cholesterolSlider.shadowBlur = 5
        cholesterolSlider.shadowColor = UIColor(white: 0, alpha: 0.1)
        cholesterolSlider.contentViewColor = UIColor(hex: 0x9C27B0)
        cholesterolSlider.valueViewColor = .white
        cholesterolSlider.didBeginTracking = { [weak self] _ in
            self?.setLabelHidden(true, animated: true)
        }
        cholesterolSlider.didEndTracking = { [weak self] _ in
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
        cholesterolLabel.text = String(slidervalue)
        
        
    }
    
   
    
    //Designing a button programmatically
    func DesignSubmitButton(){
       // let borderAlpha : CGFloat = 0.7
        let cornerRadius : CGFloat = 5.0
        submitButton.frame = CGRect(x: 7, y: 660, width: 400, height: 50)
        submitButton.setTitle("SUBMIT", for: [])
        submitButton.setTitleColor(UIColor.white, for: [])
        submitButton.backgroundColor = UIColor(hex: 0x9C27B0)
        submitButton.layer.cornerRadius = cornerRadius
        self.view.addSubview(submitButton)
    }
    
    //Alert
    func showAlert(message: String){
        DispatchQueue.main.async() {
            let alertController = UIAlertController(title: "Cholesterol Monitoring", message:
                message, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    

 

}
